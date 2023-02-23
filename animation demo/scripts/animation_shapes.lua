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

        frameshapes = FindFrameShapes(keyframe)
        DebugPrint(#frameshapes)
        for shapenum, shape in ipairs(frameshapes) do

            id = tonumber(GetTagValue(shape, "id"))
            --DebugPrint("id: "..id)

            posEasing = GetTagValue(shape, "posease")
            if posEasing == "" then
                posEasing = "linear"
            end

            rotEasing = GetTagValue(shape, "rotease")
            if rotEasing == "" then
                rotEasing = "linear"
            end

            trans = GetShapeLocalTransform(shape)
            --trans.pos = VecScale(trans.pos, 0.1)
            values[framenum][2][id] = {posEasing, rotEasing, trans}

            --DebugPrint(TransformStr(trans))
            Delete(shape)
        end
    end
    
    name = GetStringParam("name", "animation")
    RegisterAnimation(values, name)
end

function RegisterAnimation(values, name)
    key = "level.shapeanimations."..name
    while HasKey(key) do
        key = key.."(2)"
    end

    for framenum, frame in ipairs(values) do
        framekey = key..".frames.frame"..framenum

        time = frame[1]
        SetFloat(framekey..".time", time)

        for id, shapeValues in ipairs(frame[2]) do
            shapekey = framekey..".bodies.body"..id

            SetString(shapekey..".posease", shapeValues[1])
            SetString(shapekey..".rotease", shapeValues[2])

            trans = shapeValues[3]
            SetFloat(shapekey..".x", trans.pos[1])
            SetFloat(shapekey..".y", trans.pos[2])
            SetFloat(shapekey..".z", trans.pos[3])
            SetFloat(shapekey..".qx", trans.rot[1])
            SetFloat(shapekey..".qy", trans.rot[2])
            SetFloat(shapekey..".qz", trans.rot[3])
            SetFloat(shapekey..".qw", trans.rot[4])
        end
    end
end

function FindFrameShapes(framebody)
    shapes = {}
    i = framebody

    while(true) do
        i = i + 1
        if not IsHandleValid(i) then
            return shapes
        end

        if GetEntityType(i) ~= "shape" then
            return shapes
        end

        if HasTag(i, "id") then
            table.insert(shapes, i)
        end
    end
end