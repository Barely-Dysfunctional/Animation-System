function init()
    RegisterTool("exampletool", "example tool", "MOD/tool.vox")
    SetBool("game.tool.exampletool.enabled", true)
end

function tick()
    if GetString("game.player.tool") == "exampletool" then
        if InputPressed("lmb") then
            SetString("level.shapeanimhandlers.exampletool.controls.animation", "aaaaa")
            SetInt("level.shapeanimhandlers.exampletool.controls.change", 1)
        end
    end
end