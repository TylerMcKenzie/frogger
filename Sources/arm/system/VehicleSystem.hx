package arm.system;

import arm.config.VehicleType;
import iron.object.Object;
import iron.Scene;

class VehicleSystem
{
	private var objectPools:Map<VehicleType, Pool> = new Map<VehicleType, Pool>();

	public static var VEHICLES: Array<VehicleType> = [
		TRUCK_L_BROWN,
		TRUCK_L_GREEN,
		TRUCK_L_RED,
		TRUCK_M_BROWN,
		TRUCK_M_GREEN,
		TRUCK_M_RED,
		TRUCK_S_GREEN,
		TRUCK_S_BROWN,
		TRUCK_S_RED
	];

	private var vehicles: Array<Vehicle> = [];

	public function new() {}

	public function initPools()
	{
		for (vehicleType in VEHICLES) {
			// objectPools.set(vehicleType, new Pool(10, cast(vehicleType, String)));
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

		// vehicle = objectPools.get(cast(type, VehicleType)).getObject();

		return vehicle;
	}

	public function getVehicles() : Array<Vehicle>
	{
		return this.vehicles;
	}


	public function getRandomVehicle() : Object
	{
		var randIndex = Math.round(Math.random()*(VEHICLES.length-1));
		return getVehicle(VEHICLES[randIndex]);
	}

	public function register(vehicle: Vehicle)
	{
		this.vehicles.push(vehicle);
	}

	public function unregister(vehicle: Vehicle)
	{
		this.vehicles.remove(vehicle);
	}

	public function returnVehicle(v: Object) {
		objectPools.get(cast(v.name, VehicleType)).returnObject(v);
	}
}
