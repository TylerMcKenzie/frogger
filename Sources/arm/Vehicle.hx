package arm;

import armory.trait.physics.RigidBody;
import arm.system.VehicleSystem;
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
	private var speed: FastFloat = 0.5;
	private var system: VehicleSystem;

	private var body: RigidBody;

	public function new()
	{
		super();

		notifyOnInit(function() {
			this.system = this.game.vehicleSystem;
			this.system.register(this);

			this.body = this.object.getTrait(RigidBody);
		});

		notifyOnUpdate(function() {
			if (this.active && this.alive) {
				if (!this.body.ready) return;

				this.object.transform.translate(direction.x * speed, direction.y * speed, direction.z * speed);
				this.body.syncTransform();

				if (this.aliveTime > 0 && this.active) {
					this.aliveTime -= Time.delta;
				}
			}

			if (this.aliveTime <= 0) {
				this.alive = false;
				this.object.remove();
			}
		});

		notifyOnRemove(function() {
			this.system.unregister(this);
		});
	}

	public function setActive(active: Bool)
	{
		this.active = active;
	}

	public function setLifeTime(time: FastFloat)
	{
		this.aliveTime = time;
	}

	public function setDirection(direction: Vec4)
	{
		this.direction = direction;
	}
}
