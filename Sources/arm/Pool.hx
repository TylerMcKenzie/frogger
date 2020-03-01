package arm;

import armory.trait.physics.RigidBody;
import iron.object.Object;
import iron.Scene;
import iron.Trait;


class Pool {
	private var poolSize:Int;
	private var isDynamic:Bool;
    private var objectName: String;

	private var activePool:Array<Object> = [];
    private var inactivePool:Array<Object> = [];
    private var traitList:Array<Class<Trait>> = [];

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

        if (traitList.length == 0) {
            for (t in object.traits) if (Type.getClass(t) != RigidBody) {
                traitList.push(Type.getClass(t));
            }
        }
        
        return object;
    }

	public function getObject():Null<Object> {
        var object = null;

        if (inactivePool.length > 0) {
            object = inactivePool.pop();
            trace(inactivePool.length);
            trace(activePool.length);
		} else if (isDynamic) {
            object = createObject();
        } else {
            return null;
        }

        activePool.push(object);
        
        for (t in traitList) {
            // object.addTrait(Type.createInstance(t, []));
        }

        object.visible = true;

        return object;
    }

    public function returnObject(o:Object): Void {
        var objectIndex = activePool.indexOf(o);

        if (objectIndex == -1) return;

        var object = activePool.splice(objectIndex, 1)[0];
        object.visible = false;
        for (trait in object.traits) if (Type.getClass(trait) != RigidBody) {
            object.removeTrait(trait);
            object.addTrait(Type.createInstance(Type.getClass(trait), []));
        }

        inactivePool.push(object);
    }
}
