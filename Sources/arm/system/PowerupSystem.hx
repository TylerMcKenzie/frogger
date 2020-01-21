package arm.system;

import iron.Scene;

class PowerupSystem
{
    public function new() {}

    public function getPowerupObject(powerupName: String): Powerup
    {
        var returnObject;

        Scene.active.spawnObject(powerupName, null, function(powerup: Object) {
            returnObject = powerup
        });

        return returnObject;
    }
}
