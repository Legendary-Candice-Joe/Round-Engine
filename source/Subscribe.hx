package;

import flixel.FlxG;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Subscribe extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var poggars:String = "";
	public var pBL:Bool = false;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000, txt:String = "https://BeatingChildren.cf", bottomLeft:Bool = false)
	{
		super();

		poggars = txt;
		
		pBL = bottomLeft;
		
		this.x = x;
		this.y = y;
		this.width = 500;
		this.maxChars = 60;

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 13, color, null, null, null, txt);
	
		text = poggars;
	}
	
	private override function __enterFrame(deltaTime:Float):Void
	{
		if(Settings.Get("Useful Info")){
			if (pBL){
				this.x = Lib.current.stage.stageWidth - (this.length * 7.6);
				this.y = Lib.current.stage.stageHeight - 20;
			}
		} else {
			poggars = "";
		}
		
		text = poggars;
	}
}
