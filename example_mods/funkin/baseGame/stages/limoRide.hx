import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.FlxG;

// Объявление глобальных переменных (переменных класса/скрипта)
var sky:FlxSprite;
var limoBG:FlxSprite;
var henchmen:Array<FlxSprite> = [];
var car:FlxSprite;
var limo:FlxSprite;

var lightPole:FlxSprite;
var light:FlxSprite;
var henchmanCorpse1:FlxSprite;
var henchmanCorpse2:FlxSprite;

var eventInitialized:Bool = false;
var henchmenDanced:Bool = true;
var carCanDrive:Bool = true;

var curKillState:Int = 0;
var henchmenParticles:Array<FlxSprite> = [];
var limoSpeed:Float = 0;

function onCreate()
{
    // Задний фон - Небо
    sky = new FlxSprite(-300, -150, Paths.image('stages/week4/limoSunset'));
    sky.scrollFactor.set(0.1, 0.1);
    addHxObject(sky);

    // Если в игре не включено низкое качество
    if (!ClientPrefs.data.lowQuality) // Или !lowQuality в зависимости от вашей сборки
    {
        limoBG = new FlxSprite(-200, 480);
        limoBG.frames = Paths.getSparrowAtlas('stages/week4/bgLimo');
        limoBG.animation.addByPrefix('anim', 'background limo pink', 24, true);
        limoBG.animation.play('anim');
        limoBG.scrollFactor.set(0.4, 0.4);
        addHxObject(limoBG);

        for (i in 1...6) // Цикл от 1 до 5 включительно
        {
            var henchman = new FlxSprite(-200 + (300 * i), 100);
            henchman.frames = Paths.getSparrowAtlas('stages/week4/limoDancer');
            henchman.animation.addByIndices('danceRight', 'bg dancer sketch PINK', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
            henchman.animation.addByIndices('danceLeft', 'bg dancer sketch PINK', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
            henchman.scrollFactor.set(0.4, 0.4);
            addHxObject(henchman);
            henchmen.push(henchman);
        }
    }

    // Пролетающая машина
    car = new FlxSprite(-12600, 280, Paths.image('stages/week4/fastCarLol'));
    addHxObject(car);

    // Главный лимузин, на котором стоят GF и BF
    limo = new FlxSprite(-120, 550);
    limo.frames = Paths.getSparrowAtlas('stages/week4/limoDrive');
    limo.animation.addByPrefix('anim', 'Limo stage', 24, true);
    limo.animation.play('anim');

    // Кэширование звуков в Haxe/OpenFL
    Paths.sound('carPass0');
    Paths.sound('carPass1');
}

function onCreatePost()
{
    // Проверяем, существует ли группа GF
    if (game.gfGroup != null)
    {
        // Находим индекс GF в массиве отрисовки игры
        var gfIndex:Int = game.members.indexOf(game.gfGroup);

        if (gfIndex >= 0)
        {
            // Вставляем лимузин на ОДИН слой выше, чем GF.
            // Благодаря этому лимузин перекроет GF, но BF и Dad останутся на своих местах.
            game.insert(gfIndex + 1, limo);
        }
        else
        {
            addHxObject(limo);
        }
    }
    else
    {
        addHxObject(limo);
    }
}

// Метод инициализации события "Kill Henchmen"
function onEventPushed(event:String, value1:String, value2:String, strumTime:Float)
{
    if (event == 'Kill Henchmen' && !ClientPrefs.data.lowQuality && !eventInitialized)
    {
        lightPole = new FlxSprite(-500, 220, Paths.image('stages/week4/gore/metalPole'));
        lightPole.scrollFactor.set(0.4, 0.4);
        addHxObject(lightPole);
        lightPole.visible = false;

        henchmanCorpse1 = new FlxSprite(-500, lightPole.y - 130);
        henchmanCorpse1.frames = Paths.getSparrowAtlas('stages/week4/gore/noooooo');
        henchmanCorpse1.animation.addByPrefix('anim', 'Henchmen on rail', 24, true);
        henchmanCorpse1.scrollFactor.set(0.4, 0.4);
        addHxObject(henchmanCorpse1);
        henchmanCorpse1.visible = false;

        henchmanCorpse2 = new FlxSprite(-500, lightPole.y);
        henchmanCorpse2.frames = Paths.getSparrowAtlas('stages/week4/gore/noooooo');
        henchmanCorpse2.animation.addByPrefix('anim', 'henchmen death', 24, true);
        henchmanCorpse2.scrollFactor.set(0.4, 0.4);
        addHxObject(henchmanCorpse2);
        henchmanCorpse2.visible = false;

        light = new FlxSprite(lightPole.x - 180, lightPole.y - 80, Paths.image('stages/week4/gore/coldHeartKiller'));
        light.scrollFactor.set(0.4, 0.4);
        addHxObject(light);
        light.visible = false;

        Paths.sound('stages/week4/dancerdeath');
        eventInitialized = true;
    }
}

function onUpdatePost(elapsed:Float)
{
    if (eventInitialized)
    {
        updateKillingState(elapsed);
        updateHenchmenParticles();
    }
}

function onBeatHit()
{
    // Танцы Танцоров (Henchmen) на каждый бит
    if (!ClientPrefs.data.lowQuality && henchmen.length > 0)
    {
        henchmenDanced = !henchmenDanced;
        for (henchman in henchmen)
        {
            if (henchmenDanced)
                henchman.animation.play('danceLeft', true);
            else
                henchman.animation.play('danceRight', true);
        }
    }

    // Рандомный шанс проезда машины (10%)
    if (FlxG.random.bool(10) && carCanDrive)
    {
        carDrive();
    }
}

function resetCar()
{
    var carPosY:Int = FlxG.random.int(140, 250);
    car.x = -12600;
    car.y = carPosY;
    car.velocity.x = 0;
    carCanDrive = true;
}

function carDrive()
{
    carCanDrive = false;
    var soundNum:Int = FlxG.random.int(0, 1);
    var carVelocity:Int = FlxG.random.int(30600, 39600);

    FlxG.sound.play(Paths.sound('stages/week4/carPass' + soundNum), 0.7);
    car.velocity.x = carVelocity;

    new FlxTimer().start(2, function(tmr:FlxTimer) {
        resetCar();
    });
}

function eventEarlyTrigger(eventName:String, value1:String, value2:String, strumTime:Float):Dynamic
{
    if (eventName == 'Kill Henchmen') {
        return 280; // Задержка для синхронизации со звуком
    }
    return 0;
}

function onEvent(eventName:String, value1:String, value2:String, strumTime:Float)
{
    if (eventName == 'Kill Henchmen')
    {
        killHenchmen();
    }
}

function killHenchmen()
{
    if (!ClientPrefs.data.lowQuality)
    {
        if (curKillState == 0)
        {
            lightPole.x = -400;
            lightPole.visible = true;
            light.visible = true;
            henchmanCorpse1.visible = false;
            henchmanCorpse2.visible = false;
            curKillState = 1;

            // Если у вас есть функции достижений:
            // game.addAchievementScore('roadkill_enthusiast');
        }
    }
}

function updateKillingState(elapsed:Float)
{
    if (curKillState == 1) // Столб сбивает танцоров
    {
        lightPole.x += 5000 * elapsed;
        light.x = lightPole.x - 180;
        henchmanCorpse1.x = light.x - 50;
        henchmanCorpse2.x = light.x + 35;

        for (i in 0...henchmen.length)
        {
            var henchmanNum = i + 1;
            var henchman = henchmen[i];

            if (henchman.x < FlxG.width * 1.5 && light.x > -200 + 300 * henchmanNum)
            {
                if (henchmanNum == 1)
                {
                    FlxG.sound.play(Paths.sound('stages/week4/dancerdeath'), 0.5);
                }

                if (henchmanNum % 2 == 1)
                {
                    var animString = (henchmanNum != 3) ? ' ' : ' 2 ';

                    // Части тела танцоров
                    var limbsData = [
                        {offsetX: 200, offsetY: 0, limbPart: 'leg'},
                        {offsetX: 160, offsetY: 200, limbPart: 'arm'},
                        {offsetX: 0, offsetY: 50, limbPart: 'head'}
                    ];

                    for (limb in limbsData)
                    {
                        var limbSprite = new FlxSprite(henchman.x + limb.offsetX, henchman.y + limb.offsetY);
                        limbSprite.frames = Paths.getSparrowAtlas('stages/week4/gore/noooooo');
                        limbSprite.animation.addByPrefix('anim', 'hench ' + limb.limbPart + ' spin' + animString + 'PINK', 24, false);
                        limbSprite.animation.play('anim');
                        limbSprite.scrollFactor.set(0.4, 0.4);
                        addHxObject(limbSprite);
                        henchmenParticles.push(limbSprite);
                    }

                    // Кровь
                    var bloodSprite = new FlxSprite(henchman.x - 110, henchman.y + 20);
                    bloodSprite.frames = Paths.getSparrowAtlas('stages/week4/gore/stupidBlood');
                    bloodSprite.animation.addByPrefix('anim', 'blood', 24, false);
                    bloodSprite.animation.play('anim');
                    bloodSprite.scrollFactor.set(0.4, 0.4);
                    addHxObject(bloodSprite);
                    henchmenParticles.push(bloodSprite);
                }
                else if (henchmanNum == 2)
                {
                    henchmanCorpse1.visible = true;
                }
                else if (henchmanNum == 4)
                {
                    henchmanCorpse2.visible = true;
                }

                henchman.x += FlxG.width * 2;
            }
        }

        if (lightPole.x > FlxG.width * 2)
        {
            lightPole.x = -500; lightPole.visible = false;
            light.x = -500; light.visible = false;
            henchmanCorpse1.x = -500; henchmanCorpse1.visible = false;
            henchmanCorpse2.x = -500; henchmanCorpse2.visible = false;

            limoSpeed = 800;
            curKillState = 2;
        }
    }
    else if (curKillState == 2) // Лимузин уезжает назад за экран
    {
        limoSpeed -= 4000 * elapsed;
        limoBG.x -= limoSpeed * elapsed;
        if (limoBG.x > FlxG.width * 1.5)
        {
            limoSpeed = 3000;
            curKillState = 3;
        }
    }
    else if (curKillState == 3) // Лимузин возвращается с новыми танцорами
    {
        limoSpeed -= 2000 * elapsed;
        if (limoSpeed < 1000) limoSpeed = 1000;

        limoBG.x -= limoSpeed * elapsed;
        if (limoBG.x < -275)
        {
            curKillState = 4;
            limoSpeed = 800;
        }

        for (i in 0...henchmen.length)
        {
            henchmen[i].x = limoBG.x + 300 * (i + 1);
        }
    }
    else if (curKillState == 4) // Плавное возвращение в исходную позицию
    {
        limoBG.x = FlxMath.lerp(-200, limoBG.x, Math.exp(-elapsed * 9));

        if (Math.round(limoBG.x) == -200)
        {
            limoBG.x = -200;
            curKillState = 0;
            henchmenParticles = [];
        }

        for (i in 0...henchmen.length)
        {
            henchmen[i].x = limoBG.x + 300 * (i + 1);
        }
    }
}

function updateHenchmenParticles()
{
    if (!ClientPrefs.data.lowQuality)
    {
        var i:Int = henchmenParticles.length - 1;
        while (i >= 0)
        {
            var particle = henchmenParticles[i];
            if (particle != null && particle.animation.curAnim != null)
            {
                if (particle.animation.curAnim.finished)
                {
                    particle.kill();
                    remove(particle); // или removeHxObject(particle); в зависимости от движка
                    henchmenParticles.splice(i, 1);
                }
            }
            i--;
        }
    }
}