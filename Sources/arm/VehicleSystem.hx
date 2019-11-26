package arm;

import iron.object.Object;

class VehicleSystem
{
	public static var VEHICLES: Array<VEHICLE_TYPE> = [
		TRUCK_L,
		TRUCK_M,
		TRUCK_S
	];

	private var game: GameController;

	private var vehicles: Array<Vehicle> = [];

	public function new(gameController: GameController)
	{
		this.game = gameController;
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

		this.game.getScene().spawnObject(
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
