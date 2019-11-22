package arm;

import iron.math.Vec4;
import iron.Scene;
import iron.object.Object;
import arm.Enum.GAME_STATE;

class GameSystem extends iron.Trait 
{
	public var state: GAME_STATE;
	public var scene: Scene;
	public var streetSystem: StreetSystem;
	public var vehicleSystem: VehicleSystem;

	private var menuObjects = [];
	private var player: Object;
	private var titleObjects = [];
	private var gameObjects = [];

	public function new() 
	{
		super();
		scene         = Scene.active;
		streetSystem  = new StreetSystem(this);
		vehicleSystem = new VehicleSystem(this);

		notifyOnInit(function() {
			player = scene.getChild("Player_Frog");
			getMenuObjects();
			getTitleObjects();
			getGameObjects();
		});

		notifyOnUpdate(function() {
			var kb = iron.system.Input.getKeyboard();
			//DEBUG
			if (kb.started("1")) {
				setState(TITLE);
			}

			if (kb.started("2")) {
				setState(MENU);
			}

			if (kb.started("3")) {
				setState(PLAYING);
			}

			if (kb.started("4")) {
				setState(GAME_OVER);
			}

			if (kb.started("5")) {
				var spawnLoc = new Vec4(0,0,0);
				var v = vehicleSystem.getRandomVehicle();
				v.transform.loc.setFrom(spawnLoc);
				v.transform.buildMatrix();
				var vehicleTrait = v.getTrait(Vehicle);
				vehicleTrait.setDirection(new Vec4(0, -1, 0));
				vehicleTrait.setActive(true);
			}

			// vehicle visibility logic
			for (vehicle in vehicleSystem.getVehicles()) {
				if (
					vehicle.object.transform.world.getLoc().y < player.transform.world.getLoc().y + 24
				) {
					vehicle.object.visible = true;
				} else {
					vehicle.object.visible = false;
				}
			}

			// street visibility + spawner logic
			for (street in streetSystem.getStreets()) {
				var streetTrait = street.getTrait(Street);
				if (
					street.transform.world.getLoc().y < player.transform.world.getLoc().y + 48
				) {
					// Activate spawns
					if (streetTrait.getSpawner() != null) {
						street.visible = true;
						streetTrait.getSpawner().getTrait(VehicleSpawner).setActive(true);
					}
				} else {
					if (streetTrait.getSpawner() != null) {
						street.visible = false;
						streetTrait.getSpawner().getTrait(VehicleSpawner).setActive(false);
					}
				}

				if (player.transform.world.getLoc().y - 12 > street.transform.world.getLoc().y) {
					street.remove();
				}
			}

			// WIN LEVEL
			var finish = streetSystem.getFinish();
			if (finish != null) {
				if (player.transform.world.getLoc().y >= finish.transform.world.getLoc().y) {
					// Show Finish screen

					// Switch to endless mode
					this.setState(GAME_2);
				}
			}

			if (player != null && player.getTrait(Player).isDead()) {
				this.setState(GAME_OVER);
				trace("OVER?");
			}
		});
	}

	private function setState(s: GAME_STATE)
	{
		state = s;

		switch state {
				case TITLE:
					hideGameObjects();
					hideMenuObjects();

					showTitleObjects();
				case MENU:
					hideGameObjects();
					hideTitleObjects();

					showMenuObjects();
				case PLAYING:
					hideTitleObjects();
					hideMenuObjects();
					showGameObjects();

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
					
					this.setState(PLAYING);
					
				case GAME_2:
					Scene.setActive("Game 2");
			}
	}

	private function hideMenuObjects() 
	{
		for (mo in menuObjects) {
			mo.visible = false;
		}
	}

	private function showMenuObjects() 
	{
		for (mo in menuObjects) {
			mo.visible = true;
		}
	}

	private function getMenuObjects() 
	{
		menuObjects.push(scene.getChild("EXIT_TEXT"));
		menuObjects.push(scene.getChild("START_GAME_TEXT"));
	}

	private function hideTitleObjects() 
	{
		for (to in titleObjects) {
			to.visible = false;
		}
	}

	private function showTitleObjects() 
	{
		for (to in titleObjects) {
			to.visible = true;
		}
	}

	private function getTitleObjects() 
	{
		titleObjects.push(scene.getChild("Title"));
		titleObjects.push(scene.getChild("Title_Frog"));
		for (titleStreet in scene.getGroup("TITLE_STREETS")) {
			titleObjects.push(titleStreet);
		}
	}

	private function hideGameObjects() 
	{
		for (go in gameObjects) {
			go.visible = false;
		}
	}

	private function showGameObjects() 
	{
		for (go in gameObjects) {
			go.visible = true;
		}
	}
	
	private function getGameObjects() 
	{
		gameObjects.push(player);
		gameObjects.push(scene.getChild("Street"));
		gameObjects.push(scene.getChild("Street_Grass"));
	}
}
