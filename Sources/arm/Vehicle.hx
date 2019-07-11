package arm;

import iron.system.Time;
import iron.math.Vec4;

import kha.FastFloat;

class Vehicle extends GameTrait
{
	private var type: String;

	private var active: Bool = false;
	
	private var alive: Bool = true;
	private var aliveTime: FastFloat = 10.0;

	private var direction: Vec4;
	private var speed: FastFloat = 0.1;
	private var system: VehicleSystem;

	public function new()
	{
		super();

		notifyOnInit(function() {
			system = game.vehicleSystem;
			system.register(this);
		});

		notifyOnUpdate(function() {
			if (active && alive) {
				object.transform.translate(direction.x * speed, direction.y * speed, direction.z * speed);

				if (aliveTime > 0) {
					aliveTime -= Time.delta;
				}
			}

			if (aliveTime <= 0) {
				alive = false;
				object.remove();
			}
		});
	}

	public function setActive(b: Bool)
	{
		active = b;
	}

	public function setLifeTime(t: FastFloat)
	{
		aliveTime = t;
	}

	public function setDirection(d: Vec4)
	{
		direction = d;
	}
}