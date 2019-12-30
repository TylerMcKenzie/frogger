package arm.scenes;

import iron.Scene;
import iron.system.Time;

class EndlessRunner extends iron.Trait {
    private var time = 0.0;

    public function new () {
        super();

        notifyOnInit(onInit);
        notifyOnUpdate(onUpdate);
        notifyOnRemove(onRemove);
    }

    private function onInit()
    {
        GameController.setState("PLAYING");
        var start = Scene.active.getChild("START");
        var startLocation = start.transform.world.getLoc();
        GameController.streetSystem.createStreetPath(startLocation, 1);
    }

    private function onUpdate()
    {
        time += Time.delta;
        if (time > 0.25) {
            trace("one");
            GameController.streetSystem.addStreet();
            time = 0;
        }
    }

    private function onRemove()
    {

    }
}