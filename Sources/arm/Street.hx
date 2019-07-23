package arm;

import kha.FastFloat;

class Street extends GameTrait 
{
	public static var STREET_SIZE: FastFloat = 6;
	private var system: StreetSystem;
	private var registered: Bool = false;
	private var isEnd: Bool = false;

	public function new() 
	{
		super();

		notifyOnInit(function() {
			this.system = this.game.streetSystem;
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
}
