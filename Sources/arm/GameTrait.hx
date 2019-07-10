package arm;

import iron.Scene;

class GameTrait extends iron.Trait 
{
	public var game:GameSystem;

	public function new()
	{
		super();
		game = Scene.active.getTrait(GameSystem);
	}
}