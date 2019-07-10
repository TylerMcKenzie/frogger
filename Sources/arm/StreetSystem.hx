package arm;

import iron.math.Vec4;
import iron.object.Object;

import kha.FastFloat;

@:enum
abstract STREET_TYPES(String) 
{
	var ROAD  = "Street";
	var GRASS = "Street_Grass";
}

class StreetSystem 
{
	private var game: GameSystem;
	private var streets: Array<Street> = [];

	public function new(gameSystem) 
	{
		game = gameSystem;
	}

	public function getStreet(type) : Object
	{
		var street;
		game.scene.spawnObject(
			cast(type, String), 
			null, 
			function(streetObject) {
				street = streetObject;
			}
		);

		return street;
	}

	public function createStreetPath(start: Vec4, length: Int)
	{
		var path = generatePath(start, length);

		for (i in 0...path.length) {
			var street = (i % 2 == 1) ? getStreet(ROAD) : getStreet(GRASS);
			street.transform.loc.setFrom(path[i]);
			street.transform.buildMatrix();
		}
	}

	public function register(streetSection: Street) 
	{
		streets.push(streetSection);
	}

	private function generatePath(start: Vec4, len: Int) : Array<Vec4>
	{
		var path = new Path(start);

		var pathStep = new Vec4(0, Street.STREET_SIZE, 0);
		return path.generate(pathStep, len);
	}
}
