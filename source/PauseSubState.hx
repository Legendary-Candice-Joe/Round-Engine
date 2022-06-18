package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Toggle BotPlay', 'Toggle Ghost Tapping', 'Toggle Better Accuracy', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var BPtxt:FlxText;
	var GTtxt:FlxText;
	var BAtxt:FlxText;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded('assets/music/breakfast' + TitleState.soundExt, true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);
		
		BPtxt = new FlxText(FlxG.width - 140, FlxG.height - 60, 0, "BOTPLAY", 30);
		BPtxt.setFormat("assets/fonts/vcr.ttf", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		BPtxt.alpha = Settings.Get('BotPlay') != true ? 0.3 : 1;
		add(BPtxt);
		
		GTtxt = new FlxText(FlxG.width - 300, FlxG.height - 100, 0, "NO GHOST TAPPING", 30);
		GTtxt.setFormat("assets/fonts/vcr.ttf", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		GTtxt.alpha = Settings.Get('Ghost Tapping') != true ? 1 : 0.3;
		add(GTtxt);
		
		BAtxt = new FlxText(FlxG.width - 265, FlxG.height - 140, 0, "WORSE ACCURACY", 30);
		BAtxt.setFormat("assets/fonts/vcr.ttf", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		BAtxt.alpha = Settings.Get('Better Accuracy') != true ? 1 : 0.3;
		add(BAtxt);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

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

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					FlxG.resetState();
				case "Toggle BotPlay":
					Settings.Change('BotPlay', !Settings.Get('BotPlay'));
					PlayState.HSEnabled = Settings.Get('BotPlay');
					BPtxt.alpha = PlayState.HSEnabled != true ? 0.3 : 1; // absolutely love this syntax
				case "Toggle Ghost Tapping":
					Settings.Change('Ghost Tapping', !Settings.Get('Ghost Tapping'));
					GTtxt.alpha = Settings.Get('Ghost Tapping') == true ? 0.3 : 1;
				case "Toggle Better Accuracy":
					Settings.Change('Better Accuracy', !Settings.Get('Better Accuracy'));
					PlayState.MiddleScroll = Settings.Get('Better Accuracy');
					BAtxt.alpha = PlayState.MiddleScroll != true ? 1 : 0.3;
				case "Exit to menu":
					FlxG.switchState(new MainMenuState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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
