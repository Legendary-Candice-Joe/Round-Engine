package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import haxe.io.ArrayBufferView;
import polymod.format.ParseRules.TargetSignatureElement;
import flixel.input.keyboard.FlxKey;
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	
	public var isEndHold:Bool = false;
	public static var vuk:Array<Float> = [0.7, 0.6, 0.5, 0.55];
	public static var spaces:Array<Int> = [110, 85, 65, 76];
	public static var alsoVuk:Array<Int> = [4, 6, 9, 8];
	
	public static var shartColour:Array<Dynamic> = [
		['purple', 'blue', 'green', 'red'],
		['purple', 'blue', 'red', 'yellow', 'black', 'dark'],
		['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'],
		['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'black', 'dark']
	];

	public static var inEditor:Bool = false;

	public static var BoundKeys:Array<Dynamic> = [ //worth **note**-ing that these are technically not even defaults! they immediety get overwritten in playstate lol.
		[D, F, J, K],
		[S, D, F, J, K, L],
		[A, S, D, F, SPACE, H, J, K, L],
		[A, S, D, F, H, J, K, L],
	];
	
	public var CurBoundKey:FlxKey = D;
	
	public function loadAnims()
	{
		frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
		
		for (i in 0...psC) 
		{
			animation.addByPrefix(shartColour[psK][i] + 'Scroll', shartColour[psK][i] + '0');
			animation.addByPrefix(shartColour[psK][i] + 'holdend', shartColour[psK][i] + ' hold end0');
			animation.addByPrefix(shartColour[psK][i] + 'holdendflip', shartColour[psK][i] + ' hold end down'); // <-- not used.
			animation.addByPrefix(shartColour[psK][i] + 'hold', shartColour[psK][i] + ' hold piece');
		}
		
		setGraphicSize(Std.int(width * vuk[psK]));
		updateHitbox();
	}

	public static var psK:Int = 0;
	public static var psC:Int = 4;
	
	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?personalMania:Int = 0)
	{
		super();

		psK = PlayState.Deez;
		psC = PlayState.keyC;
		if(inEditor){
			psK = ChartingState.fakeK;
			psC = ChartingState.fakeC;
		} else if(personalMania != 0){
			psK = personalMania - 1;
			psC = alsoVuk[psK];
		}

		CurBoundKey = BoundKeys[psK][noteData % psC];
		
		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 22;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school':
				loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic('assets/images/weeb/pixelUI/arrowEnds.png', true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'schoolEvil': // COPY PASTED CUZ I AM LAZY
				loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic('assets/images/weeb/pixelUI/arrowEnds.png', true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				loadAnims();
				
				antialiasing = Settings.Get("Antialiasing");
		}

		x += spaces[psK] * noteData;
		animation.play(shartColour[psK][noteData] + 'Scroll');

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;
			
			animation.play(shartColour[psK][noteData] + 'holdend');
			if (PlayState.Downscroll)
				flipY = true;
			
			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;
				
			isEndHold = true;

			if (prevNote.isSustainNote)
			{
				prevNote.isEndHold = false;
				
				prevNote.animation.play(shartColour[psK][noteData] + 'hold');
				
				prevNote.offset.y = -19;
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed * (0.7 / vuk[psK]);
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			if (strumTime <= Conductor.songPosition && PlayState.HSEnabled)
				wasGoodHit = true;
			
			// The * 0.5 us so that its easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
			{
				canBeHit = true;
			}
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
			{
				wasGoodHit = true;
			}
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
