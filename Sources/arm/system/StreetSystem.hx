package arm.system;

import iron.math.Vec4;
import iron.object.Object;
import iron.Scene;
import arm.config.StreetTypes;

class StreetSystem 
{
	private var streets: Array<Object> = [];

	private var path: Path;

	public function new() {}

	public function getStreet(type) : Object
	{
		var street;
		Scene.active.spawnObject(
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
			var street = null;
			var streetTrait = null;
			if (setEnd && i == path.length) {
				street = this.getStreet(GRASS);
				streetTrait = street.getTrait(Street);
			} else {
				street = (Math.round(Math.random()*2) % 2 == 1) ? this.getStreet(ROAD) : this.getStreet(GRASS);
				streetTrait = street.getTrait(Street);
			}
			street.transform.loc.setFrom(path[i]);
			street.transform.buildMatrix();


			var rand = Math.round(Math.random()*2);
			var spawnObj = null;
			
			if (rand % 2 == 1) {
				spawnObj = street.getChild("TSPAWN_L");
			} else {
				spawnObj = street.getChild("TSPAWN_R");
			}

			if (spawnObj != null) {
				streetTrait.setSpawner(spawnObj);
				var spawner = spawnObj.getTrait(VehicleSpawner);
				spawner.setActive(true);
			}
		}
	}

	public function addStreet()
	{
		var next = path.getNext();

		var street = null;
		var streetTrait = null;
		
		street = (Math.round(Math.random()*2) % 2 == 1) ? this.getStreet(ROAD) : this.getStreet(GRASS);
		streetTrait = street.getTrait(Street);

		street.transform.loc.setFrom(next);
		street.transform.buildMatrix();


		var rand = Math.round(Math.random()*2);
		var spawnObj = null;
		
		if (rand % 2 == 1) {
			spawnObj = street.getChild("TSPAWN_L");
		} else {
			spawnObj = street.getChild("TSPAWN_R");
		}

		if (spawnObj != null) {
			streetTrait.setSpawner(spawnObj);
			var spawner = spawnObj.getTrait(VehicleSpawner);
			spawner.setActive(true);
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
		path = new Path(start);

		var pathStep = new Vec4(0, Street.STREET_SIZE, 0);
		return path.generate(pathStep, len);
	}
}
