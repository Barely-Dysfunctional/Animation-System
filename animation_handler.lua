--TODO
--speed
--some nice way to control this

function init()
    --DebugPrint("hi")
    origin = FindBody("origin")
    bodies = FindBodies("id")
    rig = SortByID(bodies)


    names = {"test", "test2", "test3"}
    currentAnim = 1
    values = DeRegisterAnimation(names[currentAnim])



    active = false
    frame = 1
    timer = 0
    frametimer = 0

    repeating = true
    framerate = 60
    --DebugPrint("bye")
end

function tick(dt)

    if InputPressed("o") then
        active = not active
    end

    if InputPressed("i") then
        currentAnim = currentAnim + 1
        if currentAnim > #names then
            currentAnim = 1
        end

        values = DeRegisterAnimation(names[currentAnim])
    end
    
    if active then
        timer = timer + dt
        frametimer = frametimer + dt

        frame, frametimer = animate(frame, frametimer, dt, values, rig, repeating)
        DebugWatch("current animation", names[currentAnim])
    end
end

function SortByID(bodies)
    newTable = {}
    for i=1, #bodies do
        table.insert(newTable, 0)
    end

    for i, body in ipairs(bodies) do
        id = tonumber(GetTagValue(body, "id"))
        newTable[id] = body
    end

    return newTable
end

function DeRegisterAnimation(name)
    values = {}

    key = "level.animations."..name
    --DebugPrint(key)

    for framenum=1, #ListKeys(key..".frames") do
        framekey = key..".frames.frame"..framenum
        --DebugPrint(framekey)

        time = GetFloat(framekey..".time")
        values[framenum] = {time, {}}

        for id=1, #ListKeys(framekey) do
            bodykey = framekey..".bodies.body"..id
            --DebugPrint(bodykey)
            posEasing = GetString(bodykey..".posease")
            rotEasing = GetString(bodykey..".rotease")

            pos = Vec(GetFloat(bodykey..".x"), GetFloat(bodykey..".y"), GetFloat(bodykey..".z"))
            rot = Quat(GetFloat(bodykey..".qx"), GetFloat(bodykey..".qy"), GetFloat(bodykey..".qz"), GetFloat(bodykey..".qw"))
            trans = Transform(pos, rot)

            values[framenum][2][id] = {posEasing, rotEasing, trans}
            --DebugPrint(TransformStr(trans))
        end
    end

    return values
end

function animate(currentKeyframe, frametimer, dt, values, rig, repeating)

    if currentKeyframe < #values then
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
                DebugPrint(posEase)

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
            if (currentKeyframe >= #values) and repeating then
                currentKeyframe = 1
            end
        end

        DebugWatch("prog", prog)
        DebugWatch("currentKeyframe", currentKeyframe)
        DebugWatch("frametimer", frametimer)
        DebugWatch("frametime", frametime)
        DebugWatch("timer", timer)
        

        return currentKeyframe, frametimer

    else
        --SetBool(name..".active", false)
        if repeating then
            currentKeyframe = 1
        end
        
        return currentKeyframe, 0
    end
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
    DebugPrint(t)

    return t
end