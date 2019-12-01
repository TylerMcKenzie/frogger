package arm.scenes;

import armory.trait.internal.CanvasScript;
import armory.system.Event;
import iron.Scene;
import kha.System;

class Title extends iron.Trait
{
    private var canvas: CanvasScript;

    public function new() 
    {
        super();

        notifyOnInit(function() {
            canvas = Scene.active.getTrait(CanvasScript);

            Event.add("start", start);
            Event.add("quit", quit);
        });
    }

    public function start()
    {
        Scene.setActive("02_Frogger");
    }

    public function quit()
    {
        System.stop();
    }
}