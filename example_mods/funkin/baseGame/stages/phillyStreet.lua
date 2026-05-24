function onCreate()
    makeLuaSprite('solidBG', '', -500, -1000)
	makeGraphic('solidBG', 4000, 3000, '8E9191')
	setScrollFactor('solidBG', 0, 0)
	addLuaSprite('solidBG')

    if lowQuality == false then
        for i = 0, 2 do
            makeLuaSprite('sky'..(i + 1), 'streets/phillySkybox', -650, -375)
            scaleObject('sky'..(i + 1), 0.65, 0.65, false)
            setScrollFactor('sky'..(i + 1), 0.1, 0.1)
            addLuaSprite('sky'..(i + 1))
            setProperty('sky'..(i + 1)..'.x', getProperty('sky'..(i + 1)..'.x') + (getProperty('sky'..(i + 1)..'.width') * 0.65) * i)
        end
    end

    makeLuaSprite('skyline', 'streets/phillySkyline', -545, -273)
    setScrollFactor('skyline', 0.2, 0.2)
    addLuaSprite('skyline')

    if lowQuality == false then
        makeLuaSprite('cityBuildingsLeft', 'streets/phillyForegroundCity', 625, 94)
        setScrollFactor('cityBuildingsLeft', 0.3, 0.3)
        addLuaSprite('cityBuildingsLeft')

        makeLuaSprite('cityBuildingsRight', 'streets/phillyForegroundCity', 1865, 220)
        setScrollFactor('cityBuildingsRight', 0.3, 0.3)
        addLuaSprite('cityBuildingsRight')
        setProperty('cityBuildingsRight.angle', 5)
        setProperty('cityBuildingsRight.flipX', true)
    end
    
    makeLuaSprite('constructionSite', 'streets/phillyConstruction', 1800, 364)
    setScrollFactor('constructionSite', 0.7, 1)
    addLuaSprite('constructionSite')

    if lowQuality == false then
        makeLuaSprite('highwayLights', 'streets/phillyHighwayLights', 122, 201)
        setScrollFactor('highwayLights', 0.8, 0.8)
        addLuaSprite('highwayLights')

        makeLuaSprite('highwayLights_lightmap', 'streets/phillyHighwayLights_lightmap', 122, 201)
        setScrollFactor('highwayLights_lightmap', 0.8, 0.8)
        setBlendMode('highwayLights_lightmap', 'ADD')
        addLuaSprite('highwayLights_lightmap')
        setProperty('highwayLights_lightmap.alpha', 0.6)

        makeLuaSprite('highway', 'streets/phillyHighway', -23, 105)
        setScrollFactor('highway', 0.8, 0.8)
        addLuaSprite('highway')

        makeLuaSprite('smog', 'streets/phillySmog', -6, 305)
        setScrollFactor('smog', 0.8, 1)
        addLuaSprite('smog')
    end

    makeAnimatedLuaSprite('cars1', 'streets/phillyCars', 1200, 818)
    setScrollFactor('cars1', 0.9, 1)
    addAnimationByPrefix('cars1', 'normal', 'car1', 24, false)
    addOffset('cars1', 'normal', 0, 0)
    addAnimationByPrefix('cars1', 'sport', 'car2', 24, false)
    addOffset('cars1', 'sport', 20, -15)
    addAnimationByPrefix('cars1', 'van', 'car3', 24, false)
    addOffset('cars1', 'van', 30, 50)
    addAnimationByPrefix('cars1', 'suv', 'car4', 24, false)
    addOffset('cars1', 'suv', 10, 60)
    addLuaSprite('cars1')
    
    makeAnimatedLuaSprite('cars2', 'streets/phillyCars', 1200, 818)
    setScrollFactor('cars2', 0.9, 1)
    addAnimationByPrefix('cars2', 'normal', 'car1', 24, false)
    addOffset('cars2', 'normal', 0, 0)
    addAnimationByPrefix('cars2', 'sport', 'car2', 24, false)
    addOffset('cars2', 'sport', 20, -15)
    addAnimationByPrefix('cars2', 'van', 'car3', 24, false)
    addOffset('cars2', 'van', 30, 50)
    addAnimationByPrefix('cars2', 'suv', 'car4', 24, false)
    addOffset('cars2', 'suv', 10, 60)
    setObjectOrder('cars2', getObjectOrder('cars1'))
    setProperty('cars2.flipX', true)
    addLuaSprite('cars2')

    makeAnimatedLuaSprite('trafficLights', 'streets/phillyTraffic', 1840, 608)
    addAnimationByPrefix('trafficLights', 'redTrans', 'greentored', 24, false)
    addAnimationByPrefix('trafficLights', 'greenTrans', 'redtogreen', 24, false)
    setScrollFactor('trafficLights', 0.9, 1)
    addLuaSprite('trafficLights')
    
    if lowQuality == false then
        makeLuaSprite('trafficLights_lightmap', 'streets/phillyTraffic_lightmap', 1840, 608)
        setScrollFactor('trafficLights_lightmap', 0.9, 1)
        setBlendMode('trafficLights_lightmap', 'ADD')
        addLuaSprite('trafficLights_lightmap')
        setProperty('trafficLights_lightmap.alpha', 0.6)
    end
    
    makeLuaSprite('street', 'streets/phillyForeground', 88, 317)
    addLuaSprite('street')

    makeLuaSprite('sprayCans', 'streets/SpraycanPile', 920, 1045)
    addLuaSprite('sprayCans', true)
end

function onCreatePost()
    -- Sets up the haxe commands needed for the stage's script
    runHaxeCode([[
        import psychlua.LuaUtils;

        // Rain shader functions.
        function activateRainShader() FlxG.camera.setFilters([new ShaderFilter(game.getLuaObject('rainFilter').shader)]);
        function deactivateRainShader() FlxG.camera.setFilters([]);

        /*
          Works the same as 'quadPath', but doesn't use FlxPoint.
          Apparently, using FlxPoint just crashes the game for some reason,
          so I had to find an alternative.
        */
        function quadMotionTween(object:String, from:Array<Float>, control:Array<Float>, to:Array<Float>, duration:Float, ease:String) {
            FlxTween.quadMotion(game.getLuaObject(object), from[0], from[1], control[0], control[1], to[0], to[1], duration, true, {ease: LuaUtils.getTweenEaseByString(ease)});
        }
    ]])

    if shadersEnabled == true then
        -- Adds the rain on the stage
        initLuaShader('rain')
        makeLuaSprite('rainFilter')
        setSpriteShader('rainFilter', 'rain')
        setShaderFloat('rainFilter', 'uScale', screenHeight / 200)
        if stringStartsWith(songPath, 'darnell') then
            intensityStart = 0
            intensityEnd = 0.1
        elseif stringStartsWith(songPath, 'lit-up') then
            intensityStart = 0.1
            intensityEnd = 0.2
        elseif stringStartsWith(songPath, '2hot') then
            intensityStart = 0.2
            intensityEnd = 0.4
        else
            intensityStart = 0.15
            intensityEnd = 0.15
        end
        setShaderFloat('rainFilter', 'uIntensity', intensityStart)
        setShaderFloatArray('rainFilter', 'uRainColor', {102 / 255, 128 / 255, 204 / 255})
        setShaderFloatArray('rainFilter', 'uFrameBounds', {0, 0, screenWidth, screenHeight})
        runHaxeFunction('activateRainShader')
    end
end

local elapsedTime = 0
function onUpdate(elapsed)
    --[[
        This controls the movement of the sky on the stage. 
        It uses 3 'sky' sprites, and move them right behind eachother. 
        When one of them goes offscreen, it moves behind the rest to make the skyBox seemless.
    ]]
    if lowQuality == false then
        for i = 1, 3 do
            if getProperty('sky'..i..'.x') < -(getProperty('sky'..i..'.width') * 0.65) * 2 then
                setProperty('sky'..i..'.x', getProperty('sky'..i..'.x') + (getProperty('sky'..i..'.width') * 0.65) * 3)
            end
            setProperty('sky'..i..'.x', getProperty('sky'..i..'.x') - elapsed * 22)
        end
    end
    
    -- Makes the rain active and increase its intensity from 'intensityStart' to 'intensityEnd'
    if shadersEnabled == true then
        intensityValue = math.remapToRange(getSongPosition(), 0, songLength, intensityStart, intensityEnd)
        setShaderFloat('rainFilter', 'uIntensity', intensityValue)
        elapsedTime = elapsedTime + elapsed
        setShaderFloat('rainFilter', 'uTime', elapsedTime)
        setShaderFloatArray('rainFilter', 'uScreenResolution', {screenWidth, screenHeight})
        setShaderFloatArray('rainFilter', 'uCameraBounds', {getProperty('camGame.viewLeft'), getProperty('camGame.viewTop'), getProperty('camGame.viewRight'), getProperty('camGame.viewBottom')})
    end
end

-- Needed if we don't want the rain to affect the Game Over screen
function onGameOver()
    if shadersEnabled == true then
        runHaxeFunction('deactivateRainShader')
    end
end

-- All of this down below is to make the mechanics of the stage work
isRedLight = false
lastChange = 0
changeInterval = 8

isCarWaiting = false
cars1CanBeReset = true
cars2CanBeReset = true
function onBeatHit()
    -- Traffic movement
    if getRandomBool(10) and curBeat ~= lastChange + changeInterval and cars1CanBeReset == true then
        if isRedLight == false then
            driveCarFromLeft()
        else
            driveCarToLight()
        end
    end
    if getRandomBool(10) and curBeat ~= lastChange + changeInterval and cars2CanBeReset == true then
        if isRedLight == false then
            driveCarFromRight()
        end
    end

    -- Traffic lights behavior
    if curBeat == lastChange + changeInterval then
        changeLights()
    end
end

-- Changes the light from red to green and vice-versa
function changeLights()
    lastChange = curBeat
    isRedLight = not isRedLight
    if isRedLight == true then
        playAnim('trafficLights', 'redTrans')
        changeInterval = 20
    else
        playAnim('trafficLights', 'greenTrans')
        changeInterval = 30
        if isCarWaiting == true then
            local delay = getRandomFloat(0.2, 1.2)
            runTimer('startDelayFromLight', delay)
        end
    end
end

--[[
    Moves a car from left to right.

    The car is randomized along with their respective speed.
    (Ex: The sports car will always move faster than the van or suv)

    All the functions starting with 'driveCar' work the same, 
    only their starting and end position change.
]]
carVariants = {'normal', 'sport', 'van', 'suv'}
carsOffset = {x = 306.6, y = 168.3}
function driveCarFromLeft()
    cars1CanBeReset = false
    selectedCars1 = getRandomInt(1, 4)
    playAnim('cars1', carVariants[selectedCars1])
    if selectedCars1 == 1 then
        durationCars1 = getRandomFloat(1, 1.7)
    elseif selectedCars1 == 2 then
        durationCars1 = getRandomFloat(0.6, 1.2)
    elseif selectedCars1 >= 3 then
        durationCars1 = getRandomFloat(1.5, 2.5)
    end

    local path = {
        {1570 - carsOffset.x, 1049 - carsOffset.y - 30},
        {2400 - carsOffset.x, 980 - carsOffset.y - 50},
        {3102 - carsOffset.x, 1187 - carsOffset.y + 40}
    }
    setProperty('cars1.angle', -8)
    doTweenAngle('changeCars1Angle', 'cars1', 18, durationCars1, 'linear') 
    runHaxeFunction('quadMotionTween', {'cars1', path[1], path[2], path[3], durationCars1, 'linear'})
end

-- Moves a car from right to left
function driveCarFromRight()
    cars2CanBeReset = false
    selectedCars2 = getRandomInt(1, 4)
    playAnim('cars2', carVariants[selectedCars2])
    if selectedCars2 == 1 then
        durationCars2 = getRandomFloat(1, 1.7)
    elseif selectedCars2 == 2 then
        durationCars2 = getRandomFloat(0.6, 1.2)
    elseif selectedCars2 >= 3 then
        durationCars2 = getRandomFloat(1.5, 2.5)
    end

    local path = {
        {3102 - carsOffset.x, 1127 - carsOffset.y + 60},
        {2400 - carsOffset.x, 980 - carsOffset.y - 30},
        {1570 - carsOffset.x, 1049 - carsOffset.y - 10}
    }
    setProperty('cars2.angle', 18)
    doTweenAngle('changeCars2Angle', 'cars2', -8, durationCars2, 'linear')
    runHaxeFunction('quadMotionTween', {'cars2', path[1], path[2], path[3], durationCars2, 'linear'})
end

-- Moves a car from left and stops it at the traffic light
function driveCarToLight()
    cars1CanBeReset = false
    selectedCars1 = getRandomInt(1, 4)
    playAnim('cars1', carVariants[selectedCars1])
    if selectedCars1 == 1 then
        durationCars1 = getRandomFloat(1, 1.7)
    elseif selectedCars1 == 2 then
        durationCars1 = getRandomFloat(0.9, 1.5)
    elseif selectedCars1 >= 3 then
        durationCars1 = getRandomFloat(1.5, 2.5)
    end

    local path = {
        {1500 - carsOffset.x - 20, 1049 - carsOffset.y - 20},
        {1770 - carsOffset.x - 80, 994 - carsOffset.y + 10},
        {1950 - carsOffset.x - 80, 980 - carsOffset.y + 15}
    }
    setProperty('cars1.angle', -7)
    doTweenAngle('changeCarsLightAngle', 'cars1', -5, durationCars1, 'cubeOut')
    runHaxeFunction('quadMotionTween', {'cars1', path[1], path[2], path[3], durationCars1, 'cubeOut'})
end

-- Moves a car from the traffic light to the right
function driveCarFromLight()
    isCarWaiting = false
    durationCars1 = getRandomFloat(1.8, 3)
    
    local path = {
        {1950 - carsOffset.x - 80, 980 - carsOffset.y + 15},
        {2400 - carsOffset.x, 980 - carsOffset.y - 50},
        {3102 - carsOffset.x, 1187 - carsOffset.y + 40}
    }
    setProperty('cars1.angle', -5)
    doTweenAngle('changeCars1Angle', 'cars1', 18, durationCars1, 'sineIn')
    runHaxeFunction('quadMotionTween', {'cars1', path[1], path[2], path[3], durationCars1, 'sineIn'})
end

function onTweenCompleted(tag)
    if tag == 'changeCars1Angle' then
        cars1CanBeReset = true
    end
    if tag == 'changeCars2Angle' then
        cars2CanBeReset = true
    end
    if tag == 'changeCarsLightAngle' then
        isCarWaiting = true
        if isRedLight == false then
            local delay = getRandomFloat(0.2, 1.2)
            runTimer('startDelayFromLight', delay)
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'startDelayFromLight' then
        driveCarFromLight()
    end
end

-- Extra function needed for the stage's script
function math.remapToRange(value, start1, stop1, start2, stop2)
    return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1))
end