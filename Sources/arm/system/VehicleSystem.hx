package arm.system;

import arm.config.VehicleType;
import iron.object.Object;
import iron.Scene;

class VehicleSystem
{
	public static var VEHICLES: Array<VehicleType> = [
		TRUCK_L,
		TRUCK_M,
		TRUCK_S
	];

	private var vehicles: Array<Vehicle> = [];

	public function new() {}

	public function update()
	{
		for (vehicle in vehicles) {
			// TODO CHECK IF THEY SHOULD BE REMOVED
		}
	}

	public function getVehicle(type) : Object
	{
		var vehicle;

		Scene.active.spawnObject(
			cast(type, String),
			null,
			function(v) {
				vehicle = v;
			}
		);

		return vehicle;
	}

	public function getVehicles() : Array<Vehicle>
	{
		return this.vehicles;
	}


	public function getRandomVehicle() : Object
	{
		var randIndex = Math.round(Math.random()*(VEHICLES.length-1));
		return getVehicle(VEHICLES[2]);
	}

	public function register(vehicle: Vehicle)
	{
		this.vehicles.push(vehicle);
	}

	public function unregister(vehicle: Vehicle)
	{
		this.vehicles.remove(vehicle);
	}
}
