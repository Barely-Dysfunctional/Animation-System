function init()
    handlers = {"test", "test2"}
    names = {"test", "test2", "test3"}
    currentAnim = 1
    currentHandler = 1
    currentChange = 1
end

function tick()

    if InputPressed("o") then --activate
        SetString("level.animhandlers."..handlers[currentHandler]..".controls.animation", names[currentAnim])
        SetInt("level.animhandlers."..handlers[currentHandler]..".controls.change", currentChange)
        active = true
    end

    if InputPressed("l") then --deactivate
        SetString("level.animhandlers."..handlers[currentHandler]..".controls.animation", "none")
        SetInt("level.animhandlers."..handlers[currentHandler]..".controls.change", currentChange)
        active = false
    end
    
    if InputPressed("i") then --change animation
        currentAnim = currentAnim + 1
        if currentAnim > #names then
            currentAnim = 1
        end
    end

    if InputPressed("k") then --change handler
        currentHandler = currentHandler + 1
        if currentHandler > #handlers then
            currentHandler = 1
        end
    end

    if InputPressed("u") then
        currentChange = currentChange + 1
        if currentChange > 3 then
            currentChange = 1
        end
    end

    DebugWatch("currentanim", names[currentAnim])
    DebugWatch("currenthandler", handlers[currentHandler])
    DebugWatch("currentChange", currentChange)
end