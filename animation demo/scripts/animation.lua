function init()

    values = {}

    keyframes = FindBodies("frame")
    for framenum, keyframe in ipairs(keyframes) do
        --DebugPrint(keyframe)

        time = GetTagValue(keyframe, "time")
        if time == "" then
            time = 1
        else
            time = tonumber(time)
        end

        values[framenum] = {time, {}}
        --DebugPrint("time: "..time)

        framebodies = FindFrameBodies(keyframe)
        for bodynum, body in ipairs(framebodies) do

            id = tonumber(GetTagValue(body, "id"))
            --DebugPrint("id: "..id)

            posEasing = GetTagValue(body, "posease")
            if posEasing == "" then
                posEasing = "linear"
            end

            rotEasing = GetTagValue(body, "rotease")
            if rotEasing == "" then
                rotEasing = "linear"
            end

            trans = TransformToLocalTransform(GetBodyTransform(keyframe), GetBodyTransform(body))
            values[framenum][2][id] = {posEasing, rotEasing, trans}

            --DebugPrint(TransformStr(trans))
            Delete(body)
        end
    end
    
    name = GetStringParam("name", "animation")
    RegisterAnimation(values, name)
end

function RegisterAnimation(values, name)
    key = "level.animations."..name
    while HasKey(key) do
        key = key.."(2)"
    end

    for framenum, frame in ipairs(values) do
        framekey = key..".frames.frame"..framenum

        time = frame[1]
        SetFloat(framekey..".time", time)

        for id, bodyValues in ipairs(frame[2]) do
            bodykey = framekey..".bodies.body"..id

            SetString(bodykey..".posease", bodyValues[1])
            SetString(bodykey..".rotease", bodyValues[2])

            trans = bodyValues[3]
            SetFloat(bodykey..".x", trans.pos[1])
            SetFloat(bodykey..".y", trans.pos[2])
            SetFloat(bodykey..".z", trans.pos[3])
            SetFloat(bodykey..".qx", trans.rot[1])
            SetFloat(bodykey..".qy", trans.rot[2])
            SetFloat(bodykey..".qz", trans.rot[3])
            SetFloat(bodykey..".qw", trans.rot[4])
        end
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
                elseif HasTag(i, "end") then
                    return bodies
                end
            end
        else
            return bodies
        end
    end
end