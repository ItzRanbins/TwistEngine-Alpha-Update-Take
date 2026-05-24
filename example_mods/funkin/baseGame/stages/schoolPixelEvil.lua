function onCreate()
	makeLuaSprite('treesEvilBG', 'weeb/weebBackTreesEvil', -842, -80)
	scaleObject('treesEvilBG', 6, 6)
	setScrollFactor('treesEvilBG', 0.5, 0.5)
	addLuaSprite('treesEvilBG')
	setProperty('treesEvilBG.antialiasing', false)

	makeLuaSprite('schoolEvil', 'weeb/weebSchoolEvil', -816, -38)
	scaleObject('schoolEvil', 6, 6)
	setScrollFactor('schoolEvil', 0.75, 0.75)
	addLuaSprite('schoolEvil')
	setProperty('schoolEvil.antialiasing', false)

	makeLuaSprite('streetEvil', 'weeb/weebStreetEvil', -662, 6)
	scaleObject('streetEvil', 6, 6)
	addLuaSprite('streetEvil')
	setProperty('streetEvil.antialiasing', false)

	makeLuaSprite('treesEvil', 'weeb/weebTreesEvil', -662, 6)
	scaleObject('treesEvil', 6, 6)
	addLuaSprite('treesEvil')
	setProperty('treesEvil.antialiasing', false)

    -- Default Game Over
	setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'bf-pixel-dead')
	setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-pixel')
	setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'gameOver-pixel')
	setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'gameOverEnd-pixel')
end

function onCreatePost()
	runHaxeCode([[
		import flixel.addons.effects.FlxTrail;

		// Adds the trail behind the opponent.
		var dadTrail:FlxTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
		game.addBehindDad(dadTrail);
	]])

	-- Adds the shaders on the sprites
    if shadersEnabled == true and lowQuality == false then
        initLuaShader('wiggle')
        wiggleData = {
            treesEvilBG = {speed = 2 * 0.8, frequency = 4 * 0.4, amplitude = 0.011},
            schoolEvil = {speed = 2, frequency = 4, amplitude = 0.017},
            streetEvil = {speed = 2, frequency = 4, amplitude = 0.007},
            treesEvil = {speed = 2, frequency = 4, amplitude = 0.007}
        }

        for object, data in pairs(wiggleData) do
		    setSpriteShader(object, 'wiggle')
		    setShaderFloat(object, 'uSpeed', data.speed)
		    setShaderFloat(object, 'uFrequency', data.frequency)
		    setShaderFloat(object, 'uWaveAmplitude', data.amplitude)
		    setShaderInt(object, 'effectType', 0)
		end
    end
end

-- Sets up the sprites for the 'Trigger BG Ghouls' event if present in the chart
local eventInitialized = false
function onEventPushed(event, value1, value2, strumTime)
    if event == 'Trigger BG Ghouls' and lowQuality == false and eventInitialized == false then
		makeAnimatedLuaSprite('girlfreaksEvil', 'weeb/bgGhouls', -646, 222)
		addAnimationByPrefix('girlfreaksEvil', 'anim', 'BG freaks glitch instance', 24, false)
		scaleObject('girlfreaksEvil', 6, 6)
		addLuaSprite('girlfreaksEvil')
		setProperty('girlfreaksEvil.antialiasing', false)
		setProperty('girlfreaksEvil.visible', false)
		eventInitialized = true
    end
end

-- Updates the 'wiggle' shader for every object
local elapsedTime = 0
function onUpdate(elapsed)
	if shadersEnabled == true and lowQuality == false then
		elapsedTime = elapsedTime + elapsed
        for i, object in ipairs({'treesEvilBG', 'schoolEvil', 'streetEvil', 'treesEvil'}) do
		    setShaderFloat(object, 'uTime', elapsedTime)
        end
	end
end

-- Everything from this point is for the 'Trigger BG Ghouls' event
function onEvent(eventName, value1, value2, strumTime)
	if eventName == 'Trigger BG Ghouls' and lowQuality == false then
		cancelTimer('freaksAnimLength') -- Just in case
		playAnim('girlfreaksEvil', 'anim', true)
		setProperty('girlfreaksEvil.visible', true)
		runTimer('freaksAnimLength', getProperty('girlfreaksEvil.animation.curAnim.numFrames') / 24)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'freaksAnimLength' then
		setProperty('girlfreaksEvil.visible', false)
	end
end