package arm;

import kha.FastFloat;
import iron.system.Input;

import armory.trait.physics.RigidBody;

class Player extends iron.Trait 
{
	private var kb: Keyboard = Input.getKeyboard();
	private var stepX: FastFloat = cast PLAYER_STEP_X;
	private var stepY: FastFloat = cast PLAYER_STEP_Y;

	private var body: RigidBody;

	private var dead: Bool = false;

	public function new()
	{
		super();

		notifyOnInit(function() {
			body = object.getTrait(RigidBody);
		});

		notifyOnUpdate(function() {
			if (GameController.getState() != PLAYING) return;
			if (!body.ready) return;
			
			if (kb.started("up") || kb.started("w")) jumpForward();
			// if (kb.started("down") || kb.started("s")) jumpBackward();
			if (kb.started("left") || kb.started("a")) jumpLeft();
			if (kb.started("right") || kb.started("d")) jumpRight();
			
			body.syncTransform();
		});
	}

	override public function reset()
	{
		dead = false;
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

	public function isDead()
	{
		return dead;
	}
}
