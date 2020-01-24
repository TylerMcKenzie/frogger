package arm;

import iron.system.Time;
import iron.Trait;

class Powerup extends Trait
{
    @prop
    private var powerupName: String;

    @prop
    private var powerupDuration: Float = 0.0;
    private var durationCountDown: Float = 0.0;
    private var active: Bool = false;

    @prop
    private var value: Float;

    @prop
    private var target: String;

    public function new()
    {
        super();

        notifyOnUpdate(function() {
            
            if (durationCountDown < getPowerupDuration() && getPowerupDuration() > 0 && isActive()) {
                setIsActive(true);
                durationCountDown += Time.delta;
            } else {
                setIsActive(false);
            }
        });

        notifyOnRemove(function() {
            GameController.powerupSystem.unregister(object);
        });
    }

    public function isActive(): Bool
    {
        return active;  
    }

    public function setIsActive(b: Bool)
    {
        active = b;
    }

    public function getName(): String
    {
        return powerupName;
    }

    public function setName(n: String)
    {
        powerupName = n;
    }

    public function getValue(): Float
    {
        return value;
    }

    public function setValue(v: Float)
    {
        value = v;
    }

    public function getTarget(): String
    {
        return target;
    }

    public function setTarget(t: String)
    {
        target = t;
    }

    public function getPowerupDuration(): Float
    {
        return powerupDuration;
    }
}