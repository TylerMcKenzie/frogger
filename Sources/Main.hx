// Auto-generated
package ;
class Main {
    public static inline var projectName = 'frogger';
    public static inline var projectPackage = 'arm';
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 8;
        iron.object.LightObject.cascadeCount = 4;
        iron.object.LightObject.cascadeSplitFactor = 0.800000011920929;
        armory.system.Starter.main(
            '02_Frogger',
            1,
            true,
            true,
            false,
            1600,
            1080,
            1,
            true,
            armory.renderpath.RenderPathCreator.get
        );
    }
}
