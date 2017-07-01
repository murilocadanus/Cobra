package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.system.FlxAssets;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
	private static inline var MIN_INTERVAL:Float = 2;
	private static inline var SCORE_TEXT_SIZE:Int = 130;
	private static inline var BLOCK_SIZE:Int = 8;
	
	private var _movementInterval:Float = 8;

	private var _player1Score:Int = 0;
	private var _player1ScoreText:FlxText;
	private var _player1HeadPositions:Array<FlxPoint>;
	private var _player1Head:FlxSprite;
	private var _player1Body:FlxSpriteGroup;
	private var _player1CurrentDirection = FlxObject.UP;
	private var _player1NextDirection:Int = FlxObject.UP;

	private var _player2Score:Int = 0;
	private var _player2ScoreText:FlxText;
	private var _player2HeadPositions:Array<FlxPoint>;
	private var _player2Head:FlxSprite;
	private var _player2Body:FlxSpriteGroup;
	private var _player2CurrentDirection = FlxObject.DOWN;
	private var _player2NextDirection:Int = FlxObject.DOWN;

	private var _fruit:FlxSprite;

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

		// Head tracker used to update body units
		_player1HeadPositions = [FlxPoint.get(_player1Head.x, _player1Head.y)];

		// Add player 1 snake head to the board
		add(_player1Head);

		// Create snake body for player 1
		_player1Body = new FlxSpriteGroup();
		add(_player1Body);

		// Increase 3x body units in player 1
		for (i in 0...3) { increasePlayer1Unit(); movePlayer1(); }

		// Create the sprite of player2
		_player2Head = new FlxSprite((FlxG.width - screenMiddleX / 2) - BLOCK_SIZE * 2, screenMiddleY);
		_player2Head.makeGraphic(BLOCK_SIZE - 2, BLOCK_SIZE - 2, FlxColor.GREEN);
		centerSprite(_player2Head);

		// Head tracker used to update body units
		_player2HeadPositions = [FlxPoint.get(_player2Head.x, _player2Head.y)];

		// Add player 2 snake head to the board
		add(_player2Head);

		// Create snake body for player 2
		_player2Body = new FlxSpriteGroup();
		add(_player2Body);

		// Increase 3x body units in player 2
		for (i in 0...3) { increasePlayer2Unit(); movePlayer2(); }

		// Create a collectable fruit
		_fruit = new FlxSprite();
		_fruit.makeGraphic(BLOCK_SIZE - 2, BLOCK_SIZE - 2, FlxColor.RED);
		spawnFruit();
		centerSprite(_fruit);
		add(_fruit);

		// Start to move player 2
		movePlayer2();

		// Set a timer to move
		timerTick();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Check if player 1 collected a fruit
		FlxG.overlap(_player1Head, _fruit, player1EatFruit);

		// Check if player 2 collected a fruit
		FlxG.overlap(_player2Head, _fruit, player2EatFruit);

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
		_player1HeadPositions.unshift(FlxPoint.get(_player1Head.x, _player1Head.y));
		
		if (_player1HeadPositions.length > _player1Body.members.length)
			_player1HeadPositions.pop();

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
		
		for (i in 0..._player1HeadPositions.length)
		{
			_player1Body.members[i].setPosition(_player1HeadPositions[i].x, _player1HeadPositions[i].y);
		}
	}

	private function movePlayer2():Void
	{
		_player2HeadPositions.unshift(FlxPoint.get(_player2Head.x, _player2Head.y));
		
		if (_player2HeadPositions.length > _player2Body.members.length)
			_player2HeadPositions.pop();

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

		for (i in 0..._player2HeadPositions.length)
		{
			_player2Body.members[i].setPosition(_player2HeadPositions[i].x, _player2HeadPositions[i].y);
		}
	}

	private function player1EatFruit(Snake:FlxObject, Fruit:FlxObject):Void
	{
		// Update the score
		_player1Score += 10;
		_player1ScoreText.text = "Player 1 score: " + _player1Score;
		
		// Play a sound
		FlxG.sound.load(FlxAssets.getSound("flixel/sounds/beep")).play();
		
		// Increase the size of snake
		increasePlayer1Unit();
		
		// Become faster each pickup - set a max speed though!
		if (_movementInterval >= MIN_INTERVAL)
		{
			_movementInterval -= 0.25;
		}

		// Spawn a new fruit
		spawnFruit();
	}

	private function player2EatFruit(Snake:FlxObject, Fruit:FlxObject):Void
	{
		// Update the score
		_player2Score += 10;
		_player2ScoreText.text = "Player 2 score: " + _player2Score;
		
		// Play a sound
		FlxG.sound.load(FlxAssets.getSound("flixel/sounds/beep")).play();

		// Increase the size of snake
		increasePlayer2Unit();
		
		// Become faster each pickup - set a max speed though!
		if (_movementInterval >= MIN_INTERVAL)
		{
			_movementInterval -= 0.25;
		}

		// Spawn a new fruit
		spawnFruit();
	}

	private function increasePlayer1Unit():Void
	{
		// Increase snake unit
		var snakeUnit:FlxSprite = new FlxSprite(-20, -20);
		snakeUnit.makeGraphic(BLOCK_SIZE - 2, BLOCK_SIZE - 2, FlxColor.CYAN); 
		_player1Body.add(snakeUnit);
	}

	private function increasePlayer2Unit():Void
	{
		// Increase snake unit
		var snakeUnit:FlxSprite = new FlxSprite(-20, -20);
		snakeUnit.makeGraphic(BLOCK_SIZE - 2, BLOCK_SIZE - 2, FlxColor.GREEN); 
		_player2Body.add(snakeUnit);
	}

	private function spawnFruit(?fruitPos:FlxObject, ?playerPos:FlxObject):Void
	{
		// Pick a random place to put the fruit down
		_fruit.x = FlxG.random.int(0, Math.floor(FlxG.width / 8) - 1) * 8;
		_fruit.y = FlxG.random.int(0, Math.floor(FlxG.height / 8) - 1) * 8;
		
		// Check that the coordinates we picked aren't already covering the snake, if they are then run this function again
		FlxG.overlap(_fruit, _player1Head, spawnFruit);
	}
}
