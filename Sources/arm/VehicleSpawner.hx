package arm;

import iron.math.Vec4;
import iron.system.Time;
import kha.FastFloat;

class VehicleSpawner extends GameTrait
{
	private var system: VehicleSystem;

	private var freq: FastFloat;

	private var spawnType: String;

	private var spawnDirection: String;
	private var lastSpawnTimer: FastFloat = 0;

	public function new()
	{
		super();
		system = game.vehicleSystem;

		notifyOnUpdate(function() {
			lastSpawnTimer += Time.delta;

			if (lastSpawnTimer >= freq) {
				spawnVehicle();
				lastSpawnTimer = 0;
			}
		});
	}

	private function spawnVehicle()
	{
		var vehicle = system.getRandomVehicle();
	}
}