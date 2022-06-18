package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class Offset extends MusicBeatState
{
	public var Mode:String = "Combo";
	public var Offsets:Alphabet;
	public var Display:Alphabet;
	public var menuBG:FlxSprite;
	
	public var changedModes:Bool = true;
	
	public var Position:Float = 0;
	
	private var BeatNowHit:Bool = false;

	var Infotxt:FlxText;
	
	override function create() {
		hitSound = Paths.sound('HitSound');
		fakeDistance = Settings.Get("Input Strictness");
		
		FlxG.sound.playMusic(Paths.music('Offset'));
		FlxG.sound.music.play();

		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1));
		menuBG.color = 0xFFea71fd;
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = Settings.Get("Antialiasing");
		add(menuBG);

		Display = new Alphabet(15, 35, Mode, true, false);
		add(Display);
		
		Offsets = new Alphabet(15, 105, "", true, false);
		add(Offsets);

		Infotxt = new FlxText(0, FlxG.height - 20, 0, "", 20);
		Infotxt.setFormat("assets/fonts/vcr.ttf", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(Infotxt);
		
		DSnote = new FlxSprite();
		DPnote = new FlxSprite();

		super.create();
	}
	
	override function update(elapsed){
		Position = Math.floor((FlxG.sound.music.time - Settings.Get("Audio Delay")) / (( (60 / 145) * 1000) / 4 ) );
		
		if (Position % 8 == 0)
		{
			if(!BeatNowHit) hitBeat();
		} else {
			BeatNowHit = false;
		}
		
		if (controls.BACK){
			FlxG.switchState(new OptionsMenu());
			FlxG.sound.playMusic(Paths.music("freakyMenu"));
		}
		
		if (Mode == "Combo"){
			if(changedModes){
				Offsets.changeText(Settings.Get("Coff")[0] + ", " + Settings.Get("Coff")[1]);

				Infotxt.text = "Change where the rating shows (E.G: Sick! or Bad, etc)";
			}
			
			var FakeCoff = Settings.Get("Coff");
			
			if (FlxG.keys.pressed.LEFT){
				FakeCoff[0] -= 1;
			}
			if (FlxG.keys.pressed.RIGHT){
				FakeCoff[0] += 1;
			}
			if (FlxG.keys.pressed.DOWN){
				FakeCoff[1] -= 1;
			}
			if (FlxG.keys.pressed.UP){
				FakeCoff[1] += 1;
			}
			
			Settings.Change("Coff", FakeCoff);
			
			//trace(FakeCoff);
			
			if (controls.ACCEPT && changedModes){
				changedModes = false;
				Mode = "Audio Delay";
				callTween(0.2);
				trace("bruj");
			}
		} else if (Mode == "Audio Delay"){
			if(changedModes){
				Offsets.changeText(Settings.Get("Audio Delay") + "ms");

				Infotxt.text = "Change the audio delay in MS so the music aligns with the gameplay. (DONT USE -MS)";
			}
			
			if (controls.ACCEPT && changedModes){
				changedModes = false;
				Mode = "Input Delay";
				callTween(0.5);
			}
			
			if (FlxG.keys.pressed.LEFT){
				Settings.Change("Audio Delay", Settings.Get("Audio Delay") - 1);
			}
			if (FlxG.keys.pressed.RIGHT){
				Settings.Change("Audio Delay", Settings.Get("Audio Delay") + 1);
			}
		} else if (Mode == "Input Delay"){
			if(changedModes){
				Offsets.changeText(Settings.Get("Input Delay") + "ms");

				DistanceMode(false);
				Infotxt.text = "Sets the input offset, useful if your keyboard has a lot of delay.";
			}

			DSnote.x = FlxG.width / 2;
			DSnote.y = FlxG.height / 2;
			DPnote.x = DSnote.x;
			DPnote.y = DSnote.y;
			
			DSnote.y = DPnote.y + Settings.Get("Input Delay");

			if (controls.ACCEPT && changedModes){
				changedModes = false;
				DistanceMode(true);
				Mode = "Visual Delay";
				callTween(0.6);
			}
			
			if (FlxG.keys.pressed.LEFT){
				Settings.Change("Input Delay", Settings.Get("Input Delay") - 1);
			}
			if (FlxG.keys.pressed.RIGHT){
				Settings.Change("Input Delay", Settings.Get("Input Delay") + 1);
			}
		} else if (Mode == "Visual Delay"){
			if(changedModes){
				Offsets.changeText(Settings.Get("Visual Delay") + "ms");

				DistanceMode(false);
				Infotxt.text = "Sets the visual offset, useful if your screen has a lot of delay.";
			}
			
			DSnote.x = FlxG.width / 2;
			DSnote.y = FlxG.height / 2;
			DPnote.x = DSnote.x;
			DPnote.y = DSnote.y;
			
			DPnote.y = DSnote.y + Settings.Get("Visual Delay");

			if (controls.ACCEPT && changedModes){
				changedModes = false;
				DistanceMode(true);
				Mode = "Hit Distance";
				callTween(0.7);
			}
			
			if (FlxG.keys.pressed.LEFT){
				Settings.Change("Visual Delay", Settings.Get("Visual Delay") - 1);
			}
			if (FlxG.keys.pressed.RIGHT){
				Settings.Change("Visual Delay", Settings.Get("Visual Delay") + 1);
			}
		} else if (Mode == "Hit Distance"){
			if(changedModes){
				Offsets.changeText(Settings.Get("Input Strictness") + " Percent");
				
				DistanceMode(false);
				Infotxt.text = "Changes how far you can hit a note.";
			}
			
			DPnote.y = DSnote.y - Settings.Get("Input Strictness");
			
			if (controls.ACCEPT && changedModes){
				changedModes = false;
				Mode = "Combo";
				DistanceMode(true);
				callTween(1);
			}
			
			if (FlxG.keys.pressed.DOWN && Settings.Get("Input Strictness") > 10){
				fakeDistance -= 1;
			}
			if (FlxG.keys.pressed.UP){
				fakeDistance += 1;
			}
			
			Settings.Change("Input Strictness", fakeDistance);
		}
	}
	
	public var FDBCT:Int = 0;
	
	public var DSnote:FlxSprite;
	public var DPnote:FlxSprite;
	
	private var fakeMode2:String = "Combo";
	
	public var fakeDistance:Int;
	
	function DistanceMode(Leaving:Bool)
	{
		if (!Leaving && fakeMode2 != Mode){
			fakeMode2 = Mode;
			
			trace("scnd trigger");
			
			DSnote.frames = Paths.getSparrowAtlas('NOTE_assets');
			DSnote.animation.addByPrefix('static', 'arrowSPACE', 24);
			DSnote.animation.play('static', true);
			DSnote.x = FlxG.width / 2;
			DSnote.y = FlxG.height / 2;
			DSnote.antialiasing = Settings.Get("Antialiasing");
			
			DPnote.frames = Paths.getSparrowAtlas('NOTE_assets');
			DPnote.animation.addByPrefix('middle', 'white0', 24);
			DPnote.animation.play('middle', true);
			DPnote.x = DSnote.x;
			DPnote.y = DSnote.y - Settings.Get("Input Strictness");
			DPnote.antialiasing = Settings.Get("Antialiasing");
			
			add(DSnote);
			add(DPnote);
		} else if(Leaving && fakeMode2 != Mode) {
			fakeMode2 = Mode;
			
			trace("tjd trigger");
			
			remove(DSnote);
			remove(DPnote);
		}
	}
	
	private var fakeMode:String = "Combo";
	
	private function callTween(Alpha:Float = 0)
	{
		if (fakeMode != Mode){
			fakeMode = Mode;
			
			FlxTween.tween(Display, {alpha: 0}, 0.3);
			FlxTween.tween(Offsets, {alpha: 0}, 0.3);
			FlxTween.tween(Infotxt, {alpha: 0}, 0.3);
			
			FlxTween.tween(menuBG, {alpha: Alpha}, 2, {onComplete:function(twn:FlxTween){
				changedModes = true;
				
				Display.changeText(Mode);
				
				FlxTween.tween(Display, {alpha: 1}, 0.3);
				FlxTween.tween(Offsets, {alpha: 1}, 0.3);
				FlxTween.tween(Infotxt, {alpha: 1}, 0.3);
			}});
		}
	}
	
	private var prevCon:String = "";
	
	public var hitSound:String = "";
	
	public function hitBeat()
	{
		if (Mode == "Audio Delay" && changedModes){
			//FlxG.sound.play(hitSound, 1.2);
		}
		
		BeatNowHit = true;
		
		trace("it work?");
		
		if (Settings.Get("Coff") == null) Settings.Change("Coff", [0, 0]);
		if (Settings.Get("Input Strictness") == null) Settings.Change("Input Strictness", 95);
		if (Settings.Get("Audio Delay") == null) Settings.Change("Audio Delay", 0);
		
		var rating = new FlxSprite();
		rating.loadGraphic(Paths.image('sick'));
		rating.screenCenter();
		trace(Settings.Get("Coff"));
		rating.x = (FlxG.width * 0.55) - 40 + Settings.Get("Coff")[0];
		rating.y -= 60 + Settings.Get("Coff")[1];
		trace("bedep");
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.antialiasing = Settings.Get("Antialiasing");
		
		if (Mode == "Hit Distance") rating.alpha = 0;
		
		add(rating);
		
		FlxTween.tween(rating, {alpha: 0, y: rating.y - 14}, 0.2, {
			startDelay: ((60 / 145) * 1000) * 0.0005
		});
	}
}