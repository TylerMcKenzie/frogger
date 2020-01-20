package arm;

import iron.Trait;

class Powerup extends Trait
{
    @prop
    private var powerupName: String;

    @prop
    private var powerupDuration: Float = 0.0;

    @prop
    private var value: String;

    @prop
    private var target: String;

    public function new()
    {
        super();

        notifyOnInit(function() {

        });

        notifyOnUpdate(function() {

        });
    }

    public function getName(): String
    {
        return powerupName;
    }

    public function setName(n: String)
    {
        powerupName = n;
    }

    public function getValue(): String
    {
        return value;
    }

    public function setValue(v: String)
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
}