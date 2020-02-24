package arm;

import iron.object.Object;
import iron.Scene;

class Pool {
	private var poolSize:Int;
	private var isDynamic:Bool;
    private var objectName: String;

	private var activePool:Array<Object> = [];
    private var inactivePool:Array<Object> = [];
    private var traitList:Array<Class<T>> [];

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

        if (traitList == null) {
            for (t in object.traits) {
                traitList.push(Type.getClass(t));
            }
        }
        
        return object;
    }

	public function getObject():Null<Object> {
        var object = null;

        if (inactivePool.length > 0) {
			object = inactivePool.pop();
		} else if (isDynamic) {
            object = createObject();
        }

        activePool.push(object);

        for (t in traitList) {
            object.addTrait(Type.createInstance(t, []));
        }

        return object;
    }

    public function returnObject(o:Object): Void {
        var objectIndex = activePool.indexOf(o);

        if (objectIndex == -1) return;

        var object = activePool.splice(objectIndex, 1);
        
        for (trait in object.traits) {
            object.removeTrait(t);
        }

        inactivePool.push(object);
    }
}
