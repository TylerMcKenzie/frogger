package arm.system;

import iron.math.Vec4;
import iron.object.Object;

import armory.system.Event;
import arm.config.STREET_TYPES;

class StreetSystem 
{
	private var game: GameController;
	private var streets: Array<Object> = [];

	public function new(gameController) 
	{
		this.game = gameController;
	}

	public function getStreet(type) : Object
	{
		var street;
		this.game.getScene().spawnObject(
			cast(type, String), 
			null, 
			function(streetObject) {
				street = streetObject;
				this.register(street);
			}
		);

		return street;
	}

	public function getFinish()
	{
		return this.streets[this.streets.length-1];
	}

	public function createStreetPath(start: Vec4, length: Int, setEnd: Bool = false)
	{
		var path = this.generatePath(start, length);

		for (i in 0...path.length) {
			var street = (i % 2 == 1) ? this.getStreet(ROAD) : this.getStreet(GRASS);
			street.transform.loc.setFrom(path[i]);
			street.transform.buildMatrix();
			var streetTrait = street.getTrait(Street);

			if (setEnd && i == path.length) {
				streetTrait.setIsEnd(true);
			}

			var rand = Math.round(Math.random()*2);
			var spawnObj = null;
			
			if (rand % 2 == 1) {
				spawnObj = street.getChild("TSPAWN_L");
			} else {
				spawnObj = street.getChild("TSPAWN_R");
			}

			if (spawnObj != null) {
				streetTrait.setSpawner(spawnObj);
				// var spawner = spawnObj.getTrait(VehicleSpawner);
				// spawner.setActive(true);
			}
		}
	}

	public function removeStreets()
	{
		for (street in this.getStreets()) {
			street.remove();
		}
	}

	public function getStreets(): Array<Object>
	{
		return this.streets;
	}

	public function register(streetSection: Object) 
	{
		this.streets.push(streetSection);
	}

	public function unregister(street){
		this.streets.remove(street);
	}

	private function generatePath(start: Vec4, len: Int) : Array<Vec4>
	{
		var path = new Path(start);

		var pathStep = new Vec4(0, Street.STREET_SIZE, 0);
		return path.generate(pathStep, len);
	}
}
