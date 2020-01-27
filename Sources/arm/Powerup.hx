package arm;

import iron.math.Vec4;
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

    private var animationZCounter: Float = 0.0;
    private var animationZOffset: Float = 1.5;
    private var animationZSpeed: Float = 0.05;
    private var animationZDirection: Int = 1;

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

            if (animationZCounter >= animationZOffset / 2) {
                animationZDirection = -1;
            } else if (animationZCounter <= -(animationZOffset / 2)) {
                animationZDirection = 1;
            }

            animationZCounter += animationZSpeed*animationZDirection;
            
            object.transform.rotate(new Vec4(0, 0, 1), 0.075);
            object.transform.translate(0, 0, animationZSpeed*animationZDirection);
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


    public function getPowerupDurationRemaining(): Float
    {
        return durationCountDown;
    }
    
    public function addPowerupDuration(dur: Float) {
        durationCountDown -= dur;
    }
}