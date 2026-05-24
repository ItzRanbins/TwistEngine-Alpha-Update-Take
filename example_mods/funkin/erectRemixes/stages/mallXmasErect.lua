function onCreate()
	makeLuaSprite('mallBG', 'christmas/erect/bgWalls', -630, -492)
	scaleObject('mallBG', 0.8, 0.8)
	setScrollFactor('mallBG', 0.2, 0.2)
	addLuaSprite('mallBG')

	if lowQuality == false then
		makeAnimatedLuaSprite('topBoppers', 'christmas/erect/upperBop', -396, -98)
		addAnimationByPrefix('topBoppers', 'idle', 'upperBop', 24, false)
		scaleObject('topBoppers', 0.85, 0.85)
		setScrollFactor('topBoppers', 0.28, 0.28)
		addLuaSprite('topBoppers')

		makeLuaSprite('escalators', 'christmas/erect/bgEscalator', -1100, -540)
		scaleObject('escalators', 0.9, 0.9)
		setScrollFactor('escalators', 0.3, 0.3)
		addLuaSprite('escalators')
	end

	makeLuaSprite('christmasTree', 'christmas/erect/christmasTree', 370, -250)
	setScrollFactor('christmasTree', 0.4, 0.4)
	addLuaSprite('christmasTree')

	if lowQuality == false then
		makeLuaSprite('fog', 'christmas/erect/white', -1000, 100)
		scaleObject('fog', 0.9, 0.9)
		setScrollFactor('fog', 0.85, 0.85)
		addLuaSprite('fog')
	end

	makeAnimatedLuaSprite('bottomBoppers', 'christmas/erect/bottomBop', -410, 100)
	addAnimationByPrefix('bottomBoppers', 'hey', 'hey', 24, false)
	addAnimationByPrefix('bottomBoppers', 'idle', 'bop', 24, false)
	addOffset('bottomBoppers', 'hey', 0, 5)
	addOffset('bottomBoppers', 'idle', 0, 0)
	setScrollFactor('bottomBoppers', 0.9, 0.9)
	addLuaSprite('bottomBoppers')

	makeLuaSprite('snowSolid', '', -1500, 800)
	makeGraphic('snowSolid', 5700, 3000, 'F3F4F5')
	addLuaSprite('snowSolid')

	makeLuaSprite('snowGround', 'christmas/fgSnow', -1350, 680)
	scaleObject('snowGround', 1.1, 1)
	addLuaSprite('snowGround')

	makeAnimatedLuaSprite('santa', 'christmas/santa', -840, 150)
	addAnimationByPrefix('santa', 'idle', 'santa idle in fear', 24, false)
	addLuaSprite('santa', true)
end

function onCreatePost()
	if shadersEnabled == true then
		-- Adds the shaders on the characters/sprites
        initLuaShader('adjustColor')
        for i, object in ipairs({'boyfriend', 'dad', 'gf', 'santa'}) do
            setSpriteShader(object, 'adjustColor')
            setShaderFloat(object, 'hue', 5)
			setShaderFloat(object, 'saturation', 20)
            setShaderFloat(object, 'contrast', 0)
            setShaderFloat(object, 'brightness', 0)
        end

		--[[
			Adding shader on them because MrCatz seems to have forgotten
			to add them in when exporting the spritesheet. Oops :p
			TODO: Probably manually modify the PNG to correct the color scheme somehow.
		]]
		setSpriteShader('bottomBoppers', 'adjustColor')
		setShaderFloat('bottomBoppers', 'hue', 15)
		setShaderFloat('bottomBoppers', 'saturation', 0)
        setShaderFloat('bottomBoppers', 'contrast', 0)
        setShaderFloat('bottomBoppers', 'brightness', 20)	
	end
end

--[[
	Everything below is to make the characters bop their head on beat.
	It also checks if the 'Hey!' event is played to make the ones at the bottom cheer aswell.
	
	Credits to MrCatz for making the 'Hey!' animation for this Erect stage.
]]
local heyTimer = 0
function onUpdate(elapsed)
	-- Handles the 'Hey!' behavior of the bottom characters
	if heyTimer > 0 then
		heyTimer = heyTimer - elapsed
		if heyTimer <= 0 then
			playAnim('bottomBoppers', 'idle', true)
			heyTimer = 0
		end
	end
end

function onCountdownTick(swagCounter)
	-- Crowd dancing during the countdown
	if lowQuality == false then
		playAnim('topBoppers', 'idle', true)
	end
	playAnim('bottomBoppers', 'idle', true)
	playAnim('santa', 'idle', true)
end

function onBeatHit()
	-- Crowd dancing on beat
	if lowQuality == false then
		playAnim('topBoppers', 'idle', true)
	end
	if heyTimer <= 0 then
		playAnim('bottomBoppers', 'idle', true)
	end
	playAnim('santa', 'idle', true)
end

-- Makes the bottom characters do their 'Hey!' animation
function onEvent(eventName, value1, value2)
	if eventName == 'Hey!' then
		if value1 ~= '0' or string.lower(value1) ~= 'bf' or string.lower(value1) ~= 'boyfriend' then
			playAnim('bottomBoppers', 'hey', true)
			if value2 == '' then
				heyTimer = 0.6
			else
				heyTimer = tonumber(value2)
			end
		end
	end
end