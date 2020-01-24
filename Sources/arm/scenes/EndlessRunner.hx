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

    private var maxSpawnTimeDelay: Float = 3.0;
    private var minSpawnTimeDelay: Float = 1.0;
    private var activePowerups: Array<PowerupState> = new Array<PowerupState>();

    private var scoreMultiplier: Float = 1.0;

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
    }

    private function onUpdate()
    {
        // Street management
        while (GameController.streetSystem.getFinish().transform.worldy() < Math.round(mech.transform.worldy() + 294)) {
            GameController.streetSystem.addStreet();
        }
        
        var passedStreet = GameController.streetSystem.getStreets()[0];
        if (mech.transform.worldy() > passedStreet.transform.worldy() + 30) {
            passedStreet.remove();

            for (passedPowerup in GameController.powerupSystem.getPowerups()) if (passedPowerup.transform.worldy() + 30 < mech.transform.worldy() && !passedPowerup.getTrait(Powerup).isActive()) {
                passedPowerup.remove();
                trace("removed powerup");
            }
        }

        GameController.powerupSystem.update();
        if (GameController.powerupSystem.canSpawn()) {
            var pUp = GameController.powerupSystem.getRandomPowerupObject();
            var targetStreet = GameController.streetSystem.getFinish();
            pUp.transform.loc.x = targetStreet.transform.worldx() + (targetStreet.transform.dim.x * (Math.random() * (1 + 1) - 1)) / 2;
            pUp.transform.loc.y = targetStreet.transform.worldy();
            pUp.transform.loc.z = targetStreet.transform.worldz() + 2; // TODO: should this offset be based on the powerup size? or am i a sparty pants for making them a ll the same size?
            pUp.transform.buildMatrix();

            GameController.powerupSystem.setNextSpawn(Math.random() * (maxSpawnTimeDelay - minSpawnTimeDelay) + minSpawnTimeDelay);
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
                    handleVehicleCollision(vehicleTrait);
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
                    case "double_score":
                        scoreMultiplier = 2.0;
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
                        case "double_score":
                            scoreMultiplier = 1.0;
                    }
                    
                    activePowerups.remove(powerupState);
                    powerupState.powerup.object.remove();
                }
            }
        }
    }

    private function handleVehicleCollision(vehicleTrait: Vehicle)
    {
        vehicleTrait.setIsCollided(true);

        // Get score trait and points
        var scoreTrait = vehicleTrait.object.getTrait(Score);
        if (scoreTrait != null) {
            playerScore += scoreTrait.getScore() * scoreMultiplier;

            var scoreTextElement = gameOverCanvas.getElement("Score");
            scoreTextElement.text = Std.string(playerScore);
        }

        //fling the car
        var launchTrait = vehicleTrait.object.getTrait(Launchable);
        if (launchTrait != null) {
            var launchDirectionY = 1;
            
            if (mech.transform.worldx() > vehicleTrait.object.transform.worldx()) {
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
