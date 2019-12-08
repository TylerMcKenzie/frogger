package arm.scenes;

import arm.config.GameState;
import armory.trait.physics.PhysicsWorld;
import armory.trait.internal.CanvasScript;
import armory.system.Event;
import iron.object.Object;
import iron.system.Input;
import iron.Scene;
import kha.System;

class Frogger extends iron.Trait
{
    private var physics: PhysicsWorld;

    private var player: Object;

    private var keyboard: Keyboard;

    private var gameOverCanvas: CanvasScript;

    public function new()
    {
        super();

        notifyOnInit(onInit);
        notifyOnUpdate(onUpdate);
        notifyOnRemove(onRemove);
    }

    public function onInit()
    {
        // These should be instanced to each scene, will need setters
        // physics = PhysicsWorld.active;
        player  = Scene.active.getChild("Player_Frog");

        // Canvas stuff
        gameOverCanvas = Scene.active.getTrait(CanvasScript);
        gameOverCanvas.setCanvasVisibility(true);
        gameOverCanvas.getElement("gameOverParent").visible = false;

        Event.add("reset-frogger", function() {
            // Wow this worked, but it feels hacky. Leaving it here until proved bad.
            Scene.setActive("02_Frogger");
        });

        Event.add("goto-main-menu", function() {
            Scene.setActive("01_Title");
        });

        GameController.setState(cast PLAYING);
        var start = Scene.active.getChild("LEVEL_START");
        var startLocation = start.transform.world.getLoc();
        GameController.streetSystem.createStreetPath(startLocation, 31);
        player.transform.loc.x = startLocation.x;
        player.transform.loc.y = startLocation.y;
        player.transform.buildMatrix();
        
        // register state change
        GameController.onStateChange(function(change) {
            // Disable spawners
            if (change.state == cast(GAME_OVER, String) && change.prevState == cast(PLAYING, String)) {
                trace("message received");
                
                var gameOverTextParent = gameOverCanvas.getElement("gameOverParent");
                gameOverTextParent.x = System.windowWidth()/2 - gameOverTextParent.width/2;
                gameOverTextParent.y = System.windowHeight()/2 - gameOverTextParent.height/2;
                gameOverTextParent.visible = true;

                for (street in GameController.streetSystem.getStreets()) {
                    var spawner = street.getTrait(Street).getSpawner();

                    if (spawner != null) {
                        trace("disabling spawners");
                        spawner.getTrait(VehicleSpawner).setActive(false);
                    }
                }
            }
        });
    }

    public function onUpdate()
    {
        if (player.getTrait(Player).isDead() == true) {
            GameController.setState(cast GAME_OVER);
        }

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
    }

    public function onRemove()
    {
        Event.remove("goto-menu");
        Event.remove("reset-frogger");
    }
}
