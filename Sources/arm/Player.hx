package arm;

import kha.FastFloat;
import iron.system.Input;


@:enum
abstract StepConfig(FastFloat) 
{
	var PLAYER_STEP_X = 3.0;
	var PLAYER_STEP_Y = 6.0;
}

class Player extends GameTrait 
{
	private var kb = Input.getKeyboard();
	private var stepX = cast(PLAYER_STEP_X, FastFloat);
	private var stepY = cast(PLAYER_STEP_Y, FastFloat);

	public function new()
	{
		super();

		notifyOnUpdate(function() {
			if (game.state != PLAYING) return;
			
			if (kb.started("up") || kb.started("w")) jumpForward();
			if (kb.started("down") || kb.started("s")) jumpBackward();
			if (kb.started("left") || kb.started("a")) jumpLeft();
			if (kb.started("right") || kb.started("d")) jumpRight();
		});
	}

	private function jumpForward() 
	{
		object.transform.translate(0, stepY, 0);
	}

	private function jumpBackward() 
	{
		object.transform.translate(0, -stepY, 0);
	}
	
	private function jumpLeft() 
	{
		object.transform.translate(-stepX, 0, 0);
	}
	
	private function jumpRight() 
	{
		object.transform.translate(stepX, 0, 0);
	}
}
