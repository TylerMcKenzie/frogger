package arm;

import arm.config.GAME_STATE;
import arm.system.StreetSystem;
import arm.system.VehicleSystem;

class GameController
{
    public static var streetSystem: StreetSystem = new StreetSystem();
	public static var vehicleSystem: VehicleSystem = new VehicleSystem();

	private static var state: GAME_STATE;

    public static function getState(): GAME_STATE
    {
        return state;
    }

    public static function setState(s: GAME_STATE)
	{
		state = s;
	}
}
