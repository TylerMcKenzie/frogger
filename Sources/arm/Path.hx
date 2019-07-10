package arm;

import kha.FastFloat;

import iron.math.Vec4;

class Path
{
	private var origin: Vec4;

	public function new(startPosition: Vec4)
	{
		origin = startPosition;
	}

	public function generate(step: Vec4, length: Int) : Array<Vec4>
	{
		var path = [];
		var start = origin;
		
		path.push(start);
		
		for (i in 0...length) {
			var next = start.clone();
			next.add(step);

			path.push(next);
			
			start = next;
		}

		return path;
	}

}
