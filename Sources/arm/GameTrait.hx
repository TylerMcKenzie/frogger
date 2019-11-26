package arm;

class GameTrait extends iron.Trait 
{
	public var game: GameController;

	public function new()
	{
		super();
		game = GameController.getInstance();
	}
}
