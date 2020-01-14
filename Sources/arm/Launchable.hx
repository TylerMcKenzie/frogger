package arm;

import iron.math.Vec4;
import kha.FastFloat;

class Launchable extends iron.Trait {
	private var isLaunched: Bool = false;

	private var launchDirection:Vec4;

	private var rotationDirection: Vec4;

	@prop
	private var launchSpeed: FastFloat = 1.0;

	@prop
	private var rotationSpeed: FastFloat = 1.0;

	public function new() {
		super();

		// notifyOnInit(function() {
		// });

		notifyOnUpdate(function() {
			if (isLaunched && launchDirection != null) {
				// do launchy things
				object.transform.move(launchDirection, launchSpeed);
				if (rotationDirection != null) {
					object.transform.rotate(rotationDirection, rotationSpeed);
				}
			}
		});

		// notifyOnRemove(function() {
		// });
	}
	
	public function getLaunchDirection(): Vec4
	{
		return launchDirection;	
	}

	public function setLaunchDirection(dir: Vec4)
	{
		launchDirection = dir;	
	}
	
	public function setLaunchSpeed(speed: FastFloat)
	{
		launchSpeed = speed;	
	}

	public function getLaunchSpeed(): FastFloat
	{
		return launchSpeed;	
	}

	public function getLaunched(): Bool
	{
		return isLaunched;	
	}

	public function setLaunched(b: Bool)
	{
		isLaunched = b;
	}

	public function setRotationDirection(dir: Vec4)
	{
		rotationDirection = dir;	
	}

	public function getRotationDirection(): Vec4
	{
		return rotationDirection;
	}

	public function setRotationSpeed(speed: FastFloat)
	{
		rotationSpeed = speed;	
	}

	public function getRotationSpeed(): FastFloat
	{
		return rotationSpeed;	
	}
}
