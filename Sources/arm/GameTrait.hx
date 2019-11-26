package arm;

import iron.Scene;

class GameTrait extends iron.Trait 
{
	public var game:GameController;

	public function new()
	{
		super();
		game = Scene.active.getTrait(GameController.getInstance());
	}
}