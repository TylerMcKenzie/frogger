package arm;

import iron.object.Object;
import iron.Scene;

class Pool {
	private var size:Int;
	private var isDynamic:Bool;

	private var activePool:Array<Object>;
	private var inactivePool:Array<Object>;

	public function new(poolSize:Int, objectName:String, ?dynamicFlag:Bool = false) {
		size = poolSize;
		isDynamic = dynamicFlag;

		createInactivePool();
	}

	private function createInactivePool(): Void {
        for (i in 0...size) {
            createObject();
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
        
        inactivePool.push(object);
            
        return object;
    }

	public function getObject():Null<Object> {
        var object = null;

        if (inactivePool.length > 0) {
			object = inactivePool.pop();
			activePool.push(object);
		} else if (dynamicFlag) {
            object = createObject();
        }

        return object;
    }

    public function returnObject(o:Object): Void {
        var objectIndex = activePool.indexOf(o);

        var object = activePool.splice(objectIndex, 1);
        object
        
    }
}
