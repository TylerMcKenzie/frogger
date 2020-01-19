package arm;

class Score extends iron.Trait
{
    @prop
    private var score: Float = 0.0;

    public function new()
    {
        super();
    }

    public function getScore(): Float
    {
        return score;
    }

    public function setScore(s: Float)
    {
        score = s;
    }
}
