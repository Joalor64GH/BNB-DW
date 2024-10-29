package;

import openfl.Assets;
import towsterFlxUtil.TowPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import Alphabet;

using StringTools;

class CreditsState extends FlxState
{
	var BG:FlxSprite;

	var credsGrp:FlxTypedGroup<Alphabet>;
	var credits:Array<String> = [];
	var curSelected:Int = 0;

	override function create()
	{
		super.create();

		credits = getText(TowPaths.getFile('credits', TXT));

		BG = new FlxSprite(0, 0).loadGraphic(TowPaths.getFilePath('menus/menuBGPurple', PNG));
		add(BG);

		for (i in 0...credits.length) {
            var creditsText:Alphabet = new Alphabet(90, 320, credits[i], true);
            creditsText.isMenuItem = true;
            creditsText.targetY = i;
            credsGrp.add(creditsText);
        }

        changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
        {
            changeSelection(FlxG.keys.justPressed.UP ? -1 : 1);
        }

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());
		}
	}

    private function changeSelection(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, credits.length - 1);

        for (num => item in credsGrp.members)
        {
            item.targetY = num - curSelected;
            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }

    inline public static function getText(path:String):Array<String>
		return Assets.exists(path) ? [for (i in Assets.getText(path).trim().split('\n')) i.trim()] : [];
}