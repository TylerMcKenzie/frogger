package arm.system;

import iron.Scene;
import iron.object.Object;

class PowerupSystem
{
    public function new() {}

    public function getPowerupObject(powerupName: String): Object
    {
        var returnObject;

        Scene.active.spawnObject(powerupName, null, function(powerup: Object) {
            returnObject = powerup;
        });

        return returnObject;
    }
}
