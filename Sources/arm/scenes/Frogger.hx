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
        keyboard = Input.getKeyboard();
        // Canvas stuff
        gameOverCanvas = Scene.active.getTrait(CanvasScript);
        gameOverCanvas.setCanvasVisibility(true);
        gameOverCanvas.getElement("gameOverParent").visible = false;

        Event.add("reset-frogger", function() {
            // Wow this worked, but it feels hacky. Leaving it here until proved bad.
            Scene.setActive(Scene.active.raw.name);
        });

        Event.add("goto-main-menu", function() {
            Scene.setActive("01_Title");
        });

        Event.add("unpause", function() {
            GameController.setState(cast PLAYING);
        });

        GameController.setState(cast PLAYING);
        var start = Scene.active.getChild("LEVEL_START");
        var startLocation = start.transform.world.getLoc();
        GameController.streetSystem.createStreetPath(startLocation, 31, true);
        
        // register state change
        GameController.onStateChange(function(change) {
            // Disable spawners
            if (change.state == "GAME_OVER") {
                var gameOverTextParent = gameOverCanvas.getElement("gameOverParent");
                gameOverTextParent.x = System.windowWidth()/2 - gameOverTextParent.width/2;
                gameOverTextParent.y = System.windowHeight()/2 - gameOverTextParent.height/2;
                gameOverTextParent.visible = true;

                for (street in GameController.streetSystem.getStreets()) {
                    var spawner = street.getTrait(Street).getSpawner();

                    if (spawner != null) {
                        spawner.getTrait(VehicleSpawner).setActive(false);
                    }
                }
            }
            
            if (change.state == "PAUSED") {
                var pausedElementParent = gameOverCanvas.getElement("pausedParent");
                pausedElementParent.x = System.windowWidth()/2 - pausedElementParent.width/2;
                pausedElementParent.y = System.windowHeight()/2 - pausedElementParent.height/2;
                pausedElementParent.visible = true;
            } else if (change.prevState == "PAUSED") {
                gameOverCanvas.getElement("pausedParent").visible = false;
            }
        });
    }

    public function onUpdate()
    {
        if (GameController.getState() == "GAME_OVER") {
            return;
        }
        // trace(keyboard);
        if (keyboard.started("escape") || keyboard.started("q")) {
            GameController.setState("PAUSED");
        }

        if (GameController.getState() == "PAUSED") {
            return;
        }

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

        // WIN LEVEL
        var finish = GameController.streetSystem.getFinish();
        if (finish != null) {
            if (player.transform.world.getLoc().y >= finish.transform.world.getLoc().y) {
                // Show Level Finish screen - Canvas

                // Switch to endless mode
                Scene.setActive("03_Runner");
            }
        }
    }

    public function onRemove()
    {
        Event.remove("goto-menu");
        Event.remove("reset-frogger");
        Event.remove("unpause");
        GameController.clearListeners();
    }
}
