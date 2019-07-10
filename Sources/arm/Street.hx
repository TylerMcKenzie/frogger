package arm;

import kha.FastFloat;

class Street extends GameTrait 
{
	public static var STREET_SIZE: FastFloat = 6;
	private var system: StreetSystem;

	public function new() 
	{
		super();

		notifyOnInit(function() {
			system = game.streetSystem;

			system.register(this);
		});
	}
}
