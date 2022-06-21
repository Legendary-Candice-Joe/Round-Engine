package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Settings {
	public static var Config:Array<String> = [
		"Start Fullscreen", 
		"Useful Info",
		"4K Controls",
		"6K Controls",
		"9K Controls",
		"Antialiasing",
		"Input Strictness",
		"Audio Delay",
		"Coff",
		"Downscroll",
		"Show HUD",
		"BotPlay",
		"Ghost Tapping",
		"Better Accuracy",
		"Camera Zooms",
		"Show FPS",
		"FPS Cap",
		"Light Opponent Strums",
		"Start Volume",
		"Input Delay",
		"Visual Delay",
		"Miss Health Loss"
	];
	
	private static var Index:Array<Dynamic> = [
		false, //fullscreen
		true,  //useful info
		[A, S, LEFT, RIGHT], //Controls
		[A, S, D, LEFT, DOWN, RIGHT], // 6k Controls
		[A, S, D, F, SPACE, J, K, L, SEMICOLON], // 9k iuhnseiuf
		true, //Antialiasing
		95, //How far a note can be pressed
		0, //Audio Delay. (In Milliseconds)
		[0, 0], //Combo offset
		true, //Downscroll
		true, //Show the hud
		false, // BotPlay
		true, // Ghost tapping
		true, // Middle scroll, Better Accuracy
		true, //Cam Zooms
		true, //Shows Fps
		500, //fps cap
		true, //well.... leave this true
		100,
		0, //Judgement delay (in ms)
		0, //Visual delay (in ms)
		0.04
	];
	
	public static var BaseIndex:Array<Dynamic> = [
		false, //fullscreen
		true,  //useful info
		[A, S, LEFT, RIGHT], //Controls
		[A, S, D, LEFT, DOWN, RIGHT], // 6k Controls
		[A, S, D, F, SPACE, J, K, L, SEMICOLON], // 9k iuhnseiuf
		true, //Antialiasing
		95, //How far a note can be pressed
		0, //Audio Delay. (In Milliseconds)
		[0, 0], //Combo offset
		true, //Downscroll
		true, //Show the hud
		false, // BotPlay
		true, // Ghost tapping
		true, // Middle scroll, Better Accuracy
		true, //Cam Zooms
		true, //Shows Fps
		500, //fps cap
		true, //well.... leave this true
		100,
		0, //Judgement delay (in ms)
		0, //Visual delay (in ms)
		0.04
	];
	
	public static function Init(Reset:Bool = false)
	{		
		if (FlxG.save.data.Config == null || Reset){ // Reset Settings
			FlxG.save.data.Config = Config;
			FlxG.save.data.Index = BaseIndex;
			
			trace(BaseIndex);
		}
		
		for (i in 0...Config.length){
			Index[i] = FlxG.save.data.Index[i];
			trace(Index[i]);
		}
	}
	
	public static function Get(TheThing:String):Dynamic
	{
		var ReturnThis:Dynamic = null;
		
		for (i in 0...Config.length){
			if (TheThing == Config[i]){
				ReturnThis = Index[i];
			}
		}
		
		return ReturnThis;
	}
	
	public static function Change(TheThing:String, WithWhat:Dynamic)
	{
		var fakeSettings:Array<Dynamic> = Index;
		
		for (i in 0...Config.length){
			if (TheThing == Config[i]){
				fakeSettings[i] = WithWhat;
			}
		}
		
		FlxG.save.data.Index = fakeSettings;
	}
}