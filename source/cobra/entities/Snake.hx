package cobra.entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.FlxObject;
import flixel.system.FlxAssets;

class Snake extends FlxSprite
{
    private var _score:Int = 0;
    private var _headPositions:Array<FlxPoint>;
	private var _body:FlxSpriteGroup;
	private var _currentDirection:Int = FlxObject.UP;
	private var _nextDirection:Int = FlxObject.UP;
    private var _color:FlxColor;

    private var _keyUp:Int;
    private var _keyDown:Int;
    private var _keyLeft:Int;
    private var _keyRight:Int;

    public function new(X:Float = 0, Y:Float = 0, Color:FlxColor, KeyUp:Int, KeyDown:Int, KeyLeft:Int, KeyRight:Int)
	{
        // Create sprite using a position as parameter
        super(X, Y);

        // Assign snake color
        _color = Color;

        // Asign controls
        _keyUp = KeyUp;
        _keyDown = KeyDown;
        _keyLeft = KeyLeft;
        _keyRight = KeyRight;

        // Create a red block
        this.makeGraphic(cobra.states.PlayState.BLOCK_SIZE - 2, cobra.states.PlayState.BLOCK_SIZE - 2, _color);

        // Set the offset and center it
        this.offset.set(1, 1);
		this.centerOffsets();

        // Head tracker used to update body units
		_headPositions = [FlxPoint.get(this.x, this.y)];

        // Create snake body
		_body = new FlxSpriteGroup();

        // Increase 3x body units in snake and move them
		for (i in 0...3)
        {
            grown(); 
            move();
        }
    }

    override public function update(elapsed:Float)
	{
        super.update(elapsed);

        // Keys controls
		if (FlxG.keys.anyPressed([_keyUp]) && _currentDirection != FlxObject.DOWN)
			_nextDirection = FlxObject.UP;

		else if (FlxG.keys.anyPressed([_keyDown]) && _currentDirection != FlxObject.UP)
			_nextDirection = FlxObject.DOWN;

		else if (FlxG.keys.anyPressed([_keyLeft]) && _currentDirection != FlxObject.RIGHT)
			_nextDirection = FlxObject.LEFT;

		else if (FlxG.keys.anyPressed([_keyRight]) && _currentDirection != FlxObject.LEFT)
			_nextDirection = FlxObject.RIGHT;

        // Check this is not dead yet
        if(this.alive)
        {
        	// Set game over case this go out of the screen
			if (!this.isOnScreen())
                die();
        }
    }

	private function grown():Void
	{
		// Increase snake unit
		var snakeUnit:FlxSprite = new FlxSprite(-20, -20);
		snakeUnit.makeGraphic(cobra.states.PlayState.BLOCK_SIZE - 2, cobra.states.PlayState.BLOCK_SIZE - 2, _color); 
		_body.add(snakeUnit);
	}

    public function move():Void
	{
		_headPositions.unshift(FlxPoint.get(this.x, this.y));
		
		if (_headPositions.length > _body.members.length)
			_headPositions.pop();

		// Update snake position
		switch (_nextDirection)
		{
			case FlxObject.LEFT: this.x -= cobra.states.PlayState.BLOCK_SIZE;
			case FlxObject.RIGHT: this.x += cobra.states.PlayState.BLOCK_SIZE;
			case FlxObject.UP: this.y -= cobra.states.PlayState.BLOCK_SIZE;
			case FlxObject.DOWN: this.y += cobra.states.PlayState.BLOCK_SIZE;
		}
		_currentDirection = _nextDirection;
		
		for (i in 0..._headPositions.length)
		{
			_body.members[i].setPosition(_headPositions[i].x, _headPositions[i].y);
		}
	}

    public function eat():Void
	{
		// Update the score
		_score += 10;
		
		// Play a sound
		FlxG.sound.load(FlxAssets.getSound("flixel/sounds/flixel")).play();
		
		// Increase the size of snake
		grown();
	}

    public function die(?Object1:FlxObject, ?Object2:FlxObject):Void
    {
		// Kill the snake
        this.alive = false;
		this.kill();
		_body.kill();

        // Play a sound
		FlxG.sound.load(FlxAssets.getSound("flixel/sounds/beep")).play();
    }

    public function getBody():FlxSpriteGroup
	{
        return _body;
    }

    public function getScore():Int
	{
        return _score;
    }
}