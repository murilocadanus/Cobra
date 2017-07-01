package cobra.entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Fruit extends FlxSprite
{
    public function new()
	{
        super();

        // Create a red block
        this.makeGraphic(cobra.states.PlayState.BLOCK_SIZE - 2, cobra.states.PlayState.BLOCK_SIZE - 2, FlxColor.RED);

        // Set the offset and center it
        this.offset.set(1, 1);
		this.centerOffsets();
    }

    override public function update(elapsed:Float)
	{
        super.update(elapsed);
    }

    public function spawn()
    {
        // Pick a random place to put the fruit down
		this.x = FlxG.random.int(0, Math.floor(FlxG.width / 8) - 1) * 8;
		this.y = FlxG.random.int(0, Math.floor(FlxG.height / 8) - 1) * 8;
    }
}