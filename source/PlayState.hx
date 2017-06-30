package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	private static inline var SCORE_TEXT_SIZE:Int = 130;
	private static inline var BLOCK_SIZE:Int = 8;
	private var _movementInterval:Float = 8;

	private var _player1Score:Int = 0;
	private var _player1ScoreText:FlxText;
	private var _player1Head:FlxSprite;
	private var _player1CurrentDirection = FlxObject.UP;
	private var _player1NextDirection:Int = FlxObject.UP;

	private var _player2Score:Int = 0;
	private var _player2ScoreText:FlxText;
	private var _player2Head:FlxSprite;
	private var _player2CurrentDirection = FlxObject.DOWN;
	private var _player2NextDirection:Int = FlxObject.DOWN;

	override public function create():Void
	{
		// Get the middle screen positions
		var screenMiddleX:Int = Math.floor(FlxG.width / 2);
		var screenMiddleY:Int = Math.floor(FlxG.height / 2);

		// Disable mouse cursor
		FlxG.mouse.visible = false;

		// Add score label for player 1
		_player1ScoreText = new FlxText(0, 0, SCORE_TEXT_SIZE, "Player 1 score: " + _player1Score);
		add(_player1ScoreText);

		// Add score label for player 2
		_player2ScoreText = new FlxText(FlxG.width - SCORE_TEXT_SIZE, 0, SCORE_TEXT_SIZE, "Player 2 score: " + _player2Score);
		add(_player2ScoreText);

		// Create the sprite of player1
		_player1Head = new FlxSprite(screenMiddleX / 2 - BLOCK_SIZE * 2, screenMiddleY);
		_player1Head.makeGraphic(BLOCK_SIZE - 2, BLOCK_SIZE - 2, FlxColor.CYAN);
		centerSprite(_player1Head);

		// Add player 1 snake head to the board
		add(_player1Head);

		// Create the sprite of player2
		_player2Head = new FlxSprite((FlxG.width - screenMiddleX / 2) - BLOCK_SIZE * 2, screenMiddleY);
		_player2Head.makeGraphic(BLOCK_SIZE - 2, BLOCK_SIZE - 2, FlxColor.GREEN);
		centerSprite(_player2Head);

		// Add player 2 snake head to the board
		add(_player2Head);

		// Start to move player 1
		movePlayer1();

		// Start to move player 2
		movePlayer2();

		// Set a timer to move
		timerTick();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// WASD keys controls player 1
		if (FlxG.keys.pressed.W && _player1CurrentDirection != FlxObject.DOWN)
		{
			_player1NextDirection = FlxObject.UP;
		}
		else if (FlxG.keys.pressed.S && _player1CurrentDirection != FlxObject.UP)
		{
			_player1NextDirection = FlxObject.DOWN;
		}
		else if (FlxG.keys.pressed.A && _player1CurrentDirection != FlxObject.RIGHT)
		{
			_player1NextDirection = FlxObject.LEFT;
		}
		else if (FlxG.keys.pressed.D && _player1CurrentDirection != FlxObject.LEFT)
		{
			_player1NextDirection = FlxObject.RIGHT;
		}

		// Arrow keys to controls player 2
		if (FlxG.keys.pressed.UP && _player2CurrentDirection != FlxObject.DOWN)
		{
			_player2NextDirection = FlxObject.UP;
		}
		else if (FlxG.keys.pressed.DOWN && _player2CurrentDirection != FlxObject.UP)
		{
			_player2NextDirection = FlxObject.DOWN;
		}
		else if (FlxG.keys.pressed.LEFT && _player2CurrentDirection != FlxObject.RIGHT)
		{
			_player2NextDirection = FlxObject.LEFT;
		}
		else if (FlxG.keys.pressed.RIGHT && _player2CurrentDirection != FlxObject.LEFT)
		{
			_player2NextDirection = FlxObject.RIGHT;
		}
	}

	private function centerSprite(Sprite:FlxSprite):Void
	{
		Sprite.offset.set(1, 1);
		Sprite.centerOffsets();
	}

	private function timerTick(?Timer:FlxTimer):Void
	{	
		new FlxTimer().start(_movementInterval / FlxG.updateFramerate, timerTick);
		movePlayer1();
		movePlayer2();
	}

	private function movePlayer1():Void
	{
		// Update player 1 position
		switch (_player1NextDirection)
		{
			case FlxObject.LEFT:
				_player1Head.x -= BLOCK_SIZE;
			case FlxObject.RIGHT:
				_player1Head.x += BLOCK_SIZE;
			case FlxObject.UP:
				_player1Head.y -= BLOCK_SIZE;
			case FlxObject.DOWN:
				_player1Head.y += BLOCK_SIZE;
		}
		_player1CurrentDirection = _player1NextDirection;

		FlxSpriteUtil.screenWrap(_player1Head);
	}

	private function movePlayer2():Void
	{
		// Update player 2 position
		switch (_player2NextDirection)
		{
			case FlxObject.LEFT:
				_player2Head.x -= BLOCK_SIZE;
			case FlxObject.RIGHT:
				_player2Head.x += BLOCK_SIZE;
			case FlxObject.UP:
				_player2Head.y -= BLOCK_SIZE;
			case FlxObject.DOWN:
				_player2Head.y += BLOCK_SIZE;
		}
		_player2CurrentDirection = _player2NextDirection;

		FlxSpriteUtil.screenWrap(_player2Head);
	}
}
