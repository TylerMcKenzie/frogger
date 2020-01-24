package arm.system;

import iron.object.Object;
import iron.Scene;
import iron.system.Time;

class PowerupSystem
{
    private var lastPowerupSpawn: Float = 0.0;

    private var nextPowerupSpawn: Float = 0.0;

    private var canSpawnPowerup: Bool = false;

    private var powerups: Array<Object> = new Array<Object>();

    public function new() {}

    public function update()
    {
        if (lastPowerupSpawn > nextPowerupSpawn) {
            lastPowerupSpawn = 0.0;
            nextPowerupSpawn = 0.0;
            canSpawnPowerup = true;
        } else {
            canSpawnPowerup = false;
            lastPowerupSpawn += Time.delta;
        }
    }

    public function getPowerupObject(powerupName: String): Object
    {
        var returnObject;

        Scene.active.spawnObject(powerupName, null, function(powerup: Object) {
            returnObject = powerup;
            register(returnObject);
        });

        return returnObject;
    }

    public function getRandomPowerupObject(): Object
    {
        var rand = Math.random();
        var randPowerUp;

        if (rand > 0.66) {
            randPowerUp = getPowerupObject("AgilityUp");
        } else if (rand < 0.66 && rand > 0.33) { 
            randPowerUp = getPowerupObject("SpeedUp");
        } else {
            randPowerUp = getPowerupObject("DoubleScore");
        }

        return randPowerUp;
    }

    public function canSpawn(): Bool
    {
        return canSpawnPowerup;
    }

    public function setNextSpawn(time: Float)
    {
        nextPowerupSpawn = time;
    }

    public function getPowerups(): Array<Object>
    {
        return powerups;
    }
    
	public function register(powerup: Object)
    {
        this.powerups.push(powerup);
    }

    public function unregister(powerup: Object)
    {
        this.powerups.remove(powerup);
    }
}
