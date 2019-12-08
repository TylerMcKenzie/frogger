package arm;

import kha.FastFloat;
import iron.system.Input;

import arm.config.StepConfig;
import armory.trait.physics.PhysicsWorld;
import armory.trait.physics.RigidBody;

class Player extends iron.Trait 
{
	private var kb: Keyboard = Input.getKeyboard();
	private var stepX: FastFloat = cast PLAYER_STEP_X;
	private var stepY: FastFloat = cast PLAYER_STEP_Y;

	private var body: RigidBody;
	private var physics: PhysicsWorld;
	private var dead: Bool = false;

	public function new()
	{
		super();

		notifyOnInit(function() {
			body = object.getTrait(RigidBody);
			physics = PhysicsWorld.active;
		});

		notifyOnUpdate(function() {
			if (GameController.getState() != "PLAYING") return;
			if (!body.ready) return;
			
			if (kb.started("up") || kb.started("w")) jumpForward();
			if (kb.started("down") || kb.started("s")) jumpBackward();
			if (kb.started("left") || kb.started("a")) jumpLeft();
			if (kb.started("right") || kb.started("d")) jumpRight();
			
			body.syncTransform();

			if (getVehicleCollision() == true) {
				this.dead = true;
			}
		});
	}

	private function getVehicleCollision()
    {
        var collisionObjects = physics.getContacts(this.body);

        if (collisionObjects != null) {
            trace(collisionObjects.length);
            for (cObject in collisionObjects) {
                if (cObject.object.getTrait(Vehicle) != null) {
                    return true;
                }
            }
        }

        return false;
    }

	public function reset()
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
