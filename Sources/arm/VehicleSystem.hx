package arm;

import iron.object.Object;

@:enum
abstract VEHICLE_TYPE(String)
{
	var TRUCK_L      = "Truck_L";
	var TRUCK_M      = "Truck_M";
	var TRUCK_S      = "Truck_S";
}

class VehicleSystem
{
	public static var VEHICLES: Array<VEHICLE_TYPE> = [
		TRUCK_L,
		TRUCK_M,
		TRUCK_S
	];

	private var game: GameSystem;

	private var vehicles: Array<Vehicle> = [];

	public function new(gameSystem: GameSystem)
	{
		this.game = gameSystem;
	}

	public function update()
	{
		for (vehicle in vehicles) {
			// TODO CHECK IF THEY SHOULD BE REMOVED
		}
	}

	public function getVehicle(type) : Object
	{
		var vehicle;

		this.game.scene.spawnObject(
			cast(type, String),
			null,
			function(v) {
				vehicle = v;
			}
		);

		return vehicle;
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
}
