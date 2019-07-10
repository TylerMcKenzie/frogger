package arm;

import iron.math.Vec4;

import kha.FastFloat;

class Vehicle extends GameTrait
{
	private var type: String;

	private var active: Bool;
	private var direction: Vec4;
	private var speed: FastFloat = 1.0;
	private var system: VehicleSystem;

	public function new()
	{
		super();

		notifyOnInit(function() {
			system = game.vehicleSystem;
			system.register(this);
		});

		notifyOnUpdate(function() {
			if (active) {
				object.transform.translate(direction.x * speed, direction.y * speed, direction.z * speed);
			}
		});
	}

	public function setActive(b: Bool)
	{
		active = b;
	}

	public function setDirection(d: Vec4)
	{
		direction = d;
	}
}