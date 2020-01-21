package arm.scenes;

import iron.object.Object;
import iron.Scene;
import iron.math.Vec4;
import armory.trait.internal.CanvasScript;
import armory.trait.physics.PhysicsWorld;
import armory.trait.physics.RigidBody;
import kha.System;
import kha.FastFloat;

typedef PowerupState = {
    var applied: Bool;
    var powerup: Powerup;
} 

class EndlessRunner extends iron.Trait {
    private var gameOverCanvas: CanvasScript;
    
    private var mech: Object;
    private var mechPrevPos: Vec4;

    private var physics: PhysicsWorld;

    private var playerScore: Float = 0.0;

    private var activePowerups: Array<PowerupState> = new Array<PowerupState>();

    public function new () {
        super();

        notifyOnInit(onInit);
        notifyOnUpdate(onUpdate);
        notifyOnRemove(onRemove);
    }

    private function onInit()
    {
        physics = PhysicsWorld.active;
        mech = Scene.active.getChild("MechController");
        mechPrevPos = mech.transform.world.getLoc();

        // TODO: setup pause mechanics
        // Canvas stuff
        gameOverCanvas = Scene.active.getTrait(CanvasScript);
        gameOverCanvas.setCanvasVisibility(true);

        // Show Score
        var scoreElement = gameOverCanvas.getElement("ScoreParent");
        scoreElement.x = 50;
        scoreElement.y = 50;
        scoreElement.visible = true;

        GameController.setState("PLAYING");
        var start = Scene.active.getChild("START");
        var startLocation = start.transform.world.getLoc();
        GameController.streetSystem.createStreetPath(startLocation, 25);

        Scene.active.spawnObject("AgilityUp", null, function (o: Object) {
            o.transform.loc.setFrom(startLocation);
            o.transform.loc.add(new Vec4(0, 55, 1.5));
            o.transform.buildMatrix();
        });

        Scene.active.spawnObject("SpeedUp", null, function (o: Object) {
            o.transform.loc.setFrom(startLocation);
            o.transform.loc.add(new Vec4(0, 105, 1.5));
            o.transform.buildMatrix();
        });
    }

    private function onUpdate()
    {
        // Street management
        if (mech.transform.world.getLoc().y - 6 > mechPrevPos.y) {
            GameController.streetSystem.addStreet();
            mechPrevPos = mech.transform.world.getLoc();

            var passedStreet = GameController.streetSystem.getStreets()[0];
            if (mech.transform.world.getLoc().y > passedStreet.transform.world.getLoc().y + 12) {
                passedStreet.remove();
            }
        }
        
        // Apply powerups if we got any
        if (activePowerups.length > 0) {
            applyActivePowerups();
        }
        
        // Handle mech collisions
        var mechContacts = physics.getContacts(mech.getChild("Mech").getTrait(RigidBody));
        if (mechContacts != null) {
            for (mechContact in mechContacts) {
                // Add powerup to powerup list
                // check this first incase a score bonus is applied, player gets that immediately
                var powerUp = mechContact.object.getTrait(Powerup);
                if (powerUp != null) {
                    if (powerUp.object.visible == true) {
                        activePowerups.push({
                            applied: false,
                            powerup: powerUp
                        });
                        
                        powerUp.object.visible = false;
                    }
                }
                
                // vehicle collision detection
                var vehicleTrait = mechContact.object.getTrait(Vehicle);
                if (vehicleTrait != null  && vehicleTrait.getIsCollided() == false) {
                    handleVehicleCollision(vehicleTrait, mechContact);
                }
            }
        }
    }

    private function applyActivePowerups()
    {
        var mechControllerTrait = mech.getTrait(MechController);

        for (powerupState in activePowerups) {
            if (!powerupState.applied) {
                switch (powerupState.powerup.getName()) {
                    case "boost":
                        mechControllerTrait.setRunSpeed(mechControllerTrait.getRunSpeed() + cast(powerupState.powerup.getValue(), FastFloat));
                    case "agility":
                        mechControllerTrait.setStrafeSpeed(mechControllerTrait.getStrafeSpeed() + cast(powerupState.powerup.getValue(), FastFloat));
                }

                powerupState.powerup.setIsActive(true);
                powerupState.applied = true;
            } else {
                if (!powerupState.powerup.isActive()) {
                    switch (powerupState.powerup.getName()) {
                        case "boost":
                            mechControllerTrait.resetRunSpeed();
                        case "agility":
                            mechControllerTrait.resetStrafeSpeed();
                    }
                    
                    activePowerups.remove(powerupState);
                    powerupState.powerup.object.remove();
                }
            }
        }
    }

    private function handleVehicleCollision(vehicleTrait, contactRb)
    {
        vehicleTrait.setIsCollided(true);

        // Get score trait and points
        var scoreTrait = contactRb.object.getTrait(Score);
        if (scoreTrait != null) {
            playerScore += scoreTrait.getScore();

            var scoreTextElement = gameOverCanvas.getElement("Score");
            scoreTextElement.text = Std.string(playerScore);
        }

        //fling the car
        var launchTrait = contactRb.object.getTrait(Launchable);
        if (launchTrait != null) {
            var launchDirectionY = 1;
            
            if (mech.transform.worldx() > contactRb.object.transform.worldx()) {
                launchDirectionY = -1;
            }

            vehicleTrait.setMoving(false);

            launchTrait.setLaunchDirection(new Vec4(launchDirectionY, 1, 1));
            launchTrait.setLaunchSpeed(vehicleTrait.getSpeed());

            launchTrait.setRotationDirection(new Vec4(0, launchDirectionY, 1));
            launchTrait.setRotationSpeed(0.1);
            launchTrait.setLaunched(true);
        }
    }

    private function onRemove()
    {
        GameController.streetSystem.removeStreets();
    }
}
