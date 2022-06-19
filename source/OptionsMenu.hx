package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	var controlsStrings:Array<String> = ['Basic', 'Controls', 'Offset', 'Gameplay', 'Other', 'Presets'];
	var CurSel:Int = 1;
	
	var SubMenu:String = "Main";
	
	public var ListString:Array<AlphabetGlowing> = [];
	var Infotxt:FlxText;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
		
		Infotxt = new FlxText(0, FlxG.height - 20, 0, "", 20);
		Infotxt.setFormat("assets/fonts/vcr.ttf", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(Infotxt);

		for (i in 0...controlsStrings.length)
		{
			var TempAl:AlphabetGlowing = new AlphabetGlowing(4, i * 110, controlsStrings[i], true, false);
			TempAl.alpha = 0.5;
			add(TempAl);
			ListString.push(TempAl);
		}
		
		changeSel(true);

		super.create();
	}
	
	function changeSel(Up:Bool = false)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
		
		if(SubMenu == "Main"){
			if (Up){
				if (CurSel - 1 < 0) 
					{CurSel = controlsStrings.length - 1;}
				else 
					{CurSel -= 1;}
			} else {
				CurSel = (CurSel + 1) % controlsStrings.length;
			}
			
			for (i in 0...ListString.length){
				if (CurSel == i) {
					ListString[i].alpha = 1;
					FlxTween.tween(ListString[i], {x: 4}, 0.07, {ease: FlxEase.quadInOut});
				}
				else {
					ListString[i].alpha = 0.5;
					FlxTween.tween(ListString[i], {x: 4 - (Math.abs(CurSel - i) * 12)}, 0.07, {ease: FlxEase.quadInOut});
				}
			}
			
			trace(CurSel);
		} else {
			trace(Setings);
			
			if (Up){
				if (CurSel - 1 < 0) 
					{CurSel = Setings.length - 1;}
				else 
					{CurSel -= 1;}
			} else {
				CurSel = (CurSel + 1) % Setings.length;
			}
			
			trace("craish");
			
			for (i in 0...Setings.length){
				if (CurSel == i) {
					SetingText[i].alpha = 1;
					FlxTween.tween(SetingText[i], {x: 120}, 0.07, {ease: FlxEase.quadInOut});
					
					if (BS[i]){
						Boxes[i].alpha = 1;
						FlxTween.tween(Boxes[i], {x: 12}, 0.07, {ease: FlxEase.quadInOut});
					}
				}
				else {
					SetingText[i].alpha = 0.5;
					FlxTween.tween(SetingText[i], {x: 120 - (Math.abs(CurSel - i) * 12)}, 0.07, {ease: FlxEase.quadInOut});
					
					if (BS[i]){
						Boxes[i].alpha = 0.5;
						FlxTween.tween(Boxes[i], {x: 12 - (Math.abs(CurSel - i) * 12)}, 0.07, {ease: FlxEase.quadInOut});
					}
				}
			}
			
			trace("gash");
			
			var OffscreenVal:Float = 0;
			
			do {
				OffscreenVal -= 78;
			} while (SetingText[CurSel].y >= 634 - OffscreenVal - 78);
			OffscreenVal += 78;
			do {
				OffscreenVal += 78;
			} while (SetingText[CurSel].y < 0 - OffscreenVal + 78);
			OffscreenVal -= 78;
			
			trace(SetingText[CurSel].y + " bruh " + FlxG.height);
			
			for (i in 0...SetingText.length){
				FlxTween.tween(SetingText[i], {y: SetingText[i].y + OffscreenVal}, 0.03, {ease: FlxEase.quadInOut});
			}
			
			Infotxt.text = Desc[CurSel];
			
			trace(CurSel);
		}
	}
	
	public var Binding:Bool = false;

	override function update(elapsed:Float)
	{
		if (Binding){
			var Finally:Int = FlxG.keys.firstJustPressed();
			if (Finally > -1) {
				switch (Setings[CurSel].substring(0, 1))
				{
					case "4":
						var FakeControls = Settings.Get("4K Controls");
						trace(FakeControls);
						
						FakeControls[CurSel] = Finally;
						Settings.Change("4K Controls", FakeControls);
					case "6":
						var FakeControls = Settings.Get("6K Controls");
						
						FakeControls[CurSel - 5] = Finally;
						trace(FakeControls);
						Settings.Change("6K Controls", FakeControls);
					case "9":
						var FakeControls = Settings.Get("9K Controls");
						
						FakeControls[CurSel - 12] = Finally;
						trace(FakeControls);
						Settings.Change("9K Controls", FakeControls);
				}
				
				clearThings();
				
				ControlsM();
				Binding = false;
				changeSel();
			}
		} else {
			if (FlxG.keys.justPressed.DOWN){
				changeSel();
			}
			if (FlxG.keys.justPressed.UP){
				changeSel(true);
			}
			
			if (FlxG.keys.justPressed.ENTER){
				switch (SubMenu) 
				{
					case "Main":
						for (i in 0...controlsStrings.length)
						{
							ListString[i].alpha = 0;
						}
						
						SubMenu = controlsStrings[CurSel];
						
						trace("chnged to " + SubMenu);

						FlxG.save.data.visitOptions = true;
						
						switch (CurSel) 
						{
							case 0:
								BasicM();
							case 1:
								ControlsM();
							case 2:
								OffsetM();
								FlxG.switchState(new Offset());
							case 3:
								GameplayM();
							case 4:
								OtherM();
							case 5:
								PresetsM();
						}
						
						CurSel = 1;
						changeSel(true);
					case "Basic":
						if(BS[CurSel]){
							Main.wm.poggars = "Isaac Mod Studios® Technologys";
							Main.lmao.poggars = "http://BeatingChildren.cf";
							Settings.Change(Setings[CurSel], !Settings.Get(Setings[CurSel]));
							Boxes[CurSel].animation.play(quickCheck(Setings[CurSel]));
						} else {
							var FakeVol = (Settings.Get("Start Volume") + 10) % 110;
							Settings.Change('Start Volume', FakeVol);
							SetingText[CurSel].changeText("Start Volume " + Settings.Get('Start Volume'));
						}
					case "Controls":
						if(Setings[CurSel] != ''){
							FlxTween.tween(SetingText[CurSel], {x: FlxG.width / 2}, 0.08, {ease: FlxEase.quadInOut});
							Binding = true;
						}
					case "Gameplay":
						Settings.Change(Setings[CurSel], !Settings.Get(Setings[CurSel]));
						Boxes[CurSel].animation.play(quickCheck(Setings[CurSel]));
					case "Other":
						if (BS[CurSel])
						{
							Settings.Change(Setings[CurSel], !Settings.Get(Setings[CurSel]));
							Boxes[CurSel].animation.play(quickCheck(Setings[CurSel]));
							Main.FrameShow.visible = Settings.Get("Show FPS");
						} else if (Setings[CurSel] == "FPS Cap"){
							var FakeFPSC = (Settings.Get("FPS Cap") - 40) % 460;
							Settings.Change('FPS Cap', 60 + FakeFPSC);
							FlxG.updateFramerate = Settings.Get('FPS Cap');
							FlxG.drawFramerate = Settings.Get('FPS Cap');
							SetingText[CurSel].changeText("FPS Cap " + Settings.Get('FPS Cap'));
						} else {
							Settings.BaseIndex = [
								false,
								true, 
								[A, S, LEFT, RIGHT],
								[A, S, D, LEFT, DOWN, RIGHT],
								[A, S, D, F, SPACE, J, K, L, SEMICOLON], 
								true,
								95,
								0,
								[0, 0], 
								true,
								true, 
								false,
								true,
								true,
								true,
								true,
								500,
								true, 
								100,
								0, 
								0 
							];
							
							Settings.Init(true);
							FlxG.switchState(new OptionsMenu());
						}
					case "Presets":
						switch(CurSel){
							case 0:
								Settings.BaseIndex = [
									false, //fullscreen
									true,  //useful info
									[D, F, J, K], //Controls
									[S, D, F, J, K, L], // 6k Controls
									[A, S, D, F, SPACE, H, J, K, L], // 9k iuhnseiuf
									true, //Antialiasing
									100, //How far a note can be pressed
									50, //Audio Delay. (In Milliseconds)
									[0, 0], //Combo offset
									false, //Downscroll
									true, //Show the hud
									false, // BotPlay
									true, // Ghost tapping
									true, // Middle scroll, Better Accuracy
									true, //Cam Zooms
									true, //Shows Fps
									300, //fps cap
									true, //well.... leave this true
									100,
									0, //Judgement delay (in ms)
									0 //Visual delay (in ms)
								];
							case 1:
								Settings.BaseIndex = [
									false, //fullscreen
									true,  //useful info
									[A, S, UP, FlxKey.RIGHT], //Controls
									[A, S, D, FlxKey.LEFT, DOWN, FlxKey.RIGHT], // 6k Controls
									[A, S, D, F, SPACE, H, J, K, L], // 9k iuhnseiuf
									true, //Antialiasing
									110, //How far a note can be pressed
									0, //Audio Delay. (In Milliseconds)
									[0, 0], //Combo offset
									false, //Downscroll
									true, //Show the hud
									false, // BotPlay
									false, // Ghost tapping
									true, // Middle scroll, Better Accuracy
									true, //Cam Zooms
									true, //Shows Fps
									120, //fps cap
									true, //well.... leave this true
									100,
									0, //Judgement delay (in ms)
									0 //Visual delay (in ms)
								];
							case 2:
								Settings.BaseIndex = [
									true, //fullscreen
									true,  //useful info
									[D, F, J, K], //Controls
									[S, D, F, J, K, L], // 6k Controls
									[A, S, D, F, SPACE, J, K, L, SEMICOLON], // 9k iuhnseiuf
									true, //Antialiasing
									95, //How far a note can be pressed
									50, //Audio Delay. (In Milliseconds)
									[-100, -100], //Combo offset
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
									3, //Judgement delay (in ms)
									3 //Visual delay (in ms)
								];
							case 3:
								Settings.BaseIndex = [
									true, //fullscreen
									false,  //useful info
									[A, S, UP, FlxKey.RIGHT], //Controls
									[A, S, D, FlxKey.LEFT, DOWN, FlxKey.RIGHT], // 6k Controls
									[A, S, D, F, SPACE, J, K, L, SEMICOLON], // 9k iuhnseiuf
									true, //Antialiasing
									105, //How far a note can be pressed
									50, //Audio Delay. (In Milliseconds)
									[0, 0], //Combo offset
									false, //Downscroll
									false, //Show the hud
									true, // BotPlay
									false, // Ghost tapping
									true, // Middle scroll, Better Accuracy
									false, //Cam Zooms
									false, //Shows Fps
									120, //fps cap
									true, //well.... leave this true
									100,
									0, //Judgement delay (in ms)
									0 //Visual delay (in ms)
								];
						}
						Settings.Init(true);
						Main.FrameShow.visible = Settings.Get("Show FPS");
						Main.wm.poggars = "Isaac Mod Studios® Technologys";
						Main.lmao.poggars = "http://BeatingChildren.cf";
						FlxG.switchState(new OptionsMenu());
				}
			}
			
			if (FlxG.keys.justPressed.ESCAPE){
				if(SubMenu == "Main"){
					FlxG.switchState(new MainMenuState());
				} else {
					SubMenu = "Main";
					for (i in 0...controlsStrings.length)
					{
						ListString[i].alpha = 0.5;
					}
					clearThings();
					
					//Main.wm.poggars = "Isaac Mod Studios® Technologys";
					Infotxt.text = "";
					
					CurSel = 1;
					changeSel(true);
				}
			}
		}
		
		super.update(elapsed);
	}
	
	private function clearThings()
	{
		for (i in 0...SetingText.length)
		{
			remove(SetingText[i]);
		}
		for (i in 0...Boxes.length)
		{
			remove(Boxes[i]);
		}
		
		SetingText = [];
		Setings = [];
		BS = [];
		Boxes = [];
		Desc = [];
	}
	
	public var SetingText:Array<Alphabet> = [];
	public var Setings:Array<String> = [];
	public var BS:Array<Bool> = []; //It actually stands for (B)oxes (S)ettings. woops
	public var Boxes:Array<FlxSprite> = [];
	public var Desc:Array<String> = [];
	
	function quickCheck(Input:String):String
	{
		if (Settings.Get(Input)){
			return "Yes";
		} else {
			return "No";
		}
	}
	
	function BasicM()
	{
		Setings = ['Useful Info', 'Start Fullscreen', 'Antialiasing', 'Start Volume'];
		Desc = [
		'When checked, display some useful info', 
		'Automatic fullscreen when the game starts', 
		'Makes the game look smoother. Turn this off for better performance',
		'Changes the default volume the game starts with'
		];
		BS = [true, true, true, false];
		
		for (i in 0...Setings.length){
			var TempO:Alphabet = new Alphabet(0, 0, Setings[i], true, false);
			FlxTween.tween(TempO, {y: (78 * i) + 40}, 0.4, {ease: FlxEase.quadInOut});
			SetingText.push(TempO);
			add(TempO);
			
			if (Setings[i] == "Start Volume"){
				TempO.changeText("Start Volume " + Settings.Get('Start Volume'));
			}
			
			if(BS[i]){
				var ChkBx:FlxSprite = new FlxSprite();
				ChkBx.frames = Paths.getSparrowAtlas('Box');
				ChkBx.animation.addByPrefix('Yes', 'Tick', 24, false);
				ChkBx.animation.addByPrefix('No', 'Untick', 24, false);
				add(ChkBx);
				Boxes.push(ChkBx);
				ChkBx.animation.play(quickCheck(Setings[i]));
				FlxTween.tween(ChkBx, {y: (78 * i) + 40}, 0.4, {ease: FlxEase.quadInOut});
			} else
				Boxes.push(new FlxSprite());
		}
	}
	
	function GameplayM()
	{
		Setings = ['Downscroll', 'Show HUD', 'BotPlay', 'Ghost Tapping', 'Better Accuracy'];
		Desc = [
		'Makes the notes go down instead of up. C\'mon you know this already',
		'When unchecked, the game hides the time text and stats',
		'Plays for you :)',
		'When you press a key in the game, you won\'t recieve a miss. Unless unchecked',
		'Uses the better accuracy system. (Slightly more memory intensive!)'
		];
		BS = [true, true, true, true, true];
		
		for (i in 0...Setings.length){
			var TempO:Alphabet = new Alphabet(0, 0, Setings[i], true, false);
			FlxTween.tween(TempO, {y: (78 * i) + 40}, 0.4, {ease: FlxEase.quadInOut});
			SetingText.push(TempO);
			add(TempO);
			
			if(BS[i]){
				var ChkBx:FlxSprite = new FlxSprite();
				ChkBx.frames = Paths.getSparrowAtlas('Box');
				ChkBx.animation.addByPrefix('Yes', 'Tick', 24, false);
				ChkBx.animation.addByPrefix('No', 'Untick', 24, false);
				add(ChkBx);
				Boxes.push(ChkBx);
				ChkBx.animation.play(quickCheck(Setings[i]));
				FlxTween.tween(ChkBx, {y: (78 * i) + 40}, 0.4, {ease: FlxEase.quadInOut});
			} else
				Boxes.push(new FlxSprite());
		}
	}
	
	function ControlsM()
	{
		Setings = [
		'4K Left', '4K Down', '4K Up', '4K Right', '', 							//  |
		'6K Left', '6K Up', '6K Right', '6K Left2', '6K Down', '6K Right2', '', //  V   jeez what a mess.
		'9K Left', '9K Down', '9K Up', '9K Right', '9K Middle', '9K Left2', '9K Down2', '9K Up2', '9K Right2'
		];
		Desc = [
		'', '', '', '', '',
		'', '', '', '', '', '', '',
		'', '', '', '', '', '', '', '', ''
		];
		BS = [
		false, false, false, false, 
		false, false, false, false, false, false, 
		false, false, false, false, false, false, false, false, false
		];
		
		for (i in 0...Setings.length){
			var curKey:String = "";
			
			switch (Setings[i].substring(0, 1))
			{
				case "4":
					curKey = Controls.getKeyName(Settings.Get("4K Controls")[i]);
				case "6":
					curKey = Controls.getKeyName(Settings.Get("6K Controls")[i - 5]);
				case "9":
					curKey = Controls.getKeyName(Settings.Get("9K Controls")[i - 12]);
			}

			var gibGorb:String = Setings[i] != '' ? ": " : "";
			
			var TempO:Alphabet = new Alphabet(0, 0, Setings[i] + gibGorb + curKey, false, false);
			FlxTween.tween(TempO, {y: (78 * i) + 10}, 0.4, {ease: FlxEase.quadInOut});
			SetingText.push(TempO);
			add(TempO);
		}
	}
	
	function OffsetM(){
		Setings = ["No", "NO"];
		Desc = ["Isaac Mod Studios® Technologys", "Isaac Mod Studios® Technologys"];
		BS = [false, false];
		for (i in 0...2){
			var TempO:Alphabet = new Alphabet(0, 0, "a", false, false);
			SetingText.push(TempO);
			add(TempO);
		}
	}

	function OtherM()
	{
		Setings = ['Camera Zooms', 'Show FPS', 'FPS Cap', 'Light Opponent Strums', 'Reset Settings'];
		Desc = [
		'Camera wont zoom on beat, or MILF. Idk why you\'d disable this',
		'Show the FPS at the top left???????',
		'Min is 60. Max is 500. Change this if you\'d like to preserve system resources',
		'Light the gray notes on the left. (pls keep enabled)',
		'Resets to true defaults, not a preset'
		];
		BS = [true, true, false, true, false];
		
		for (i in 0...Setings.length){
			var TempO:Alphabet = new Alphabet(0, 0, Setings[i], true, false);
			FlxTween.tween(TempO, {y: (78 * i) + 40}, 0.4, {ease: FlxEase.quadInOut});
			SetingText.push(TempO);
			add(TempO);
			
			if (Setings[i] == "FPS Cap"){
				TempO.changeText("FPS Cap " + Settings.Get('FPS Cap'));
			}
			
			if(BS[i]){
				var ChkBx:FlxSprite = new FlxSprite();
				ChkBx.frames = Paths.getSparrowAtlas('Box');
				ChkBx.animation.addByPrefix('Yes', 'Tick', 24, false);
				ChkBx.animation.addByPrefix('No', 'Untick', 24, false);
				add(ChkBx);
				Boxes.push(ChkBx);
				ChkBx.animation.play(quickCheck(Setings[i]));
				FlxTween.tween(ChkBx, {y: (78 * i) + 40}, 0.4, {ease: FlxEase.quadInOut});
			} else {
				Boxes.push(new FlxSprite());
			}
		}
	}

	function PresetsM()
	{
		Setings = ['Average FNF Player', 'Beginner FNF Player', 'Competitive FNF Player', 'Demo or Showcaser'];
		Desc = [
		'For fnf players with some experience, but don\'t care about offset', 
		'For fnf players as their first rythm game! pretty much stock game settings', 
		'For experienced rythm gamers in other games. Or really good fnf players',
		'Enables BOTPLAY, hides hud elements. Made for showcasing crap'
		];
		BS = [false, false, false, false];
		
		for (i in 0...Setings.length){
			var TempO:Alphabet = new Alphabet(0, 0, Setings[i], true, false);
			FlxTween.tween(TempO, {y: (78 * i) + 40}, 0.4, {ease: FlxEase.quadInOut});
			SetingText.push(TempO);
			add(TempO);
			
			if(BS[i]){
				var ChkBx:FlxSprite = new FlxSprite();
				ChkBx.frames = Paths.getSparrowAtlas('Box');
				ChkBx.animation.addByPrefix('Yes', 'Tick', 24, false);
				ChkBx.animation.addByPrefix('No', 'Untick', 24, false);
				add(ChkBx);
				Boxes.push(ChkBx);
				ChkBx.animation.play(quickCheck(Setings[i]));
				FlxTween.tween(ChkBx, {y: (78 * i) + 40}, 0.4, {ease: FlxEase.quadInOut});
			} else
				Boxes.push(new FlxSprite());
		}
	}
	
}
