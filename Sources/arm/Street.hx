package arm;

import iron.object.Object;
import kha.FastFloat;

class Street extends GameTrait 
{
	public static var STREET_SIZE: FastFloat = 6;
	private var system: StreetSystem;
	private var registered: Bool = false;
	private var isEnd: Bool = false;
	private var spawner: Object;


	public function new() 
	{
		super();
		// TODO ADD REMOVE FROM SYSTEM LOGIC
		notifyOnInit(function() {
			this.system = this.game.streetSystem;
		});

		notifyOnRemove(function() {
			this.system.unregister(this.object);
		});
	}

	public function getIsEnd()
	{
		return this.isEnd;
	}

	public function setIsEnd(bool: Bool)
	{
		this.isEnd = bool;
	}

	public function getSpawner() : Object
	{
		return this.spawner;
	}

	public function setSpawner(o: Object) 
	{
		this.spawner = o;
	}
}
