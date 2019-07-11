package arm;

import iron.math.Vec4;
import iron.system.Time;
import kha.FastFloat;

class VehicleSpawner extends GameTrait
{
	private var system: VehicleSystem;

	@prop
	private var spawnFrequency: FastFloat;

	@prop
	private var spawnDirectionX: FastFloat = 0.0;

	@prop
	private var spawnDirectionY: FastFloat = 0.0;

	@prop
	private var spawnDirectionZ: FastFloat = 0.0;

	private var spawnDirection: Vec4;

	private var spawnType: String;
	private var lastSpawnTimer: FastFloat = 0;

	public function new()
	{
		super();
		system = game.vehicleSystem;

		if (spawnFrequency == null) {
			spawnFrequency = 5;
		}

		notifyOnUpdate(function() {
			lastSpawnTimer += Time.delta;

			if (lastSpawnTimer >= spawnFrequency) {
				// Todo add random spawn frequency
				spawnVehicle();
				lastSpawnTimer = 0;
			}
		});
	}

	private function spawnVehicle()
	{
		var vehicleObject = system.getRandomVehicle();
		var vehicleTrait = vehicleObject.getTrait(Vehicle);
		vehicleObject.transform.loc.setFrom(object.transform.world.getLoc());
		vehicleObject.transform.buildMatrix();
		vehicleTrait.setDirection(
			new Vec4(
				spawnDirectionX, 
				spawnDirectionY, 
				spawnDirectionZ
			)
		);
		vehicleTrait.setLifeTime(5);
		vehicleTrait.setActive(true);
	}
}
