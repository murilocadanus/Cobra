package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private static inline var SCORE_TEXT_SIZE:Int = 130;
	private static inline var BLOCK_SIZE:Int = 8;

	private var _player1Score:Int = 0;
	private var _player1ScoreText:FlxText;
	private var _player1Head:FlxSprite;

	private var _player2Score:Int = 0;
	private var _player2ScoreText:FlxText;
	private var _player2Head:FlxSprite;

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
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function centerSprite(Sprite:FlxSprite):Void
	{
		Sprite.offset.set(1, 1);
		Sprite.centerOffsets();
	}
}
