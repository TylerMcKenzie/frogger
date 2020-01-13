package arm.scenes;

import iron.object.Object;
import iron.Scene;
import iron.math.Vec4;
import armory.trait.physics.PhysicsWorld;
import armory.trait.physics.RigidBody;

class EndlessRunner extends iron.Trait {
    private var mech: Object;
    private var mechPrevPos: Vec4;

    private var physics: PhysicsWorld;

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

        GameController.setState("PLAYING");
        var start = Scene.active.getChild("START");
        var startLocation = start.transform.world.getLoc();
        GameController.streetSystem.createStreetPath(startLocation, 25);
    }

    private function onUpdate()
    {
        if (mech.transform.world.getLoc().y - 6 > mechPrevPos.y) {
            GameController.streetSystem.addStreet();
            mechPrevPos = mech.transform.world.getLoc();

            var passedStreet = GameController.streetSystem.getStreets()[0];
            if (mech.transform.world.getLoc().y > passedStreet.transform.world.getLoc().y + 12) {
                passedStreet.remove();
            }
        }
        
        var mechContacts = physics.getContacts(mech.getChild("Mech").getTrait(RigidBody));

        if (mechContacts != null) {
            for (mechContact in mechContacts) {
                // mech collision detection
                var vehicleTrait = mechContact.object.getTrait(Vehicle);
                if (vehicleTrait != null  && vehicleTrait.getIsCollided() == false) {
                    vehicleTrait.setIsCollided(true);
                    //fling the car
                    var launchTrait = mechContact.object.getTrait(Launchable);
                    if (launchTrait != null) {
                        var vehicleDirection = vehicleTrait.getDirection();
                        var launchRotationY = 1;
                        if (mech.transform.worldx() > mechContact.object.transform.worldx()) {
                            launchRotationY = -1;
                        }
                        vehicleTrait.setMoving(false);

                        launchTrait.setLaunchDirection(new Vec4(vehicleTrait.getSpeed() * launchRotationY, 1, 1));
                        launchTrait.setLaunchSpeed(0.5);


                        launchTrait.setRotationDirection(new Vec4(0, launchRotationY, 1));
                        launchTrait.setRotationSpeed(0.1);
                        launchTrait.setLaunched(true);
                    }
                }
            }
        }
    }

    private function onRemove()
    {
        GameController.streetSystem.removeStreets();
    }
}