package arm;

import iron.math.Vec4;
import iron.system.Time;
import kha.FastFloat;

class VehicleSpawner extends iron.Trait
{
	@prop
	private var spawnFrequency: FastFloat = -1.0;

	@prop
	private var spawnDirectionX: FastFloat = 0.0;

	@prop
	private var spawnDirectionY: FastFloat = 0.0;

	@prop
	private var spawnDirectionZ: FastFloat = 0.0;

	@prop
	private var isRandomFrequency: Bool = false;

	@prop
	private var active: Bool = false;

	private var spawnDirection: Vec4;

	private var spawnType: String;
	private var lastSpawnTimer: FastFloat = 0;

	public function new()
	{
		super();

		if (this.spawnFrequency == -1) {
			this.isRandomFrequency = true;
			this.spawnFrequency = this.randomFreq();

		}

		notifyOnUpdate(function() {
			if (this.active != true || GameController.getState() == "PAUSED") {
				return;
			}

			this.lastSpawnTimer += Time.delta;

			if (this.lastSpawnTimer >= this.spawnFrequency) {
				// Todo add random spawn frequency
				this.spawnVehicle();

				this.lastSpawnTimer = 0;

				if (this.isRandomFrequency) {
					this.spawnFrequency = this.randomFreq();
				}
			}
		});
	}

	public function getActive(): Bool
	{
		return this.active;
	}

	public function setActive(active: Bool)
	{
		this.active = active;
	}

	public function reset()
	{
		this.isRandomFrequency = false;
		this.active = false;
		this.spawnDirection = null;
		this.lastSpawnTimer = 0;
	}

	private function randomFreq()
	{
		return Math.random()*(3 - 0.5) + 0.5;
	}

	private function spawnVehicle()
	{
		var vehicleObject = GameController.vehicleSystem.getRandomVehicle();
		var vehicleTrait = vehicleObject.getTrait(Vehicle);
		var spawnLoc = object.transform.world.getLoc();
		vehicleObject.transform.loc.set(spawnLoc.x, spawnLoc.y, vehicleObject.transform.loc.z);
		vehicleObject.transform.buildMatrix();
		vehicleTrait.setDirection(
			new Vec4(
				this.spawnDirectionX, 
				this.spawnDirectionY, 
				this.spawnDirectionZ
			)
		);
		vehicleTrait.setLifeTime(3.25);
		vehicleTrait.setActive(true);

		switch (Math.round(Math.random()*3)) {
			case 0: 
				vehicleTrait.setColor("red");
			case 1:
				vehicleTrait.setColor("green");
			case 2:
				vehicleTrait.setColor("brown");
			case _:
				vehicleTrait.setColor("red");
		}
	}
}
