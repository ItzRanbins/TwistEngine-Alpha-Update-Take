import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.util.FlxAxes;

var bg:FlxSprite;
var defaultBgScale:Float;
var barFill:FlxSprite;

	function create()
	{
		#if desktop
		DiscordClient.changePresence("In the loading screen");
		#end

		bg = new FlxSprite(0, 0, Paths.image("funkay"));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.screenCenter();
		defaultBgScale = bg.scale.x;
		add(bg);

		var barWidth:Int = Std.int(FlxG.width * 0.7);
		var barHeight:Int = 12;
		var barY:Float = FlxG.height - 30;

		barFill = new FlxSprite(0, barY + 2).makeGraphic(barWidth - 4, barHeight - 4, 0xFFFA40AF);
		barFill.screenCenter(FlxAxes.X);

		barFill.origin.set(barFill.width / 2, barFill.height / 2);
		barFill.scale.x = 0;
		add(barFill);
	}

	var maxScale = 0.05;
	var _bopTimer:Float = 0;

	function preUpdate(elapsed:Float)
	{
		_bopTimer = Math.max(_bopTimer - elapsed * 1.2, 0);

		if (controls.ACCEPT)
			_bopTimer = 1.0 + _bopTimer / 10.0;

		var easPerc = (1.0 - FlxEase.expoOut(1 - _bopTimer)) * maxScale;
		bg.scale.set(defaultBgScale * (1 + easPerc), defaultBgScale * (1 + easPerc));
	}

	function onProgress(loaded:Int, ?length:Null<Int>)
	{
		var total = (length != null && length > 0) ? length : 1;
		var progress = loaded / total;

		var progressClamped = Math.max(0, Math.min(1, progress));
		barFill.scale.x = progressClamped;
	}

	function onLoaded()
	{
		if (!transitioning && canLeave)
		{
			funcsPrepare.clearArray();

			ClientPrefs.cacheOnGPU = oldGPUCacheAllowed;
			#if desktop
			DiscordClient.changePresence();
			#end
			onComplete(this);
			transitioning = true;
		}
	}