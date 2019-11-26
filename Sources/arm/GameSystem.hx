package arm;

import iron.math.Vec4;
import iron.Scene;
import iron.object.Object;
import arm.GameController;

class GameSystem extends iron.Trait 
{
	public function new() 
	{
		super();

		notifyOnInit(GameController.init);

		notifyOnUpdate(GameController.update);
	}
}
