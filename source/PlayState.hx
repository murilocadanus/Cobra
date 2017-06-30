package;

import flixel.FlxState;
import flixel.FlxG;

class PlayState extends FlxState
{
	override public function create():Void
	{
		FlxG.mouse.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
