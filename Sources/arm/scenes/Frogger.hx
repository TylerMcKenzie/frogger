package arm.scenes;

import armory.trait.physics.PhysicsWorld;

class Frogger extends iron.Trait
{
    private var physics: PhysicsWorld;

    public function new()
    {
        super();
        notifyonInit(init);
        notifyOnUpdate(update);
    }

    public function init()
    {
        // These should be instanced to each scene, will need setters
        physics = PhysicsWorld.active;
        player  = Scene.active.getChild("Player_Frog");
    }

    public function update()
    {
        if (keyboard == null ) keyboard = Input.getKeyboard();

        // REMOVE THIS SWITCHING TO SCENE MANAGER
        if (keyboard.started("1")) {
            setState(TITLE);
        }
        // REMOVE THIS SWITCHING TO SCENE MANAGER

        if (keyboard.started("2")) {
            setState(MENU);
        }

        if (keyboard.started("3")) {
            setState(PLAYING);
        }

        if (keyboard.started("4")) {
            setState(GAME_OVER);
        }

        // MOVE THIS TO A TRAIT or adjust scene stream? camera render distance?
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
        // MOVE THIS TO A TRAIT


        // WIN LEVEL
        var finish = streetSystem.getFinish();
        if (finish != null) {
            if (player.transform.world.getLoc().y >= finish.transform.world.getLoc().y) {
                // Show Finish screen - Canvas

                // Switch to endless mode
                setState(GAME_2);
            }
        }

        if (player != null && player.getTrait(Player).isDead()) {
            setState(GAME_OVER);
            trace("OVER?");
        }

        // switch state {
        //     case PLAYING:
        //         var start = Scene.active.getChild("LEVEL_START");
        //         var startLocation = start.transform.world.getLoc();
        //         streetSystem.createStreetPath(startLocation, 41);
        //         player.transform.loc.x = startLocation.x;
        //         player.transform.loc.y = startLocation.y;
        //         player.transform.buildMatrix();
        //     case GAME_OVER:
        //         // Disable spawners
        //         for (street in streetSystem.getStreets()) {
        //             var spawner = street.getTrait(Street).getSpawner();

        //             if (spawner != null) {
        //                 spawner.getTrait(VehicleSpawner).setActive(false);
        //             }
        //         }

        //         // Show game over text
        //         var gameOverText = Scene.active.getChild("GAME_OVER_TEXT");
        //         gameOverText.visible = true;
        //         // Reset game and go back to begining
        //         streetSystem.removeStreets();

        //         player.getTrait(Player).reset();
                
        //         setState(PLAYING);
                
        //     case GAME_2:
        //         Scene.setActive("Game 2");
        // }
    }
    
    private static function getPlayerCollision()
    {
        // TODO: move collision checks to GameController
        var collisionObjects = physics.getContacts(this.body);

        if (collisionObjects != null) {
            trace(collisionObjects.length);
            for (cObject in collisionObjects) {
                if (cObject.object.getTrait(Vehicle) != null) {
                    if (Scene.active.raw.name == "Game") this.dead = true; // IN SCENE 1
                    if (Scene.active.raw.name == "Game 2") trace("FLING CAR"); // IN SCENE 2
                }
            }
        }
    }
}
