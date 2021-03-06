package arm;

import armory.trait.physics.RigidBody;

import iron.data.MaterialData;
import iron.object.Object;
import iron.object.MeshObject;
import iron.math.Vec4;
import iron.system.Time;

import kha.Image;
import kha.FastFloat;

class Vehicle extends iron.Trait
{
	private var type: String;

	private var active: Bool = false;
	
	private var alive: Bool = true;
	private var aliveTime: FastFloat = 10.0;

	private var moving: Bool = true;

	private var direction: Vec4;
	private var speed: FastFloat = 0.5;

	private var body: RigidBody;

	private var isCollided: Bool = false;

	public function new()
	{
		super();

		notifyOnInit(function() {
			GameController.vehicleSystem.register(this);
			
			this.body = this.object.getTrait(RigidBody);
		});

		notifyOnUpdate(function() {
			if (!this.body.ready) {
				return;
			}

			if (GameController.getState() == "PAUSED") return;

			if (this.active && this.alive) {

				if (this.moving) {
					if (this.direction.x > 0) {
						this.object.transform.setRotation(0, 0, 0);
					} else {
						this.object.transform.setRotation(0, 0, 3.14);
					}
	
					this.object.transform.translate(direction.x * speed, direction.y * speed, direction.z * speed);
					this.body.syncTransform();
				}

				if (this.aliveTime > 0 && this.active) {
					this.aliveTime -= Time.delta;
				}
			}

			if (this.aliveTime <= 0) {
				this.alive = false;
				this.object.remove();
				// GameController.vehicleSystem.returnVehicle(this.object);
			}
		});

		notifyOnRemove(function() {
			GameController.vehicleSystem.unregister(this);
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

	public function getDirection(): Vec4
	{
		return this.direction;	
	}

	public function setColor(color: String) 
	{
		if (this.object.name != "Truck_M") return;
		
		var materialName = this.object.name + "_" + color;
		trace("setting " + color);
		iron.data.Data.getMaterial(iron.Scene.active.raw.name, materialName, function (mat: MaterialData) {
			trace("gotten");
			iron.Scene.active.getMesh(this.object.name).materials[0] = mat;
		});
	}

	public function setMoving(b: Bool)
	{
		moving = b;	
	}

	public function isMoving() : Bool
	{
		return moving;
	}

	public function getIsCollided(): Bool
	{
		return isCollided;	
	}

	public function setIsCollided(b: Bool)
	{
		isCollided = b;	
	}

	public function setSpeed(s: FastFloat)
	{
		speed = s;
	}

	public function getSpeed(): FastFloat
	{
		return speed;
	}
}
