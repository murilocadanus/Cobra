package cobra.states;

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
import flixel.input.keyboard.FlxKey;

import cobra.entities.Fruit;
import cobra.entities.Snake;

class PlayState extends FlxState
{
	private static inline var MIN_INTERVAL:Float = 2;
	private static inline var SCORE_TEXT_SIZE:Int = 130;
	public static inline var BLOCK_SIZE:Int = 8;
	
	private var _movementInterval:Float = 8;

	private var _player1ScoreText:FlxText;
	private var _player1:Snake;

	private var _player2ScoreText:FlxText;
	private var _player2:Snake;
	
	private var _gameOverState:GameOverState = new GameOverState();

	private var _fruit:Fruit;

	override public function create():Void
	{
		// Get the middle screen positions
		var screenMiddleX:Int = Math.floor(FlxG.width / 2);
		var screenMiddleY:Int = Math.floor(FlxG.height / 2);

		// Disable mouse cursor
		FlxG.mouse.visible = false;

		// Add score label for player 1
		_player1ScoreText = new FlxText(0, 0, SCORE_TEXT_SIZE, "Player 1 score: 0");
		add(_player1ScoreText);

		// Add score label for player 2
		_player2ScoreText = new FlxText(FlxG.width - SCORE_TEXT_SIZE, 0, SCORE_TEXT_SIZE, "Player 2 score: 0");
		add(_player2ScoreText);

		// Create the player 1
		_player1 = new Snake(screenMiddleX / 2 - BLOCK_SIZE * 2, screenMiddleY, FlxColor.CYAN, 
			FlxKey.W, FlxKey.S, FlxKey.A, FlxKey.D);

		// Add player 1 snake to the board
		add(_player1);
		add(_player1.getBody());

		// Create the player 2
		_player2 = new Snake((FlxG.width - screenMiddleX / 2) - BLOCK_SIZE * 2, screenMiddleY, FlxColor.GREEN, 
			FlxKey.UP, FlxKey.DOWN, FlxKey.LEFT, FlxKey.RIGHT);

		// Add player 2 snake to the board
		add(_player2);
		add(_player2.getBody());

		// Create a collectable fruit
		_fruit = new Fruit();
		spawnFruit();
		add(_fruit);

		// Set a timer to move
		timerTick();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Check end game
		if(!_player1.alive && !_player2.alive)
		{
			_gameOverState.setPlayer1FinalScore(_player1.getScore());
			_gameOverState.setPlayer2FinalScore(_player2.getScore());
			FlxG.switchState(_gameOverState);
		}

		if(_player1.alive)
		{
			// Check if player 1 collected a fruit
			FlxG.overlap(_player1, _fruit, player1EatFruit);

			// Check if player1 collided with yourself
			FlxG.overlap(_player1, _player1.getBody(), gameOverPlayer1);
			FlxG.overlap(_player1, _player2.getBody(), gameOverPlayer1);

			// Set game over case player go out of the screen
			if (!_player1.isOnScreen()) gameOverPlayer1();
		}

		if(_player2.alive)
		{
			// Check if player 2 collected a fruit
			FlxG.overlap(_player2, _fruit, player2EatFruit);

			// Check if player2 collided with yourself
			FlxG.overlap(_player2, _player2.getBody(), gameOverPlayer2);
			FlxG.overlap(_player2, _player1.getBody(), gameOverPlayer2);

			if (!_player2.isOnScreen()) gameOverPlayer2();
		}
	}

	private function timerTick(?Timer:FlxTimer):Void
	{	
		new FlxTimer().start(_movementInterval / FlxG.updateFramerate, timerTick);
		_player1.move();
		_player2.move();
	}

	private function player1EatFruit(Snake:FlxObject, Fruit:FlxObject):Void
	{
		// Update the score
		_player1.eat();
		_player1ScoreText.text = "Player 1 score: " + _player1.getScore();
		
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
		_player2.eat();
		_player2ScoreText.text = "Player 2 score: " + _player2.getScore();
		
		// Become faster each pickup - set a max speed though!
		if (_movementInterval >= MIN_INTERVAL)
		{
			_movementInterval -= 0.25;
		}

		// Spawn a new fruit
		spawnFruit();
	}

	private function spawnFruit(?fruitPos:FlxObject, ?playerPos:FlxObject):Void
	{
		// Generate a random position
		_fruit.spawn();
		
		// Check if coordenates aren't over player 1 body
		FlxG.overlap(_fruit, _player1.getBody(), spawnFruit);

		// Check if coordenates aren't over player 2 body
		FlxG.overlap(_fruit, _player2.getBody(), spawnFruit);
	}

	private function gameOverPlayer1(?Object1:FlxObject, ?Object2:FlxObject):Void
	{
		// Player the sound only if the other player is alive
		if(_player2.alive)
			FlxG.sound.play("assets/sounds/flixel.wav");

		_player1.alive = false;
	}

	private function gameOverPlayer2(?Object1:FlxObject, ?Object2:FlxObject):Void
	{
		// Player the sound only if the other player is alive
		if(_player1.alive)
			FlxG.sound.play("assets/sounds/flixel.wav");

		_player2.alive = false;
	}
}
