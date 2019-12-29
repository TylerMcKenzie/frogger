package arm.scenes;

import iron.Scene;

class EndlessRunner extends iron.Trait {
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
        GameController.streetSystem.createStreetPath(startLocation, 101);
    }

    private function onUpdate()
    {

    }

    private function onRemove()
    {

    }
}