function init()
    keyframes = FindBodies("frame")
    firstTrans = GetBodyTransform(keyframes[1])

    values = {}
    times = {}

    for framenum, keyframe in ipairs(keyframes) do

        time = GetTagValue(keyframe, "time")
        if time == "" then
            time = 1
        else
            time = tonumber(time)
        end
        --DebugPrint("time: "..time)
        times[framenum] = time



        thingies = FindFrameBodies(keyframe)
        ----DebugPrint(keyframe)

        for bodynum, body in ipairs(thingies) do
            
            id = tonumber(GetTagValue(body, "id"))
            --DebugPrint("id: "..id)

            if framenum == 1 then
                values[id] = {body, {}}
                --DebugPrint("yeet")
                values[id][2][1] = TransformToLocalTransform(GetBodyTransform(keyframe), GetBodyTransform(body))
            else
                values[id][2][framenum] = TransformToLocalTransform(GetBodyTransform(keyframe), GetBodyTransform(body))
                Delete(body)
            end
        end
    end


    repeating = GetBoolParam("repeat", false)
    framerate = GetIntParam("fps", 60)
    name = "level.animations."..GetStringParam("name", "animation")
    while HasKey(name) do
        name = name.."(2)"
    end
    SetBool(name..".active", false)

    frame = 1
    timer = 0
    frametimer = 0
    
end

function update(dt)
    active = GetBool(name..".active")

    --if InputPressed("o") then
    --    active = not active
    --    SetBool(name..".active", active)
    --end

    if active then
        timer = timer + dt
        frametimer = frametimer + dt

        frame, frametimer = animate(frame, frametimer, dt, values, repeating)
    end
end

function animate(currentKeyframe, frametimer, dt, values, repeating)

    if currentKeyframe < #keyframes then
        
        frametime = times[currentKeyframe]
        prog = math.min(frametimer / frametime, 1)

        if timer > (1/framerate) then
            for id, objectValues in ipairs(values) do
                SetBodyDynamic(objectValues[1], false)

                startTrans = TransformToParentTransform(firstTrans, objectValues[2][currentKeyframe])
                endTrans = TransformToParentTransform(firstTrans, objectValues[2][currentKeyframe + 1])  

                newPos = VecLerp(startTrans.pos, endTrans.pos, prog)
                newRot = QuatSlerp(startTrans.rot, endTrans.rot, prog)

                SetBodyTransform(objectValues[1], Transform(newPos, newRot))

                --DebugCross(startTrans.pos)
                --DebugCross(endTrans.pos)
                --DebugCross(newPos, 1, 0, 0, 1)
            end

            timer = 0
        end

        if prog == 1 then
            frametimer = 0
            currentKeyframe = currentKeyframe + 1
            if (currentKeyframe >= #keyframes) and repeating then
                currentKeyframe = 1
            end
        end

        return currentKeyframe, frametimer

    else
        SetBool(name..".active", false)
        return currentKeyframe, 0
    end
end


function FindFrameBodies(framebody)
    bodies = {}
    i = framebody

    while(true) do
        i = i + 1
        if IsHandleValid(i) then
            if (GetEntityType(i) == "body") then

                if HasTag(i, "frame") then
                    return bodies
                elseif HasTag(i, "id") then
                    table.insert(bodies, i)
                end
            end
        else
            return bodies
        end
    end
end