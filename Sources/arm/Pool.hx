package arm;

import iron.object.Object;
import iron.Scene;

class Pool {
	private var poolSize:Int;
	private var isDynamic:Bool;
    private var objectName: String;

	private var activePool:Array<Object>;
	private var inactivePool:Array<Object>;

	public function new(pSize:Int, oName:String, ?dynamicFlag:Bool = false) {
		poolSize = pSize;
		isDynamic = dynamicFlag;
        objectName = oName;

		createInactivePool();
	}

	private function createInactivePool(): Void {
        for (i in 0...poolSize) {
            inactivePool.push(createObject());
        }
    }

    private function createObject(): Object {
        var object = null;

        Scene.active.spawnObject(
			objectName,
			null,
			function(o) {
                object = o;
			}
        );
        
        return object;
    }

	public function getObject():Null<Object> {
        var object = null;

        if (inactivePool.length > 0) {
			object = inactivePool.pop();
		} else if (isDynamic) {
            object = createObject();
        }

        // Todo some sort of a reset or re-init here?

        activePool.push(object);

        return object;
    }

    public function returnObject(o:Object): Void {
        var objectIndex = activePool.indexOf(o);

        var object = activePool.splice(objectIndex, 1);
        
    }
}
