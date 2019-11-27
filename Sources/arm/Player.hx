package arm;

import iron.Scene;
import kha.FastFloat;
import iron.system.Input;

import armory.trait.physics.RigidBody;

class Player extends GameTrait 
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
			this.body = this.object.getTrait(RigidBody);
		});

		notifyOnUpdate(function() {
			if (this.game.getState() != PLAYING) return;
			if (!this.body.ready) return;
			
			if (this.kb.started("up") || this.kb.started("w")) jumpForward();
			// if (this.kb.started("down") || this.kb.started("s")) jumpBackward();
			if (this.kb.started("left") || this.kb.started("a")) jumpLeft();
			if (this.kb.started("right") || this.kb.started("d")) jumpRight();
			
			this.body.syncTransform();
		});
	}

	override public function reset()
	{
		this.dead = false;
	}

	private function jumpForward() 
	{
		this.object.transform.translate(0, stepY, 0);
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
		return this.dead;
	}
}
