package;

import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	public static var TheGame:FlxGame;
	
	public static var FrameShow:FPS;
	public static var lmao:Subscribe;
	public static var wm:Subscribe;

	public static var GW:Int = 1280;
	public static var GH:Int = 720;
	
	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		FrameShow = new FPS(10, 3, 0xFFFFFF);
		lmao = new Subscribe(10, 20, 0xFFFFFF);
		wm = new Subscribe(stageWidth - 210, stageHeight - 20, 0xFFFFFF, "Isaac Mod Studios® Technologys", true);
		
		var ratioX:Float = stageWidth / 1280;
		var ratioY:Float = stageHeight / 720;
		var zoom = Math.min(ratioX, ratioY);
		GW = Math.ceil(stageWidth / zoom);
		GH = Math.ceil(stageHeight / zoom);

		//FlxG.save.bind('Round Engine', 'Isaac Mod Studios');
		
		#if NOTWEB
		var lFPS:Int = 500;
		#else
		var lFPS:Int = 60;
		#end
		
		TheGame = new FlxGame(1280, 720, TitleState, zoom, lFPS, lFPS, true, false);
		
		addChild(TheGame);
		addChild(FrameShow);
		addChild(lmao);
		addChild(wm);
	}
}
