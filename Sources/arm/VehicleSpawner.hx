package arm;

import iron.math.Vec4;
import iron.system.Time;
import kha.FastFloat;

class VehicleSpawner extends iron.Trait
{
	@prop
	private var spawnFrequency: Float = -1.0;

	@prop
	private var spawnDirectionX: Float = 0.0;

	@prop
	private var spawnDirectionY: Float = 0.0;

	@prop
	private var spawnDirectionZ: Float = 0.0;

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
		return Math.random()*(4 - 1.25) + 1.25;
	}

	private function spawnVehicle()
	{
		var vehicleObject = GameController.vehicleSystem.getRandomVehicle();
		if (vehicleObject != null) {
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
		}
	}
}
