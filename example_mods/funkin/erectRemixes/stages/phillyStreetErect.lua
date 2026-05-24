function onCreate()
    makeLuaSprite('solidBG', '', -500, -1000)
	makeGraphic('solidBG', 4000, 3000, 'E3E6E6')
	setScrollFactor('solidBG', 0, 0)
	addLuaSprite('solidBG')

    if lowQuality == false then
        for i = 0, 2 do
            makeLuaSprite('sky'..(i + 1), 'streets/erect/phillySkybox', -650, -375)
            scaleObject('sky'..(i + 1), 0.65, 0.65, false)
            setScrollFactor('sky'..(i + 1), 0.1, 0.1)
            addLuaSprite('sky'..(i + 1))
            setProperty('sky'..(i + 1)..'.x', getProperty('sky'..(i + 1)..'.x') + (getProperty('sky'..(i + 1)..'.width') * 0.65) * i)
        end
    end

    makeLuaSprite('skyline', 'streets/erect/phillySkyline', -545, -273)
    setScrollFactor('skyline', 0.2, 0.2)
    addLuaSprite('skyline')

    if lowQuality == false then
        makeLuaSprite('cityBuildingsLeft', 'streets/erect/phillyForegroundCity', 600, 69)
        setScrollFactor('cityBuildingsLeft', 0.3, 0.3)
        addLuaSprite('cityBuildingsLeft')

        makeLuaSprite('cityBuildingsRight', 'streets/erect/phillyForegroundCity', 1860, 185)
        setScrollFactor('cityBuildingsRight', 0.3, 0.3)
        addLuaSprite('cityBuildingsRight')
        setProperty('cityBuildingsRight.angle', 5)
        setProperty('cityBuildingsRight.flipX', true)
    end
    
    makeLuaSprite('constructionSite', 'streets/erect/phillyConstruction', 1795, 360)
    setScrollFactor('constructionSite', 0.7, 1)
    addLuaSprite('constructionSite')

    if lowQuality == false then
        makeLuaSprite('highwayLights', 'streets/erect/phillyHighwayLights', 122, 201)
        setScrollFactor('highwayLights', 0.8, 0.8)
        addLuaSprite('highwayLights')

        makeLuaSprite('highwayLights_lightmap', 'streets/phillyHighwayLights_lightmap', 122, 201)
        setScrollFactor('highwayLights_lightmap', 0.8, 0.8)
        setBlendMode('highwayLights_lightmap', 'ADD')
        addLuaSprite('highwayLights_lightmap')
        setProperty('highwayLights_lightmap.alpha', 0.6)

        makeLuaSprite('highway', 'streets/erect/phillyHighway', -23, 105)
        setScrollFactor('highway', 0.8, 0.8)
        addLuaSprite('highway')
    end

    makeAnimatedLuaSprite('cars1', 'streets/erect/phillyCars', 1200, 818)
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
    
    makeAnimatedLuaSprite('cars2', 'streets/erect/phillyCars', 1200, 818)
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

    makeAnimatedLuaSprite('trafficLights', 'streets/erect/phillyTraffic', 1840, 608)
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

        makeLuaSprite('gradient1', 'streets/erect/greyGradient', -388, 7)
        scaleObject('gradient1', 1.3, 1.3)
        setBlendMode('gradient1', 'ADD')
        addLuaSprite('gradient1')
        setProperty('gradient1.alpha', 0.3)

        makeLuaSprite('gradient2', 'streets/erect/greyGradient', -388, 7)
        scaleObject('gradient2', 1.3, 1.3)
        setBlendMode('gradient2', 'MULTIPLY')
        addLuaSprite('gradient2')
        setProperty('gradient2.alpha', 0.8)
    end
    
    makeLuaSprite('street', 'streets/erect/phillyForeground', 88, 317)
    addLuaSprite('street')

    makeLuaSprite('sprayCans', 'streets/SpraycanPile', 920, 1045)
    addLuaSprite('sprayCans', true)

    makeAnimatedLuaSprite('paper', 'streets/erect/paper', 350, 608)
    addAnimationByPrefix('paper', 'anim', 'Paper Blowing instance 1', 24, false)
    setScrollFactor('paper', 1.1, 1.1)
    addLuaSprite('paper', true)
    setProperty('paper.visible', false)
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

    -- Creates the endless mists on the stage
    if lowQuality == false then
        mistData = {
            {mistImage = 'mistMid', scrollFactor = 1.2, alpha = 0.6, velocity = 172, scale = 1, objectOrder = ''},
            {mistImage = 'mistMid', scrollFactor = 1.1, alpha = 0.6, velocity = 150, scale = 1, objectOrder = ''},
            {mistImage = 'mistBack', scrollFactor = 1.2, alpha = 0.8, velocity = -80, scale = 1.5, objectOrder = ''},
            {mistImage = 'mistMid', scrollFactor = 0.95, alpha = 0.5, velocity = -50, scale = 0.8, objectOrder = 'street'},
            {mistImage = 'mistBack', scrollFactor = 0.8, alpha = 1, velocity = 40, scale = 0.7, objectOrder = 'trafficLights'},
            {mistImage = 'mistMid', scrollFactor = 0.5, alpha = 1, velocity = 20, scale = 1.1, objectOrder = 'constructionSite'}
        }
        for mistNum, data in ipairs(mistData) do
            for i = 0, 2 do
                makeLuaSprite('mist'..mistNum..''..(i + 1), 'phillyStreets/erect/'..data.mistImage, -650, -100)
                scaleObject('mist'..mistNum..''..(i + 1), data.scale, data.scale, false)
                setScrollFactor('mist'..mistNum..''..(i + 1), data.scrollFactor, data.scrollFactor)
                setBlendMode('mist'..mistNum..''..(i + 1), 'ADD')
                if data.objectOrder ~= '' then
                    setObjectOrder('mist'..mistNum..''..(i + 1), getObjectOrder(data.objectOrder))
                end
                addLuaSprite('mist'..mistNum..''..(i + 1), true)
                setProperty('mist'..mistNum..''..(i + 1)..'.alpha', data.alpha)
                setProperty('mist'..mistNum..''..(i + 1)..'.color', 0x5C5C5C)
                setProperty('mist'..mistNum..''..(i + 1)..'.velocity.x', data.velocity)
                local offsetMist = getProperty('mist'..mistNum..''..(i + 1)..'.x') + (getProperty('mist'..mistNum..''..(i + 1)..'.width') * data.scale) * i
                setProperty('mist'..mistNum..''..(i + 1)..'.x', offsetMist)
            end
        end
    end

    if shadersEnabled == true then
        -- Adds the shaders on the characters/sprites
        initLuaShader('adjustColor')
        for i, object in ipairs({'boyfriend', 'dad', 'gf', 'sprayCans'}) do
            setSpriteShader(object, 'adjustColor')
            setShaderFloat(object, 'hue', -5)
            setShaderFloat(object, 'saturation', -40)
            setShaderFloat(object, 'contrast', -25)
            setShaderFloat(object, 'brightness', -20)
        end

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
        setShaderFloatArray('rainFilter', 'uRainColor', {168 / 255, 173 / 255, 181 / 255})
        setShaderFloatArray('rainFilter', 'uFrameBounds', {0, 0, screenWidth, screenHeight})
        runHaxeFunction('activateRainShader')
    end
end

local elapsedTime = 0
function onUpdate(elapsed)
    if lowQuality == false or shadersEnabled == true then
        elapsedTime = elapsedTime + elapsed
    end

    if lowQuality == false then
        --[[
            This controls the movement of the sky on the stage. 
            It uses 3 'sky' sprites, and move them right behind eachother. 
            When one of them goes offscreen, it moves behind the rest to make the skyBox seemless.
        ]]
        for i = 1, 3 do
            if getProperty('sky'..i..'.x') < -(getProperty('sky'..i..'.width') * 0.65) * 2 then
                setProperty('sky'..i..'.x', getProperty('sky'..i..'.x') + (getProperty('sky'..i..'.width') * 0.65) * 3)
            end
            setProperty('sky'..i..'.x', getProperty('sky'..i..'.x') - elapsed * 22)
        end

        --[[
            This controls the movement of the mists on the stage. 
            It uses 3 similar 'mist' sprites, and move them right behind eachother. 
            When one of them goes offscreen, it moves behind the rest to make it seemless.
            This is applied to all 6 'mist' that are on the stage.
        ]]
        for mistNum, mistScale in ipairs({1, 1, 1.5, 0.8, 0.7, 1.1}) do
            for i = 1, 3 do
                if getProperty('mist'..mistNum..''..i..'.velocity.x') > 0 then
                    if getProperty('mist'..mistNum..''..i..'.x') > (getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 1.5 then
                        setProperty('mist'..mistNum..''..i..'.x', getProperty('mist'..mistNum..''..i..'.x') - (getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 3)
                    end
                else
                    if getProperty('mist'..mistNum..''..i..'.x') < -(getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 1.5 then
                        setProperty('mist'..mistNum..''..i..'.x', getProperty('mist'..mistNum..''..i..'.x') + (getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 3)
                    end
                end
            end
        end
        for i = 1, 3 do
            setProperty('mist1'..i..'.y', 660 + (math.sin(elapsedTime * 0.35) * 70))
            setProperty('mist2'..i..'.y', 500 + (math.sin(elapsedTime * 0.3) * 80))
            setProperty('mist3'..i..'.y', 540 + (math.sin(elapsedTime * 0.4) * 60))
            setProperty('mist4'..i..'.y', 230 + (math.sin(elapsedTime * 0.3) * 70))
            setProperty('mist5'..i..'.y', 170 + (math.sin(elapsedTime * 0.35) * 50))
            setProperty('mist6'..i..'.y', -80 + (math.sin(elapsedTime * 0.08) * 100))
        end
    end
    
    -- Makes the rain active and increase its intensity from 'intensityStart' to 'intensityEnd'
    if shadersEnabled == true then
        intensityValue = math.remapToRange(getSongPosition(), 0, songLength, intensityStart, intensityEnd)
        setShaderFloat('rainFilter', 'uIntensity', intensityValue)
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
paperCanBeReset = true
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

    -- Blown paper
    if getRandomBool(0.6) and paperCanBeReset == true then
        paperCanBeReset = false
        local offsetPaper = getRandomFloat(-150, 150)
        setProperty('paper.y', 608 + offsetPaper)
        setProperty('paper.visible', true)
        playAnim('paper', 'anim')
        runTimer('paperReset', 2)
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
    if tag == 'paperReset' then
        paperCanBeReset = true
        setProperty('paper.visible', false)
    end
    if tag == 'startDelayFromLight' then
        driveCarFromLight()
    end
end

-- Extra function needed for the stage's script
function math.remapToRange(value, start1, stop1, start2, stop2)
    return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1))
end