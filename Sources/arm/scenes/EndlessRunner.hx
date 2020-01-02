package arm.scenes;

import iron.object.Object;
import iron.Scene;
import iron.math.Vec4;

class EndlessRunner extends iron.Trait {
    private var mech: Object;
    private var mechPrevPos: Vec4;

    public function new () {
        super();

        notifyOnInit(onInit);
        notifyOnUpdate(onUpdate);
        notifyOnRemove(onRemove);
    }

    private function onInit()
    {
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
        
    }

    private function onRemove()
    {
        GameController.streetSystem.removeStreets();
    }
}