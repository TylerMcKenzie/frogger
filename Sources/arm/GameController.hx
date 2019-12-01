package arm;

import arm.config.GameState;
import arm.system.StreetSystem;
import arm.system.VehicleSystem;

class GameController
{
    public static var streetSystem: StreetSystem = new StreetSystem();
	public static var vehicleSystem: VehicleSystem = new VehicleSystem();

	private static var state: GameState;

    public static function getState(): GameState
    {
        return state;
    }

    public static function setState(s: GameState)
	{
		state = s;
	}
}
