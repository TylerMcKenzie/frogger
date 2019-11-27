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

		switch state {
            case PLAYING:
                var start = scene.getChild("LEVEL_START");
                var startLocation = start.transform.world.getLoc();
                streetSystem.createStreetPath(startLocation, 41);
                player.transform.loc.x = startLocation.x;
                player.transform.loc.y = startLocation.y;
                player.transform.buildMatrix();
            case GAME_OVER:
                // Disable spawners
                for (street in streetSystem.getStreets()) {
                    var spawner = street.getTrait(Street).getSpawner();

                    if (spawner != null) {
                        spawner.getTrait(VehicleSpawner).setActive(false);
                    }
                }

                // Show game over text
                var gameOverText = scene.getChild("GAME_OVER_TEXT");
                gameOverText.visible = true;
                // Reset game and go back to begining
                streetSystem.removeStreets();

                player.getTrait(Player).reset();
                
                setState(PLAYING);
                
            case GAME_2:
                Scene.setActive("Game 2");
        }
	}
}
