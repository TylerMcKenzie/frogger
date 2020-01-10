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
            }
        }
    }

    private function onRemove()
    {
        GameController.streetSystem.removeStreets();
    }
}