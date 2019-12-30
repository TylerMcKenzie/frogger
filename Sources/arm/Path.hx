package arm;

import kha.FastFloat;

import iron.math.Vec4;

class Path
{
	private var origin: Vec4;

	private var path: Array<Vec4> = new Array<Vec4>();

	private var pathStep: Vec4;

	public function new(startPosition: Vec4)
	{
		origin = startPosition;
	}

	public function generate(step: Vec4, length: Int) : Array<Vec4>
	{
		pathStep = step;

		var start = origin;
		
		path.push(start);
		for (i in 0...length) {
			var next = start.clone();
			next.add(pathStep);

			path.push(next);
			
			start = next;
		}

		return path;
	}

	public function getNext(): Vec4
	{
		if (path.length == 0) return null;

		var last = path[path.length-1];
		var next = last.clone();
		next.add(pathStep);

		path.push(next);
		return next;
	}
}
