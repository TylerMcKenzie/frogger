package arm;

import iron.Scene;
import kha.FastFloat;
import iron.system.Input;

import armory.trait.physics.RigidBody;
import armory.trait.physics.PhysicsWorld;

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

	private var physics:PhysicsWorld;
	private var body: RigidBody;

	private var dead: Bool = false;

	public function new()
	{
		super();

		notifyOnInit(function() {
			this.physics = PhysicsWorld.active;
			this.body = this.object.getTrait(RigidBody);
		});

		notifyOnUpdate(function() {
			if (this.game.state != PLAYING) return;
			if (!this.body.ready) return;
			
			if (this.kb.started("up") || this.kb.started("w")) jumpForward();
			// if (this.kb.started("down") || this.kb.started("s")) jumpBackward();
			if (this.kb.started("left") || this.kb.started("a")) jumpLeft();
			if (this.kb.started("right") || this.kb.started("d")) jumpRight();
			
			this.body.syncTransform();

			var collisionObjects = physics.getContacts(this.body);

			if (collisionObjects != null) {
				for (cObject in collisionObjects) {
					if (cObject.object.getTrait(Vehicle) != null) {
						if (Scene.active.raw.name == "Game") this.dead = true; // IN SCENE 1
						if (Scene.active.raw.name == "Game 2") trace("FLING CAR"); // IN SCENE 2
					}
				}
			}
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
