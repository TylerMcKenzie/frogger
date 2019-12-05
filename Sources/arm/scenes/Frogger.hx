package arm.scenes;

import armory.trait.physics.PhysicsWorld;
import iron.object.Object;
import iron.system.Input;
import iron.Scene;

class Frogger extends iron.Trait
{
    private var physics: PhysicsWorld;

    private var player: Object;

    private var keyboard: Keyboard;

    public function new()
    {
        super();
        notifyOnInit(init);
        notifyOnUpdate(update);
    }

    public function init()
    {
        // These should be instanced to each scene, will need setters
        physics = PhysicsWorld.active;
        player  = Scene.active.getChild("Player_Frog");
        GameController.setState(PLAYING);
        var start = Scene.active.getChild("LEVEL_START");
        var startLocation = start.transform.world.getLoc();
        GameController.streetSystem.createStreetPath(startLocation, 31);
        player.transform.loc.x = startLocation.x;
        player.transform.loc.y = startLocation.y;
        player.transform.buildMatrix();
    }

    public function update()
    {
        if (keyboard == null ) keyboard = Input.getKeyboard();

        // MOVE THIS TO A TRAIT or adjust scene stream? camera render distance?
        // vehicle visibility logic
        for (vehicle in GameController.vehicleSystem.getVehicles()) {
            if (
                vehicle.object.transform.world.getLoc().y < player.transform.world.getLoc().y + 24
            ) {
                vehicle.object.visible = true;
            } else {
                vehicle.object.visible = false;
            }
        }

        // street visibility + spawner logic
        for (street in GameController.streetSystem.getStreets()) {
            var streetTrait = street.getTrait(Street);
            if (
                street.transform.world.getLoc().y < player.transform.world.getLoc().y + 24
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
        // MOVE THIS TO A TRAIT


        // WIN LEVEL
        var finish = GameController.streetSystem.getFinish();
        if (finish != null) {
            if (player.transform.world.getLoc().y >= finish.transform.world.getLoc().y) {
                // Show Finish screen - Canvas

                // Switch to endless mode
                // setState(GAME_2);
                trace("Go to mech mode, disable this mode.");
            }
        }

        if (player != null && player.getTrait(Player).isDead()) {
            GameController.setState(GAME_OVER);
            trace("OVER?");
        }

        var state = GameController.getState();
        switch state {
            case PLAYING:
                if (getPlayerCollision() == true) trace("message received");
            case GAME_OVER:
                // Disable spawners
                for (street in GameController.streetSystem.getStreets()) {
                    var spawner = street.getTrait(Street).getSpawner();

                    if (spawner != null) {
                        spawner.getTrait(VehicleSpawner).setActive(false);
                    }
                }

                // Show game over text
                // TODO CANVAS STUFF
                // Reset game and go back to begining
                GameController.streetSystem.removeStreets();

                player.getTrait(Player).reset();
                
                GameController.setState(PLAYING);
        }
    }
    
    private function getPlayerCollision()
    {
        var collisionObjects = physics.getContacts(player.getTrait(Player).getBody());

        if (collisionObjects != null) {
            for (cObject in collisionObjects) {
                if (cObject.object.getTrait(Vehicle) != null) {
                    trace("hit");
                    return true;
                }
            }
        }

        return false;
    }
}
