package game.states;

import game.backend.system.song.Conductor.mainInstance as Conductor;
import game.backend.data.jsons.WeekData;
import game.backend.utils.ClientPrefs;
import game.objects.Alphabet;
import game.states.MainMenuState;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
import haxe.Json;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if DISCORD_RPC
import game.backend.system.net.Discord;
#end

typedef TitleData =
{
	var titlex:Float;
	var titley:Float;
	var startx:Float;
	var starty:Float;
	var gfx:Float;
	var gfy:Float;
	var backgroundSprite:String;
	var bpm:Float;

	@:optional var animation:String;
	@:optional var dance_left:Array<Int>;
	@:optional var dance_right:Array<Int>;
	@:optional var idle:Bool;
	@:optional var easterbpm:Float;
}

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var credGroup:FlxGroup = new FlxGroup();
	var textGroup:FlxGroup = new FlxGroup();
	var blackScreen:FlxSprite;
	var credTextShit:Alphabet;
	var ngSpr:FlxSprite;

	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];
	var wackyImage:FlxSprite;

	var easterBPM:Float = 160;
	var easterCode:Array<FlxKey> = [
		FlxKey.LEFT,
		FlxKey.RIGHT,
		FlxKey.LEFT,
		FlxKey.RIGHT,
		FlxKey.UP,
		FlxKey.DOWN,
		FlxKey.UP,
		FlxKey.DOWN
	];
	var easterIndex:Int = 0;
	var easterTriggered:Bool = false;
	var easterShader:FlxRuntimeShader;
	var curHue:Float = 0.0;

	override public function create():Void
	{
		Paths.clearStoredMemory();
		super.create();
		Paths.clearUnusedMemory();

		if (!initialized)
		{
			ClientPrefs.loadPrefs();
		}

		#if DISCORD_RPC
		DiscordClient.changePresence("In the Title Screen", null);
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());

		if (!initialized)
		{
			if (FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		FlxG.mouse.visible = false;
		startIntro();
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		persistentUpdate = true;
		if (!initialized && FlxG.sound.music == null)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

		loadJsonData();
		Conductor.bpm = musicBPM;

		Paths.music('girlfriendsRingtone');
		Paths.sound('confirmMenu');

		logoBl = new FlxSprite(logoPosition.x, logoPosition.y);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.data.globalAntialiasing;

		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();

		gfDance = new FlxSprite(gfPosition.x, gfPosition.y);
		gfDance.antialiasing = ClientPrefs.data.globalAntialiasing;

		gfDance.frames = Paths.getSparrowAtlas(characterImage);

		gfDance.animation.addByPrefix('hey', 'gfHey', 24, false);

		if (!useIdle)
		{
			gfDance.animation.addByIndices('danceLeft', animationName, danceLeftFrames, "", 24, false);
			gfDance.animation.addByIndices('danceRight', animationName, danceRightFrames, "", 24, false);
			gfDance.animation.play('danceRight');
		}
		else
		{
			gfDance.animation.addByPrefix('idle', animationName, 24, false);
			gfDance.animation.play('idle');
		}

		var animFrames:Array<FlxFrame> = [];
		titleText = new FlxSprite(enterPosition.x, enterPosition.y);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		@:privateAccess
		{
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}

		if (newTitle = animFrames.length > 0)
		{
			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.data.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else
		{
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		}
		titleText.animation.play('idle');
		titleText.updateHitbox();

		blackScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		blackScreen.scale.set(FlxG.width, FlxG.height);
		blackScreen.updateHitbox();
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.data.globalAntialiasing;

		add(gfDance);
		add(logoBl);
		add(titleText);
		add(credGroup);
		add(ngSpr);

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	var characterImage:String = 'gfDanceTitle';
	var animationName:String = 'gfDance';
	var gfPosition:FlxPoint = FlxPoint.get(512, 40);
	var logoPosition:FlxPoint = FlxPoint.get(-150, -100);
	var enterPosition:FlxPoint = FlxPoint.get(100, 576);
	var useIdle:Bool = false;
	var musicBPM:Float = 102;
	var danceLeftFrames:Array<Int> = [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29];
	var danceRightFrames:Array<Int> = [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];

	function loadJsonData()
	{
		if (Paths.fileExists('data/titleConfig.json', TEXT))
		{
			var titleRaw:String = Paths.getTextFromFile('data/titleConfig.json');
			if (titleRaw != null && titleRaw.length > 0)
			{
				try
				{
					var titleJSON:TitleData = cast haxe.Json.parse(titleRaw);
					gfPosition.set(titleJSON.gfx, titleJSON.gfy);
					logoPosition.set(titleJSON.titlex, titleJSON.titley);
					enterPosition.set(titleJSON.startx, titleJSON.starty);
					musicBPM = titleJSON.bpm;

					if (titleJSON.easterbpm != null)
						easterBPM = titleJSON.easterbpm;

					if (titleJSON.animation != null && titleJSON.animation.length > 0)
						animationName = titleJSON.animation;
					if (titleJSON.dance_left != null && titleJSON.dance_left.length > 0)
						danceLeftFrames = titleJSON.dance_left;
					if (titleJSON.dance_right != null && titleJSON.dance_right.length > 0)
						danceRightFrames = titleJSON.dance_right;
					useIdle = (titleJSON.idle == true);
				}
				catch (e:haxe.Exception)
				{
					trace('[WARN] Title JSON might broken, ignoring issue...\n${e.details()}');
				}
			}
			else
				trace('[WARN] No Title JSON detected, using default values.');
		}
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));
		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];
		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, FlxMath.bound(1 - (elapsed * 3.125), 0, 1));

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;
		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;
			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (newTitle)
		{
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2)
				titleTimer -= 2;
		}

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				timer = FlxEase.quadInOut(timer);

				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}

			if (pressedEnter)
			{
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				if (titleText != null)
					titleText.animation.play('press');

				FlxG.camera.stopFX();
				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);

				if (gfDance != null)
					gfDance.animation.play('hey', true);

				if (easterTriggered)
				{
					if (FlxG.sound.music != null)
						FlxG.sound.music.fadeOut(1, 0);

					FlxTween.tween(this, {curHue: 0.0}, 1, {
						ease: FlxEase.expoOut,
						onUpdate: function(twn:FlxTween)
						{
							if (easterShader != null)
							{
								easterShader.setFloat('hue', curHue);
							}
						},
						onComplete: function(twn:FlxTween)
						{
							FlxG.camera.setFilters([]);
						}
					});
				}

				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (easterTriggered && FlxG.sound.music != null)
						FlxG.sound.music.stop();

					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if (skippedIntro && !easterTriggered && FlxG.keys.justPressed.ANY)
		{
			var keyPressed = FlxG.keys.firstJustPressed();
			if (keyPressed != FlxKey.NONE)
			{
				if (keyPressed == easterCode[easterIndex])
				{
					easterIndex++;
					if (easterIndex >= easterCode.length)
					{
						ringtoneEaster();
					}
				}
				else
				{
					easterIndex = 0;
					if (keyPressed == easterCode[0])
					{
						easterIndex = 1;
					}
				}
			}
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if (credGroup != null && textGroup != null)
			{
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if (textGroup != null && credGroup != null)
		{
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0;

	public static var closedState:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if (FlxG.camera.zoom < 1.35 && curBeat % 1 == 0)
		{
			FlxG.camera.zoom += 0.015;
		}

		if (logoBl != null)
			logoBl.animation.play('bump', true);

		if (gfDance != null && !transitioning)
		{
			danceLeft = !danceLeft;
			if (!useIdle)
			{
				if (danceLeft)
					gfDance.animation.play('danceRight');
				else
					gfDance.animation.play('danceLeft');
			}
			else if (curBeat % 2 == 0)
				gfDance.animation.play('idle', true);
		}

		if (easterTriggered && curBeat % 2 == 0 && !transitioning)
		{
			curHue += 0.15;
			if (curHue > 1.0)
				curHue = 0.0;
			if (easterShader != null)
			{
				easterShader.setFloat('hue', curHue);
			}
		}

		if (!closedState)
		{
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.7);
				case 2:
					createCoolText(['Twist Engine by'], 40);
				case 4:
					addMoreText('Redar13', 40);
					addMoreText('ItzRanbins', 40);
				case 5:
					deleteCoolText();
				case 6:
					createCoolText(['Not associated', 'with'], -40);
				case 8:
					addMoreText('Newgrounds', -40);
					ngSpr.visible = true;
				case 9:
					deleteCoolText();
					ngSpr.visible = false;
				case 10:
					createCoolText([curWacky[0]]);
				case 12:
					addMoreText(curWacky[1]);
				case 13:
					deleteCoolText();
				case 14:
					addMoreText('Friday');
				case 15:
					addMoreText('Night');
				case 16:
					addMoreText('Funkin');
				case 17:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(credGroup);
			FlxG.camera.stopFX();
			FlxG.camera.flash(FlxColor.WHITE, 2);
			skippedIntro = true;
		}
	}

	function ringtoneEaster():Void
	{
		easterTriggered = true;

		FlxG.camera.stopFX();
		FlxG.camera.flash(FlxColor.WHITE, 1);

		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		FlxG.sound.playMusic(Paths.music('girlfriendsRingtone'), 1);

		Conductor.bpm = easterBPM;
		musicBPM = easterBPM;

		curHue = FlxG.random.float(0.0, 1.0);

		try
		{
			var shaderText = Paths.getTextFromFile('shaders/hue.frag');
			if (shaderText != null)
			{
				easterShader = new FlxRuntimeShader(shaderText);
				easterShader.setFloat('hue', curHue);
				FlxG.camera.setFilters([new ShaderFilter(easterShader)]);
			}
		}
		catch (e:Dynamic)
		{
			trace(e);
		}
	}
}