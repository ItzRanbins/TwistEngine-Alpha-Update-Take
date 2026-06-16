tankAngle = 0
tankSpeed = 0
function onCreate()
    if lowQuality == false then
        makeLuaSprite('solidBG', '', -500, -1000)
        makeGraphic('solidBG', 2400, 2000, 'E3A26D')
        setScrollFactor('solidBG', 0, 0)
        addLuaSprite('solidBG')
    end

    makeLuaSprite('sky', 'stages/week7/tankSky', -2000, -400)
    scaleObject('sky', 4, 1)
    setScrollFactor('sky', 0, 0)
	addLuaSprite('sky')

    if lowQuality == false then
        makeLuaSprite('mountains', 'stages/week7/tankMountains', -500, -35)
        scaleObject('mountains', 1.2, 1.2)
        setScrollFactor('mountains', 0.2, 0.2)
        addLuaSprite('mountains')

        makeLuaSprite('clouds', 'stages/week7/tankClouds', -1100, 20)
        setScrollFactor('clouds', 0.25, 0.25)
        addLuaSprite('clouds')
        setProperty('clouds.velocity.x', 8)

        makeLuaSprite('cityBuildings', 'stages/week7/tankBuildings', -260, -35)
        scaleObject('cityBuildings', 1.1, 1.1)
        setScrollFactor('cityBuildings', 0.3, 0.3)
        addLuaSprite('cityBuildings')
    end

    makeLuaSprite('cityRuins', 'stages/week7/tankRuins', -200, 150)
    scaleObject('cityRuins', 1.1, 1.1)
    setScrollFactor('cityRuins', 0.35, 0.35)
    addLuaSprite('cityRuins')

    if lowQuality == false then
        makeAnimatedLuaSprite('smokeLeft', 'stages/week7/smokeLeft', -380, -40)
        addAnimationByPrefix('smokeLeft', 'anim', 'SmokeBlurLeft', 24, true)
        setScrollFactor('smokeLeft', 0.4, 0.4)
        addLuaSprite('smokeLeft')

        makeAnimatedLuaSprite('smokeRight', 'stages/week7/smokeRight', 1050, -35)
        addAnimationByPrefix('smokeRight', 'anim', 'SmokeRight', 24, true)
        setScrollFactor('smokeRight', 0.4, 0.4)
        addLuaSprite('smokeRight')

        makeAnimatedLuaSprite('watchtower', 'stages/week7/tankWatchtower', -35, 110)
        addAnimationByPrefix('watchtower', 'idle', 'watchtower gradient color', 24, false)
        scaleObject('watchtower', 0.85, 0.85)
        setScrollFactor('watchtower', 0.5, 0.5)
        addLuaSprite('watchtower')
    end

    makeAnimatedLuaSprite('tankRolling', 'stages/week7/tankRolling', 300, 300)
    addAnimationByPrefix('tankRolling', 'anim', 'BG tank w lighting', 24, true)
    setScrollFactor('tankRolling', 0.5, 0.5)
    addLuaSprite('tankRolling')

    makeLuaSprite('ground', 'stages/week7/tankGround', -420, -150)
    scaleObject('ground', 1.15, 1.15)
    addLuaSprite('ground')

    makeLuaSprite('bricks', 'stages/week7/bricksGround', 438, 715)
    scaleObject('bricks', 1.15, 1.15)
    setObjectOrder('bricks', getObjectOrder('gfGroup') + 1)
    addLuaSprite('bricks')

    makeAnimatedLuaSprite('tankAudience0', 'stages/week7/tank0', -500, 650)
    addAnimationByPrefix('tankAudience0', 'idle', 'fg tankhead far right instance 1', 24, false)
    setScrollFactor('tankAudience0', 1.7, 1.5)
    addLuaSprite('tankAudience0', true)

    makeAnimatedLuaSprite('tankAudience2', 'stages/week7/tank2', 360, 980)
    addAnimationByPrefix('tankAudience2', 'idle', 'foreground man 3 instance 1', 24, false)
    setScrollFactor('tankAudience2', 1.5, 1.5)
    addLuaSprite('tankAudience2', true)

    makeAnimatedLuaSprite('tankAudience5', 'stages/week7/tank5', 1550, 700)
    addAnimationByPrefix('tankAudience5', 'idle', 'fg tankhead far right instance 1', 24, false)
    setScrollFactor('tankAudience5', 1.5, 1.5)
    addLuaSprite('tankAudience5', true)

    if lowQuality == false then
        makeAnimatedLuaSprite('tankAudience4', 'stages/week7/tank4', 1200, 900)
        addAnimationByPrefix('tankAudience4', 'idle', 'fg tankman bobbin 3 instance 1', 24, false)
        setScrollFactor('tankAudience4', 1.5, 1.5)
        addLuaSprite('tankAudience4', true)

        makeAnimatedLuaSprite('tankAudience3', 'stages/week7/tank3', 1050, 1240)
        addAnimationByPrefix('tankAudience3', 'idle', 'fg tankhead 4 instance 1', 24, false)
        setScrollFactor('tankAudience3', 3.5, 2.5)
        addLuaSprite('tankAudience3', true)

        makeAnimatedLuaSprite('tankAudience1', 'stages/week7/tank1', -300, 750)
        addAnimationByPrefix('tankAudience1', 'idle', 'fg tankhead 5 instance 1', 24, false)
        setScrollFactor('tankAudience1', 2, 0.2)
        addLuaSprite('tankAudience1', true)
    end

    tankAngle = getRandomInt(-90, 45)
    tankSpeed = getRandomFloat(5, 7)

    for i = 1, 25 do
		precacheSound('jeffGameover/jeffGameover-'..i)
	end
end

startedDeathSound = false
deathSoundEnded = false
function onUpdate(elapsed)
    -- Moving tank stuff
    tankAngle = tankAngle + elapsed * tankSpeed
    setProperty('tankRolling.angle', tankAngle - 75)
    setProperty('tankRolling.x', 400 + math.cos(math.rad(tankAngle + 180)) * 1500)
    setProperty('tankRolling.y', 1300 + math.sin(math.rad(tankAngle + 180)) * 1100)

    -- Death voiceline behavior
    if inGameOver == true and startedDeathSound == false then
		curAnim = (getPropertyFromGameOver('boyfriend.animation.curAnim.name') or getPropertyFromGameOver('boyfriend.atlas.anim.curSymbol.name'))
		if curAnim == 'firstDeath' then
			animEnded = (getPropertyFromGameOver('boyfriend.animation.curAnim.finished') or getPropertyFromGameOver('boyfriend.atlas.anim.finished'))
			if animEnded == true then
				local jeffVariant = getRandomInt(1, 25)
				playSound('jeffGameover/jeffGameover-'..jeffVariant, 1, 'jeffVoiceline')
				startedDeathSound = true
			end
		end
	end
end

-- Needed to keep the sound at this volume during the voiceline
function onUpdatePost(elapsed)
	if inGameOver == true and deathSoundEnded == false then
		setSoundVolume(nil, 0.2)
	end
end

function onCountdownTick(counter)
    -- Tankmen dancing during the countdown
    if counter % 2 == 0 then
        for i = 0, 5 do
            if luaSpriteExists('tankAudience'..i) then
                playAnim('tankAudience'..i, 'idle', true)
            end
        end
        if lowQuality == false then
            playAnim('watchtower', 'idle', true)
        end
    end
end

function onBeatHit()
    -- Tankmen dancing on beat
    if curBeat % 2 == 0 then
        for i = 0, 5 do
            if luaSpriteExists('tankAudience'..i) then
                playAnim('tankAudience'..i, 'idle', true)
            end
        end
        if lowQuality == false then
            playAnim('watchtower', 'idle', true)
        end
    end
end

-- Prevents the Game Over music to restart when you retry
local gameOverFinished = false
function onGameOverConfirm()
	gameOverFinished = true
end

function onSoundFinished(tag)
	if tag == 'jeffVoiceline' and gameOverFinished == false then
		soundFadeIn(nil, 4, 0.2, 1)
		deathSoundEnded = true
	end
end

-- Extra function needed for the stage's script
function getPropertyFromGameOver(property)
    if getPropertyFromClass('substates.GameOverSubstate', property) ~= nil then
        return getPropertyFromClass('substates.GameOverSubstate', property)
    else
        return getPropertyFromClass('substates.GameOverSubstate', 'instance.'..property)
    end
end