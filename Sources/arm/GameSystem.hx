package arm;

class GameSystem extends iron.Trait 
{
	public function new() 
	{
		super();

		notifyOnInit(GameController.init);

		notifyOnUpdate(GameController.update);
	}
}
