package game.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import game.backend.data.jsons.WeekData;
import game.backend.system.song.Song;
import game.states.playstate.PlayState;
import game.objects.MenuCharacter;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class StoryMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var curDifficulty:Int = 0;
	var loadedWeeks:Array<WeekData> = [];
	var currentWeekDifficulties:Array<String> = [];

	var bgSprite:FlxSprite;
	var bgSpriteFade:FlxSprite;
	var txtDescription:FlxText;
	var txtTracklist:FlxText;

	var scoreText:FlxText;
	var intendedScore:Int = 0;
	var lerpScore:Int = 0;

	var grpWeeks:FlxTypedGroup<FlxSprite>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	var difficultySprite:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var topBlackBar:FlxSprite;

	var yPositions:Array<Float> = [];

	var targetTextDesc:String = "";
	var displayedIndicesDesc:Array<Int> = [];
	var isScramblingDesc:Bool = false;
	var scrambleTimerDesc:Float = 0;

	var targetTextTrack:String = "";
	var displayedIndicesTrack:Array<Int> = [];
	var isScramblingTrack:Bool = false;
	var scrambleTimerTrack:Float = 0;

	var glitchChars:String = "█▓▒░@#$%&!?";

	override function create()
	{
		WeekData.reloadWeeksFiles(true);

		for (key in WeekData.weeksListOrder)
		{
			var week:WeekData = WeekData.weeksDatas.get(key.file);
			if (week != null && week.data.storyMenu != null && week.data.storyMenu.hide != true)
			{
				loadedWeeks.push(week);
			}
		}

		for (week in loadedWeeks)
		{
			var wData = week.data;
			Paths.image('menus/storyMode/smBackgrounds/' + (wData.storyMenu.bg != null ? wData.storyMenu.bg : 'stage'));

			var diffs = (wData.difficulties != null && wData.difficulties.length > 0) ? wData.difficulties : ["normal"];
			for (diff in diffs) Paths.image('menus/storyMode/smDifficulties/' + diff.toLowerCase());

			if (wData.storyMenu.character != null)
			{
				for (charName in wData.storyMenu.character)
				{
					if (charName != null && charName != '') {
						var tempChar = new MenuCharacter(0, charName);
						tempChar.destroy();
					}
				}
			}
		}

		grpWeeks = new FlxTypedGroup<FlxSprite>();
		add(grpWeeks);

		var currentY:Float = 550;
		for (i in 0...loadedWeeks.length)
		{
			var weekThing:FlxSprite = new FlxSprite(0, currentY);
			weekThing.loadGraphic(Paths.image('menus/storyMode/smTitles/' + loadedWeeks[i].data.storyMenu.title));
			weekThing.screenCenter(X);
			weekThing.ID = i;
			yPositions.push(currentY);
			currentY += weekThing.height + 30;
			grpWeeks.add(weekThing);
		}

		topBlackBar = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width), 56, FlxColor.BLACK);
		add(topBlackBar);

		bgSprite = new FlxSprite(0, 56);
		add(bgSprite);

		bgSpriteFade = new FlxSprite(0, 56);
		bgSpriteFade.alpha = 0;
		add(bgSpriteFade);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();
		for (charSlot in 0...3)
		{
			var posX:Float = (FlxG.width * 0.25) * (charSlot + 1) - 150;
			var weekChar:MenuCharacter = new MenuCharacter(posX, 'bf');
			weekChar.y += 70;
			grpWeekCharacters.add(weekChar);
		}
		add(grpWeekCharacters);

		txtDescription = new FlxText(FlxG.width - 900, 20, 850, "", 24);
		txtDescription.setFormat(Paths.font("Better VCR 6.1.ttf"), 24, 0xFFB5B5B5, RIGHT);
		txtDescription.wordWrap = false;
		add(txtDescription);

		scoreText = new FlxText(20, 20, 0, "LEVEL SCORE: 0", 24);
		scoreText.setFormat(Paths.font("Better VCR 6.1.ttf"), 24, 0xFFB5B5B5, LEFT);
		add(scoreText);

		txtTracklist = new FlxText(20, FlxG.height - 215, 400, "", 32);
		txtTracklist.setFormat(Paths.font("Better VCR 6.1.ttf"), 24, 0xFFE55777, CENTER);
		add(txtTracklist);

		var uiAtlas = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var uiY:Float = 460;

		leftArrow = new FlxSprite(FlxG.width - 350, uiY);
		leftArrow.frames = uiAtlas;
		leftArrow.animation.addByPrefix('idle', 'arrow left');
		leftArrow.animation.addByPrefix('press', 'arrow push left');
		leftArrow.animation.play('idle');
		add(leftArrow);

		difficultySprite = new FlxSprite(0, 0);
		difficultySprite.scale.set(0.8, 0.8);
		difficultySprite.updateHitbox();
		add(difficultySprite);

		rightArrow = new FlxSprite(leftArrow.x + 250, uiY);
		rightArrow.frames = uiAtlas;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', 'arrow push right');
		rightArrow.animation.play('idle');
		add(rightArrow);

		if (loadedWeeks.length > 0) changeSelection(0);

		super.create();
	}

	function scrambleText(desc:String, track:String)
	{
		targetTextDesc = desc.toUpperCase();
		displayedIndicesDesc = [];
		for (i in 0...targetTextDesc.length) {
			if (targetTextDesc.charAt(i) == ' ' || targetTextDesc.charAt(i) == '\n') displayedIndicesDesc.push(i);
		}
		scrambleTimerDesc = 0;
		isScramblingDesc = true;

		targetTextTrack = track.toUpperCase();
		displayedIndicesTrack = [];
		for (i in 0...targetTextTrack.length) {
			if (targetTextTrack.charAt(i) == ' ' || targetTextTrack.charAt(i) == '\n') displayedIndicesTrack.push(i);
		}
		scrambleTimerTrack = 0;
		isScramblingTrack = true;
	}

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, Math.min(1, elapsed * 30)));
		if (Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;
		scoreText.text = "LEVEL SCORE: " + lerpScore;

		if (controls.UI_UP_P) changeSelection(-1);
		if (controls.UI_DOWN_P) changeSelection(1);
		if (controls.UI_LEFT_P) changeDifficulty(-1);
		if (controls.UI_RIGHT_P) changeDifficulty(1);

		leftArrow.animation.play(controls.UI_LEFT ? 'press' : 'idle');
		rightArrow.animation.play(controls.UI_RIGHT ? 'press' : 'idle');

		if (isScramblingDesc)
		{
			scrambleTimerDesc += elapsed * 80;
			while (scrambleTimerDesc >= 1 && isScramblingDesc)
			{
				scrambleTimerDesc -= 1;
				var remainingIndices:Array<Int> = [];
				for (i in 0...targetTextDesc.length) {
					if (displayedIndicesDesc.indexOf(i) == -1) remainingIndices.push(i);
				}
				if (remainingIndices.length > 0)
					displayedIndicesDesc.push(remainingIndices[FlxG.random.int(0, remainingIndices.length - 1)]);
				else
					isScramblingDesc = false;
			}
			var currentDisplay:String = "";
			for (i in 0...targetTextDesc.length) {
				if (displayedIndicesDesc.indexOf(i) != -1) currentDisplay += targetTextDesc.charAt(i);
				else currentDisplay += glitchChars.charAt(FlxG.random.int(0, glitchChars.length - 1));
			}
			txtDescription.text = currentDisplay;
		}

		if (isScramblingTrack)
		{
			scrambleTimerTrack += elapsed * 80;
			while (scrambleTimerTrack >= 1 && isScramblingTrack)
			{
				scrambleTimerTrack -= 1;
				var remainingIndices:Array<Int> = [];
				for (i in 0...targetTextTrack.length) {
					if (displayedIndicesTrack.indexOf(i) == -1) remainingIndices.push(i);
				}
				if (remainingIndices.length > 0)
					displayedIndicesTrack.push(remainingIndices[FlxG.random.int(0, remainingIndices.length - 1)]);
				else
					isScramblingTrack = false;
			}
			var currentDisplay:String = "";
			for (i in 0...targetTextTrack.length) {
				if (displayedIndicesTrack.indexOf(i) != -1) currentDisplay += targetTextTrack.charAt(i);
				else currentDisplay += glitchChars.charAt(FlxG.random.int(0, glitchChars.length - 1));
			}
			txtTracklist.text = "TRACKS:\n\n" + currentDisplay;
		}

		grpWeeks.forEach(function(spr:FlxSprite) {
			var dist:Float = Math.abs(spr.ID - curSelected);
			var targetY:Float = yPositions[spr.ID] - (yPositions[curSelected] - 475);
			spr.y = FlxMath.lerp(spr.y, targetY, 0.05);
			spr.screenCenter(X);
			spr.alpha = FlxMath.lerp(spr.alpha, Math.max(0.0, 1.0 - (dist * 0.5)), 0.15);
			var scale = Math.max(0.5, 1.0 - (dist * 0.15));
			spr.scale.set(FlxMath.lerp(spr.scale.x, scale, 0.15), FlxMath.lerp(spr.scale.y, scale, 0.15));
		});

		if (controls.ACCEPT && loadedWeeks.length > 0) selectWeek();
		if (controls.BACK) MusicBeatState.switchState(new MainMenuState());

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		if (change != 0) FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;
		if (curSelected >= loadedWeeks.length) curSelected = 0;
		if (curSelected < 0) curSelected = loadedWeeks.length - 1;

		var currentWeek = loadedWeeks[curSelected].data;
		currentWeekDifficulties = (currentWeek.difficulties != null && currentWeek.difficulties.length > 0) ? currentWeek.difficulties : ["normal"];

		curDifficulty = 0;
		updateDifficultyDisplay();

		var trackString:String = "";
		for (song in currentWeek.songs) trackString += song.songName + "\n";

		scrambleText(currentWeek.storyMenu.description != null ? currentWeek.storyMenu.description : "", trackString);

		var bgName:String = currentWeek.storyMenu.bg != null ? currentWeek.storyMenu.bg : 'stage';
		var newBg = Paths.image('menus/storyMode/smBackgrounds/' + bgName);

		if (change == 0)
		{
			bgSprite.loadGraphic(newBg);
		}
		else
		{
			FlxTween.cancelTweensOf(bgSpriteFade);

			bgSpriteFade.loadGraphic(newBg);
			bgSpriteFade.alpha = 0;

			FlxTween.tween(bgSpriteFade, {alpha: 1}, 0.1, {
				onComplete: function(twn:FlxTween) {
					bgSprite.loadGraphic(newBg);
					bgSpriteFade.alpha = 0;
				}
			});
		}

		for (i in 0...grpWeekCharacters.members.length)
		{
			var charSprite = grpWeekCharacters.members[i];
			if (currentWeek.storyMenu.character != null && currentWeek.storyMenu.character[i] != null && currentWeek.storyMenu.character[i] != '')
			{
				charSprite.visible = true;
				charSprite.changeCharacter(currentWeek.storyMenu.character[i]);
			}
			else
				charSprite.visible = false;
		}
	}

	function changeDifficulty(change:Int = 0)
	{
		if (change != 0) FlxG.sound.play(Paths.sound('scrollMenu'));

		curDifficulty += change;
		if (curDifficulty < 0) curDifficulty = currentWeekDifficulties.length - 1;
		if (curDifficulty >= currentWeekDifficulties.length) curDifficulty = 0;

		updateDifficultyDisplay();
	}

	function updateDifficultyDisplay()
	{
		var diffName:String = currentWeekDifficulties[curDifficulty].toLowerCase();
		difficultySprite.loadGraphic(Paths.image('menus/storyMode/smDifficulties/' + diffName));
		difficultySprite.updateHitbox();

		if (diffName == "normal" || diffName == "erect")
		{
			difficultySprite.scale.set(0.6, 0.6);
			difficultySprite.updateHitbox();
		}
		else
		{
			difficultySprite.scale.set(0.8, 0.8);
			difficultySprite.updateHitbox();
		}

		var arrowGap:Float = (rightArrow.x + rightArrow.width) - leftArrow.x;
		difficultySprite.x = leftArrow.x + (arrowGap / 2) - (difficultySprite.width / 2);

		var targetY:Float = leftArrow.y + (leftArrow.height / 2) - (difficultySprite.height / 2);
		difficultySprite.y = targetY - 15;
		difficultySprite.alpha = 0;

		FlxTween.cancelTweensOf(difficultySprite);
		FlxTween.tween(difficultySprite, {y: targetY, alpha: 1}, 0.07);
	}

	function selectWeek()
	{
		var week = loadedWeeks[curSelected];
		var playlist:Array<String> = [for (song in week.data.songs) song.songName];
		PlayState.isStoryMode = true;
		PlayState.storyPlaylist = playlist;
		var diffName:String = currentWeekDifficulties[curDifficulty].toLowerCase();
		var diffSuffix:String = (diffName == "normal") ? "" : "-" + diffName;

		for (char in grpWeekCharacters.members)
		{
			if (char != null && char.hasConfirmAnimation)
				char.animation.play('confirm');
		}

		FlxG.sound.play(Paths.sound('confirmMenu'));

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			PlayState.SONG = Song.loadFromJson(playlist[0].toLowerCase() + diffSuffix, playlist[0].toLowerCase());
			LoadingState.loadAndSwitchState(new PlayState());
		});
	}
}