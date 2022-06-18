package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<String> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;

	public var CurIcon:HealthIcon;
	
	private var curPlaying:Bool = false;

	override function create()
	{
		Main.wm.poggars = "";
		
		songs = CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt');

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			}
		 */

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		/*if (StoryMenuState.weekUnlocked[2] || isDebug)
		{
			songs.push('Spookeez');
			songs.push('South');
		}

		if (StoryMenuState.weekUnlocked[3] || isDebug)
		{
			songs.push('Pico');
			songs.push('Philly');
			songs.push('Blammed');
		}

		if (StoryMenuState.weekUnlocked[4] || isDebug)
		{
			songs.push('Satin-Panties');
			songs.push('High');
			songs.push('Milf');
		}

		if (StoryMenuState.weekUnlocked[5] || isDebug)
		{
			songs.push('Cocoa');
			songs.push('Eggnog');
			songs.push('Winter-Horrorland');
		}

		if (StoryMenuState.weekUnlocked[6] || isDebug)
		{
			songs.push('Senpai');
			songs.push('Roses');
			songs.push('Thorns');
			// songs.push('Winter-Horrorland');
		}*/

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBGBlue.png');
		add(bg);
		
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].split('^')[0], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		
		CurIcon = new HealthIcon("dad");
		CurIcon.x = FlxG.width - 300;
		CurIcon.y = FlxG.height / 2;
		CurIcon.scale.x = 2;
		CurIcon.scale.y = 2;
		add(CurIcon);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		var BottomBarBG:FlxSprite = new FlxSprite(0, FlxG.height - 30).makeGraphic(Std.int(FlxG.width), 30, 0xFF000000);
		BottomBarBG.alpha = 0.6;
		add(BottomBarBG);
		
		var BottomText = new FlxText(0, FlxG.height - 30, 0, "Press SPACE to listen to the song | Press L to listen to the instrumental", 24);
		add(BottomText);
		
		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic('assets/music/title' + TitleState.soundExt, 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}
	
	var Vocals:FlxSound;
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (Vocals != null){
			if (Math.abs(FlxG.sound.music.time - Vocals.time) >= 0.03){
				Vocals.time = FlxG.sound.music.time;
			}
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.9));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		
		if (FlxG.keys.justPressed.SPACE){
			if(Vocals != null){
				Vocals.stop();
				Vocals.destroy();
			}
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].split('^')[0]), 0.7);
			Vocals = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].split('^')[0]));
			FlxG.sound.list.add(Vocals);
			Vocals.play();
		} else if (FlxG.keys.justPressed.L){
			if(Vocals != null){
				Vocals.stop();
				Vocals.destroy();
			}
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].split('^')[0]), 1.2);
			trace(Paths.inst(songs[curSelected].split('^')[0]));
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			if(Vocals != null){
				Vocals.stop();
				Vocals.destroy();
			}
			
			FlxG.switchState(new MainMenuState());
		}

		if (accepted && !FlxG.keys.justPressed.SPACE)
		{
			if (Vocals != null){
				FlxG.sound.list.remove(Vocals);
				Vocals.stop();
				Vocals.destroy();
			}
			
			var poop:String = Highscore.formatSong(songs[curSelected].split('^')[0].toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].split('^')[0].toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			FlxG.switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].split('^')[0], curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{
		//#if !switch
		//NGio.logEvent('Fresh');
		//#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);
		
		curSelected += change;
		
		trace(songs[curSelected].split('^')[1]);
		FlxTween.tween(CurIcon, {alpha: 0}, 0.1, {onComplete:function(twn:FlxTween){
			CurIcon.animation.play(songs[curSelected].split('^')[1]);
			FlxTween.tween(CurIcon, {alpha: 1}, 0.05);
		}});

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].split('^')[0], curDifficulty);
		// lerpScore = 0;
		#end

		//FlxG.sound.playMusic('assets/music/' + songs[curSelected].split('^')[0] + "_Inst" + TitleState.soundExt, 0);

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
