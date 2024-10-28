package;

import towsterFlxUtil.TowPaths;
import flixel.FlxSprite;
import flixel.FlxState;

class CreditsState extends FlxState
{
	var BG:FlxSprite;

	override function create()
	{
		super.create();

		BG = new FlxSprite(0, 0).loadGraphic(TowPaths.getFilePath('menus/menuBGPurple', PNG));
		add(BG);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());
		}
	}
}