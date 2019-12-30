package arm;

import arm.config.GameState;
import arm.system.StreetSystem;
import arm.system.VehicleSystem;


typedef TStateChange = {
    var prevState: String;
    var state: String;
}

class GameController
{
    public static var streetSystem: StreetSystem = new StreetSystem();
	public static var vehicleSystem: VehicleSystem = new VehicleSystem();

	private static var state: String;

    private static var listeners: Array<TStateChange->Void> = new Array<TStateChange->Void>();

    public static function getState(): String
    {
        return state;
    }

    public static function setState(s: String)
	{
        var stateChange: TStateChange = { prevState: state, state: s };
		state = s;

        for (listener in listeners) {
            listener(stateChange);
        }
	}

    public static function onStateChange(callback: TStateChange->Void)
    {
        listeners.push(callback);
    }

    public static function clearListeners()
    {
        listeners = new Array<TStateChange->Void>();
    }
}
