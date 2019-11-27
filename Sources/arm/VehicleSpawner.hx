package arm;

import arm.system.VehicleSystem;
import iron.math.Vec4;
import iron.system.Time;
import kha.FastFloat;

class VehicleSpawner extends GameTrait
{
	private var system: VehicleSystem;

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
		this.system = this.game.vehicleSystem;

		if (this.spawnFrequency == -1) {
			this.isRandomFrequency = true;
			this.spawnFrequency = this.randomFreq();

		}

		notifyOnUpdate(function() {
			if (this.active != true) {
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

	override public function reset()
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
		var vehicleObject = this.system.getRandomVehicle();
		var vehicleTrait = vehicleObject.getTrait(Vehicle);
		vehicleObject.transform.loc.setFrom(object.transform.world.getLoc());
		vehicleObject.transform.buildMatrix();
		vehicleTrait.setDirection(
			new Vec4(
				this.spawnDirectionX, 
				this.spawnDirectionY, 
				this.spawnDirectionZ
			)
		);
		vehicleTrait.setLifeTime(8);
		vehicleTrait.setActive(true);
	}
}
