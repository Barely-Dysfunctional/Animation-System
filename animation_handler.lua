--TODO
--speed
--fps
--repeating


function init()
    --DebugPrint("hi")
    origin = FindBody("origin")
    bodies = FindBodies("id")
    rig = SortByID(bodies)

    name = GetStringParam("name", "handler")
    key = "level.animhandlers."..name
    if HasKey(key) then
        num = 2
        while HasKey(key..num) do
            num = num + 1
        end
        key = key..num
    end

    SetString(key..".controls.animation", "none")
    SetInt(key..".controls.change", 0)
    --will change current animation into one specified in controls.animation
    --0: do nothing, 1: change instantly, 2: change when animation ends, 3: change after current frame


    currentAnim = "none"
    frame = 1
    timer = 0
    frametimer = 0

    repeating = true
    framerate = 60
    --DebugPrint("bye")
end

function tick(dt)

    DebugWatch("change registry", GetInt(key..".controls.change"))
    changeValue = GetInt(key..".controls.change")

    if changeValue ~= 0 then

        if currentAnim == "none" then --make sure it always turns on instantly so it doesnt get stuck
            currentAnim = GetString(key..".controls.animation")
            SetInt(key..".controls.change", 0)

        elseif changeValue == 1 then 
            currentAnim = GetString(key..".controls.animation")
            SetInt(key..".controls.change", 0)

        elseif changeValue == 2 then
            if frame >= #values then
                currentAnim = GetString(key..".controls.animation")
                SetInt(key..".controls.change", 0)
            end

        elseif changeValue == 3 then
            if frametimer == 0 then
                currentAnim = GetString(key..".controls.animation")
                SetInt(key..".controls.change", 0)
            end

        end

        if currentAnim ~= "none" then
            values = DeRegisterAnimation(currentAnim)
        end

        --DebugPrint(name.." changed animation to "..currentAnim)
    end
    
    --DebugWatch("currentanim registry", GetString(key..".controls.animation"))
    --DebugWatch("currentanim handlerside", currentAnim)



    
    if currentAnim ~= "none" then
        
        if frame >= #values and repeating then
            frame = 1
        end

        if frame < #values then
            timer = timer + dt
            frametimer = frametimer + dt
            frame, frametimer = animate(frame, frametimer, dt, values, rig, repeating)
        end
        --DebugWatch("current animation", currentAnim)
        --DebugPrint(frame)
    end
end



function animate(currentKeyframe, frametimer, dt, values, rig, repeating)

    --if currentKeyframe < #values then
        --DebugPrint(#values)
        framevalues = values[currentKeyframe]
        
        frametime = framevalues[1]
        --DebugPrint(frametime)
        prog = math.min(frametimer / frametime, 1)

        if timer > (1/framerate) then
            originTrans = GetBodyTransform(origin)

            for id, objectValues in ipairs(framevalues[2]) do

                currentTrans = values[currentKeyframe][2][id][3]
                nextTrans = values[currentKeyframe + 1][2][id][3]

                posEase = values[currentKeyframe][2][id][1]
                rotEase = values[currentKeyframe][2][id][2]
                --DebugPrint(posEase)

                SetBodyDynamic(rig[id], false)

                startTrans = TransformToParentTransform(originTrans, currentTrans)
                endTrans = TransformToParentTransform(originTrans, nextTrans)  

                newPos = VecLerp(startTrans.pos, endTrans.pos, Interpolate(prog, posEase))
                newRot = QuatSlerp(startTrans.rot, endTrans.rot, Interpolate(prog, rotEase))

                SetBodyTransform(rig[id], Transform(newPos, newRot))

                DebugCross(startTrans.pos)
                DebugCross(endTrans.pos)
                DebugCross(newPos, 1, 0, 0, 1)
            end

            --DebugPrint("timer go bye")
            timer = 0
        end

        if prog == 1 then
            --DebugPrint("hi")
            frametimer = 0
            currentKeyframe = currentKeyframe + 1
            --if (currentKeyframe >= #values) and repeating then
            --    currentKeyframe = 1
            --end
        end

        --DebugWatch("prog", prog)
        --DebugWatch("currentKeyframe", currentKeyframe)
        --DebugWatch("frametimer", frametimer)
        --DebugWatch("frametime", frametime)
        --DebugWatch("timer", timer)
        

        return currentKeyframe, frametimer

    --else
    --    if repeating then
    --        currentKeyframe = 1
    --    end
    --    
    --    return currentKeyframe, 0
    --end
end

function SortByID(bodies)
    local newTable = {}
    for i=1, #bodies do
        table.insert(newTable, 0)
    end

    for i, body in ipairs(bodies) do
        local id = tonumber(GetTagValue(body, "id"))
        newTable[id] = body
    end

    return newTable
end

function DeRegisterAnimation(name)
    local values = {}

    local key = "level.animations."..name
    --DebugPrint(key)

    for framenum=1, #ListKeys(key..".frames") do
        framekey = key..".frames.frame"..framenum
        --DebugPrint(framekey)

        local time = GetFloat(framekey..".time")
        values[framenum] = {time, {}}

        for id=1, #ListKeys(framekey..".bodies") do
            local bodykey = framekey..".bodies.body"..id
            --DebugPrint(bodykey)
            local posEasing = GetString(bodykey..".posease")
            local rotEasing = GetString(bodykey..".rotease")

            local pos = Vec(GetFloat(bodykey..".x"), GetFloat(bodykey..".y"), GetFloat(bodykey..".z"))
            local rot = Quat(GetFloat(bodykey..".qx"), GetFloat(bodykey..".qy"), GetFloat(bodykey..".qz"), GetFloat(bodykey..".qw"))
            local trans = Transform(pos, rot)

            values[framenum][2][id] = {posEasing, rotEasing, trans}
            --DebugPrint(TransformStr(trans))
        end
    end

    return values
end

function Interpolate(t, style)
    --mostly taken from easings.net

    if style == "easeIn" then
        t = t^4

    elseif style == "easeOut" then
        t = 1-((1-t)^4)

    elseif style == "easeInOutSine" then
        t = (math.cos(math.pi*(t-1)) + 1) / 2


    elseif style == "easeInBack" then
        c1 = 1.70158
        c3 = c1 + 1
        t = (c3*(t^3)) - (c1*(t^2))

    elseif style == "easeOutBack" then
        c1 = 1.70158
        c3 = c1 + 1
        t = 1 + (c3*((t-1)^3)) + (c1 * ((t-1)^2))

    elseif style == "easeInOutBack" then

        c1 = 1.70158
        c2 = c1 * 1,525
        if t < 0.5 then
            t = (((2*t)^2) * ((c2+1)*2*t-c2))/2

        else
            t = (((2*t-2)^2) * ((c2+1)*(t*2-2)+c2)+2)/2
        end
    end

    --idk
    --t = t*((t-2)^2)

    --t = (t^2)*((t-2)^2)
    --DebugPrint(t)

    return t
end