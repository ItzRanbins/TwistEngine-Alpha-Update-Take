function onCreate()
    makeLuaSprite('sky', 'stages/week6/weebSky', -626, -78)
	scaleObject('sky', 6, 6)
	setScrollFactor('sky', 0.2, 0.2)
	addLuaSprite('sky')
	setProperty('sky.antialiasing', false)

	if lowQuality == false then
		makeLuaSprite('treesBG', 'stages/week6/weebBackTrees', -842, -80)
		scaleObject('treesBG', 6, 6)
		setScrollFactor('treesBG', 0.5, 0.5)
		addLuaSprite('treesBG')
		setProperty('treesBG.antialiasing', false)
	end

	makeLuaSprite('school', 'stages/week6/weebSchool', -816, -38)
	scaleObject('school', 6, 6)
	setScrollFactor('school', 0.75, 0.75)
	addLuaSprite('school')
	setProperty('school.antialiasing', false)

	makeLuaSprite('street', 'stages/week6/weebStreet', -662, 6)
	scaleObject('street', 6, 6)
	addLuaSprite('street')
	setProperty('street.antialiasing', false)

	if lowQuality == false then
		makeLuaSprite('treesBack', 'stages/week6/weebTreesBack', -500, 6)
		scaleObject('treesBack', 6, 6)
		addLuaSprite('treesBack')
		setProperty('treesBack.antialiasing', false)
	end

	makeAnimatedLuaSprite('trees', 'stages/week6/weebTrees', -806, -1050, 'packer')
	addAnimation('trees', 'anim', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}, 12)
	scaleObject('trees', 6, 6)
	addLuaSprite('trees')
	setProperty('trees.antialiasing', false)

	if lowQuality == false then
		makeAnimatedLuaSprite('leaves', 'stages/week6/petals', -20, -40)
		addAnimationByPrefix('leaves', 'anim', 'PETALS ALL', 24, true)
		scaleObject('leaves', 6, 6)
		setScrollFactor('leaves', 0.85, 0.85)
		addLuaSprite('leaves')
		setProperty('leaves.antialiasing', false)

		makeAnimatedLuaSprite('girlfreaks', 'stages/week6/bgFreaks', -646, 222)
		addAnimationByIndices('girlfreaks', 'danceRight-mad', 'BG fangirls dissuaded', {15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29}, 24, false)
		addAnimationByIndices('girlfreaks', 'danceLeft-mad', 'BG fangirls dissuaded', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 24, false)
		addAnimationByIndices('girlfreaks', 'danceRight', 'BG girls group', {15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29}, 24, false)
		addAnimationByIndices('girlfreaks', 'danceLeft', 'BG girls group', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 24, false)
		scaleObject('girlfreaks', 6, 6)
		addLuaSprite('girlfreaks')
		setProperty('girlfreaks.antialiasing', false)
	end

    -- Default Game Over
	setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'bf-pixel-dead')
	setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-pixel')
	setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'gameOver-pixel')
	setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'gameOverEnd-pixel')
end

--[[
	Everything below is to make the characters bop their head on beat.
	It also checks if the 'BG Freaks Expression' event is played to swap their dance anim.
]]
girlsDanced = true
girlsSuffix = ''
function onBeatHit()
	-- Freaks dancing on beat
    if lowQuality == false then
		girlsDanced = not girlsDanced
		if girlsDanced == true then
			playAnim('girlfreaks', 'danceLeft'..girlsSuffix, true)
		else
			playAnim('girlfreaks', 'danceRight'..girlsSuffix, true)
		end
	end
end

-- Swaps the freaks' expression for their dance anim
function onEvent(event, value1, value2, strumTime)
    if event == 'BG Freaks Expression' and lowQuality == false then
        if girlsSuffix == '' then
            girlsSuffix = '-mad'
        else
            girlsSuffix = ''
        end

        if girlsDanced == true then
			playAnim('girlfreaks', 'danceLeft'..girlsSuffix, true)
		else
			playAnim('girlfreaks', 'danceRight'..girlsSuffix, true)
		end
    end
end