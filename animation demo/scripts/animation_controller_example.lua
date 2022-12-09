timer = 0

function tick(dt)

    if InputPressed("i") then
        SetBool("level.animations.jimbo.active", true)
        SetBool("level.animations.bob.active", true)
        SetBool("level.animations.george.active", true)
        SetBool("level.animations.gleeb.active", true)
        SetBool("level.animations.hank.active", true)
    end

    if InputPressed("o") then
        SetBool("level.animations.jimbo.active", false)
        SetBool("level.animations.bob.active", false)
        SetBool("level.animations.george.active", false)
        SetBool("level.animations.gleeb.active", false)
        SetBool("level.animations.hank.active", false)
    end

    if InputPressed("u") then
        timeractive = not timeractive
    end

    if timeractive then
        timer = timer + dt

        if timer <= 4 then
            SetBool("level.animations.jimbo.active", false)
            SetBool("level.animations.bob.active", true)
            SetBool("level.animations.george.active", false)
            SetBool("level.animations.gleeb.active", true)
            SetBool("level.animations.hank.active", false)
        elseif timer <= 8 then
            SetBool("level.animations.jimbo.active", true)
            SetBool("level.animations.bob.active", false)
            SetBool("level.animations.george.active", true)
            SetBool("level.animations.gleeb.active", false)
            SetBool("level.animations.hank.active", true)
        elseif timer <= 12 then
            SetBool("level.animations.jimbo.active", true)
            SetBool("level.animations.bob.active", true)
            SetBool("level.animations.george.active", false)
            SetBool("level.animations.gleeb.active", false)
            SetBool("level.animations.hank.active", true)
        elseif timer <= 16 then
            SetBool("level.animations.jimbo.active", false)
            SetBool("level.animations.bob.active", false)
            SetBool("level.animations.george.active", true)
            SetBool("level.animations.gleeb.active", true)
            SetBool("level.animations.hank.active", false)
        elseif timer <= 20 then
            SetBool("level.animations.jimbo.active", true)
            SetBool("level.animations.bob.active", true)
            SetBool("level.animations.george.active", true)
            SetBool("level.animations.gleeb.active", true)
            SetBool("level.animations.hank.active", true)
        elseif timer <= 28 then
            SetBool("level.animations.jimbo.active", false)
            SetBool("level.animations.bob.active", false)
            SetBool("level.animations.george.active", false)
            SetBool("level.animations.gleeb.active", false)
            SetBool("level.animations.hank.active", false)
        else
            timeractive = false
            timer = 0
        end
    end
end