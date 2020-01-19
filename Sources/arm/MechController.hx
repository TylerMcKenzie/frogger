package arm;

import armory.trait.physics.RigidBody;

import iron.system.Input;

import kha.FastFloat;

class MechController extends iron.Trait {
    @prop
    private var strafeSpeed: Float = 0.45;
    private var baseStrafeSpeed: FastFloat;

    @prop
    private var runSpeed: Float = 0.35;
    private var baseRunSpeed: FastFloat;

	private var kb: Keyboard = Input.getKeyboard();
	
    private var body: RigidBody;

    public function new() {
        super();

        notifyOnInit(function() {
            baseRunSpeed = runSpeed;
            baseStrafeSpeed = strafeSpeed;

			body = object.getChild("Mech").getTrait(RigidBody);
		});

        notifyOnUpdate(function() {
			if (GameController.getState() != "PLAYING") return;
			if (!body.ready) return;
			
			if (kb.down("left") || kb.down("a")) moveLeft();
			if (kb.down("right") || kb.down("d")) moveRight();

            moveForward();

			body.syncTransform();
		});
    }

    public function resetRunSpeed()
    {
        runSpeed = baseRunSpeed;
    }

    public function resetStrafeSpeed()
    {
        strafeSpeed = baseStrafeSpeed;
    }

    public function setRunSpeed(speed: FastFloat)
    {
        runSpeed = speed;
    }

    public function setStrafeSpeed(speed: FastFloat)
    {
        strafeSpeed = speed;
    }

    private function moveLeft()
    {
        object.transform.translate(-strafeSpeed, 0, 0);
    }

    private function moveRight()
    {
        object.transform.translate(strafeSpeed, 0, 0);
    }

    private function moveForward()
    {
        object.transform.translate(0, runSpeed, 0);
    }
}