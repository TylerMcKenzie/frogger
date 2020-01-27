package arm.scenes;

import zui.Canvas.TElement;
import iron.object.Object;
import iron.Scene;
import iron.math.Vec2;
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

    private var maxSpawnTimeDelay: Float = 10.0;
    private var minSpawnTimeDelay: Float = 5.0;
    private var activePowerups: Array<PowerupState> = new Array<PowerupState>();

    private var scoreMultiplier: Float = 0.0;

    private var streetBounds: Map<String, Float> = new Map<String, Float>();

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

        // Hide powerup displays
        var powerUpParent = gameOverCanvas.getElement("PowerupListParent");
        powerUpParent.x = System.windowWidth() - powerUpParent.width;
        powerUpParent.y = 0;

        for (element in gameOverCanvas.getElements()) {
            if (powerUpParent.children.indexOf(element.id) != -1) {
                element.visible = false;
            }
        }

        GameController.setState("PLAYING");
        var start = Scene.active.getChild("START");
        var startLocation = start.transform.world.getLoc();
        GameController.streetSystem.createStreetPath(startLocation, 25);

        var lastStreet = GameController.streetSystem.getFinish();
        streetBounds["left"] = lastStreet.transform.worldx() - lastStreet.transform.dim.x/2;
        streetBounds["right"] = lastStreet.transform.worldx() + lastStreet.transform.dim.x/2;
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
            }
        }

        // Keep player in street bounds
        var mechBody = mech.getChild("Mech");
        var mechBodyWidthOffset = mechBody.transform.dim.x/2;
        if (mechBody.transform.worldx() + mechBodyWidthOffset >= streetBounds["right"]) {
            mech.transform.loc.x = streetBounds["right"] - mechBodyWidthOffset;
        } else if (mechBody.transform.worldx() - mechBodyWidthOffset <= streetBounds["left"]) {
            mech.transform.loc.x = streetBounds["left"] + mechBodyWidthOffset;
        }

        GameController.powerupSystem.update();
        if (GameController.powerupSystem.canSpawn()) {
            var pUp = GameController.powerupSystem.getRandomPowerupObject();
            var targetStreet = GameController.streetSystem.getFinish();
            pUp.transform.loc.x = targetStreet.transform.worldx() + (targetStreet.transform.dim.x * (Math.random() * (1 + 1) - 1)) / 2;
            pUp.transform.loc.y = targetStreet.transform.worldy();
            pUp.transform.loc.z = targetStreet.transform.worldz() + 3.5; // TODO: should this offset be based on the powerup size? or am i a sparty pants for making them a ll the same size?
            pUp.transform.buildMatrix();

            GameController.powerupSystem.setNextSpawn(Math.random() * (maxSpawnTimeDelay - minSpawnTimeDelay) + minSpawnTimeDelay);
        }
        
        // Apply powerups if we got any
        if (activePowerups.length > 0) {
            applyActivePowerups();
            drawPowerupsUi();
        }
        
        // Handle mech collisions
        var mechContacts = physics.getContacts(mechBody.getTrait(RigidBody));
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

        var active = activePowerups.filter(function(f: PowerupState) { return f.applied; });
        var inactive = activePowerups.filter(function(f:PowerupState) { return !f.applied; });

        // if there are no active powerups but we have inactive ones, apply and activate them
        if (active.length == 0 && inactive.length > 0) {
            for (inactivePowerup in inactive) {
                switch (inactivePowerup.powerup.getName()) {
                    case "boost":
                        mechControllerTrait.setRunSpeed(mechControllerTrait.getRunSpeed() + cast(inactivePowerup.powerup.getValue(), FastFloat));
                    case "agility":
                        mechControllerTrait.setStrafeSpeed(mechControllerTrait.getStrafeSpeed() + cast(inactivePowerup.powerup.getValue(), FastFloat));
                    case "double_score":
                        scoreMultiplier += 2.0;
                }

                inactivePowerup.powerup.setIsActive(true);
                inactivePowerup.applied = true;
            }
        } else {
            // if we have both active and inactive powerups, add the inactive powerups to the active ones
            for (inactivePowerup in inactive) {
                var aPowerup = active.filter(function(f: PowerupState) { return f.powerup.getName() == inactivePowerup.powerup.getName();})[0];

                if (aPowerup != null) {
                    switch (inactivePowerup.powerup.getName()) {
                        case "boost":
                            mechControllerTrait.setRunSpeed(mechControllerTrait.getRunSpeed() + cast(inactivePowerup.powerup.getValue(), FastFloat));
                        case "agility":
                            mechControllerTrait.setStrafeSpeed(mechControllerTrait.getStrafeSpeed() + cast(inactivePowerup.powerup.getValue(), FastFloat));
                        case "double_score":
                            scoreMultiplier += 2.0;
                    }
                    
                    aPowerup.powerup.addPowerupDuration(inactivePowerup.powerup.getPowerupDuration());
    
                    inactivePowerup.powerup.remove();
                    activePowerups.remove(inactivePowerup);
                } else {
                    // if there is no powerup by this name already activate this one
                    switch (inactivePowerup.powerup.getName()) {
                        case "boost":
                            mechControllerTrait.setRunSpeed(mechControllerTrait.getRunSpeed() + cast(inactivePowerup.powerup.getValue(), FastFloat));
                        case "agility":
                            mechControllerTrait.setStrafeSpeed(mechControllerTrait.getStrafeSpeed() + cast(inactivePowerup.powerup.getValue(), FastFloat));
                        case "double_score":
                            scoreMultiplier += 2.0;
                    }
    
                    inactivePowerup.powerup.setIsActive(true);
                    inactivePowerup.applied = true;
                }
            }
        }

        for (powerupState in activePowerups) {
			if (!powerupState.powerup.isActive()) {
				switch (powerupState.powerup.getName()) {
					case "boost":
						mechControllerTrait.resetRunSpeed();
					case "agility":
						mechControllerTrait.resetStrafeSpeed();
					case "double_score":
						scoreMultiplier -= 2.0;
				}

				activePowerups.remove(powerupState);
                powerupState.powerup.object.remove();
                gameOverCanvas.getElement(powerupState.powerup.object.name).visible = false;
			}
        }
    }

    private function drawPowerupsUi()
    {
        var yOffset = 0;

        for (active in activePowerups) {
            var powerupTextElement = gameOverCanvas.getElement(active.powerup.object.name);
            powerupTextElement.text = powerupTextElement.text.substring(0, powerupTextElement.text.indexOf("-") + 2) + Std.string(Math.round(active.powerup.getPowerupDurationRemaining())) + "s";
            powerupTextElement.y = yOffset;
            yOffset += powerupTextElement.height;

            powerupTextElement.visible = true;
        }
    }

    private function handleVehicleCollision(vehicleTrait: Vehicle)
    {
        vehicleTrait.setIsCollided(true);

        // Get score trait and points
        var scoreTrait = vehicleTrait.object.getTrait(Score);
        if (scoreTrait != null) {
            var multiplier = scoreMultiplier != 0 ? scoreMultiplier : 1.0;
            playerScore += scoreTrait.getScore() * multiplier;

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

    // Might need this?
    private function worldToScreen(loc: Vec4): Vec2
    {
        var v = new Vec4();
		var cam = iron.Scene.active.camera;
		if (cam != null) {
			v.setFrom(loc);
			v.applyproj(cam.V);
			v.applyproj(cam.P);
		}

		var w = System.windowWidth();
		var h = System.windowHeight();
		return new Vec2((v.x + 1) * 0.5 * w, (-v.y + 1) * 0.5 * h);
    }

    private function onRemove()
    {
        GameController.streetSystem.removeStreets();
    }
}
