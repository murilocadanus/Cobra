package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	private static inline var SCORE_TEXT_SIZE:Int = 130;
	private var _player1Score:Int = 0;
	private var _player1ScoreText:FlxText;

	private var _player2Score:Int = 0;
	private var _player2ScoreText:FlxText;

	override public function create():Void
	{
		// Disable mouse cursor
		FlxG.mouse.visible = false;

		// Add score label for player 1
		_player1ScoreText = new FlxText(0, 0, SCORE_TEXT_SIZE, "Player 1 score: " + _player1Score);
		add(_player1ScoreText);

		// Add score label for player 2
		_player2ScoreText = new FlxText(FlxG.width - SCORE_TEXT_SIZE, 0, SCORE_TEXT_SIZE, "Player 2 score: " + _player2Score);
		add(_player2ScoreText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
