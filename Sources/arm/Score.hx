package arm;

import kha.FastFloat;

class Score extends iron.Trait
{
    @prop
    private var score: FastFloat = 0.0;

    public function new()
    {
        super();
    }

    public function getScore(): FastFloat
    {
        return score;
    }

    public function setScore(s: FastFloat)
    {
        score = s;
    }
}
