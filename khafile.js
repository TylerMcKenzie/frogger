// Auto-generated
let project = new Project('frogger');

project.addSources('Sources');
project.addLibrary("/home/tyler/armory_ext/armsdk/armory");
project.addLibrary("/home/tyler/armory_ext/armsdk/iron");
project.addLibrary("/home/tyler/armory_ext/armsdk/lib/haxebullet");
project.addAssets("/home/tyler/armory_ext/armsdk/lib/haxebullet/ammo/ammo.wasm.js", { notinlist: true });
project.addAssets("/home/tyler/armory_ext/armsdk/lib/haxebullet/ammo/ammo.wasm.wasm", { notinlist: true });
project.addParameter('arm.Launchable');
project.addParameter("--macro keep('arm.Launchable')");
project.addParameter('arm.MechController');
project.addParameter("--macro keep('arm.MechController')");
project.addParameter('arm.Score');
project.addParameter("--macro keep('arm.Score')");
project.addParameter('arm.scenes.Frogger');
project.addParameter("--macro keep('arm.scenes.Frogger')");
project.addParameter('arm.Vehicle');
project.addParameter("--macro keep('arm.Vehicle')");
project.addParameter('arm.Player');
project.addParameter("--macro keep('arm.Player')");
project.addParameter('arm.Street');
project.addParameter("--macro keep('arm.Street')");
project.addParameter('arm.VehicleSpawner');
project.addParameter("--macro keep('arm.VehicleSpawner')");
project.addParameter('armory.trait.FollowCamera');
project.addParameter("--macro keep('armory.trait.FollowCamera')");
project.addParameter('armory.trait.internal.CanvasScript');
project.addParameter("--macro keep('armory.trait.internal.CanvasScript')");
project.addParameter('armory.trait.physics.bullet.PhysicsWorld');
project.addParameter("--macro keep('armory.trait.physics.bullet.PhysicsWorld')");
project.addParameter('armory.trait.physics.bullet.RigidBody');
project.addParameter("--macro keep('armory.trait.physics.bullet.RigidBody')");
project.addParameter('armory.trait.internal.Bridge');
project.addParameter("--macro keep('armory.trait.internal.Bridge')");
project.addParameter('arm.Powerup');
project.addParameter("--macro keep('arm.Powerup')");
project.addParameter('armory.trait.internal.DebugConsole');
project.addParameter("--macro keep('armory.trait.internal.DebugConsole')");
project.addParameter('arm.scenes.Title');
project.addParameter("--macro keep('arm.scenes.Title')");
project.addParameter('arm.scenes.EndlessRunner');
project.addParameter("--macro keep('arm.scenes.EndlessRunner')");
project.addShaders("build_frogger/compiled/Shaders/*.glsl", { noembed: false});
project.addAssets("build_frogger/compiled/Assets/**", { notinlist: true });
project.addAssets("build_frogger/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("/home/tyler/armory_ext/armsdk/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("/home/tyler/armory_ext/armsdk/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("/home/tyler/armory_ext/armsdk/armory/Assets/smaa_search.png", { notinlist: true });
project.addAssets("Bundled/Truck_L_brown.png", { notinlist: true });
project.addAssets("Bundled/Truck_L_green.png", { notinlist: true });
project.addAssets("Bundled/Truck_L_red.png", { notinlist: true });
project.addAssets("Bundled/Truck_M_brown.png", { notinlist: true });
project.addAssets("Bundled/Truck_M_green.png", { notinlist: true });
project.addAssets("Bundled/Truck_M_red.png", { notinlist: true });
project.addAssets("Bundled/Truck_S_brown.png", { notinlist: true });
project.addAssets("Bundled/Truck_S_green.png", { notinlist: true });
project.addAssets("Bundled/Truck_S_red.png", { notinlist: true });
project.addAssets("Bundled/canvas/Frogger.files", { notinlist: true });
project.addAssets("Bundled/canvas/Frogger.json", { notinlist: true });
project.addAssets("Bundled/canvas/TitleCanvas.files", { notinlist: true });
project.addAssets("Bundled/canvas/TitleCanvas.json", { notinlist: true });
project.addAssets("Bundled/canvas/_themes.json", { notinlist: true });
project.addShaders("/home/tyler/armory_ext/armsdk/armory/Shaders/debug_draw/**");
project.addParameter('--times');
project.addLibrary("/home/tyler/armory_ext/armsdk/lib/zui");
project.addAssets("/home/tyler/armory_ext/armsdk/armory/Assets/font_default.ttf", { notinlist: false });
project.addDefine('arm_deferred');
project.addDefine('arm_csm');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Deferred');
project.addDefine('rp_shadowmap');
project.addDefine('rp_shadowmap_cascade=1024');
project.addDefine('rp_shadowmap_cube=1024');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=SSAO');
project.addDefine('rp_dynres');
project.addDefine('arm_audio');
project.addDefine('arm_physics');
project.addDefine('arm_bullet');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_debug');
project.addDefine('arm_ui');
project.addDefine('arm_skin');
project.addDefine('arm_particles');
project.addDefine('arm_resizable');


resolve(project);
