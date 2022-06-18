package;

import flixel.math.FlxMath;

class TimeFormatter {
	public static function FormatThis(milliseconds:Float)
	{
		var seconds:Int = Std.int(milliseconds / 1000);
		var minutes:Int = Math.floor((seconds - (Math.floor(seconds / 3600) * 3600)) / 60);
		var secondsAcually:Int = Std.int(seconds - (Math.floor(seconds / 3600) * 3600) - (minutes * 60));
		
		return minutes + ':' + (secondsAcually < 10 ? '0' + secondsAcually : '' + secondsAcually);
	}
}