package arm;

class GameController
{   
    public static var keyboard:Keyboard = null;

    public static function update()
    {
        if (keyboard == null ) keyboard = iron.system.Input.getKeyboard();

        //DEBUG
        if (keyboard.started("1")) {
            setState(TITLE);
        }

        if (keyboard.started("2")) {
            setState(MENU);
        }

        if (keyboard.started("3")) {
            setState(PLAYING);
        }

        if (keyboard.started("4")) {
            setState(GAME_OVER);
        }

        if (keyboard.started("5")) {
            var spawnLoc = new Vec4(0,0,0);
            var v = vehicleSystem.getRandomVehicle();
            v.transform.loc.setFrom(spawnLoc);
            v.transform.buildMatrix();
            var vehicleTrait = v.getTrait(Vehicle);
            vehicleTrait.setDirection(new Vec4(0, -1, 0));
            vehicleTrait.setActive(true);
        }

        // vehicle visibility logic
        for (vehicle in vehicleSystem.getVehicles()) {
            if (
                vehicle.object.transform.world.getLoc().y < player.transform.world.getLoc().y + 24
            ) {
                vehicle.object.visible = true;
            } else {
                vehicle.object.visible = false;
            }
        }

        // street visibility + spawner logic
        for (street in streetSystem.getStreets()) {
            var streetTrait = street.getTrait(Street);
            if (
                street.transform.world.getLoc().y < player.transform.world.getLoc().y + 48
            ) {
                // Activate spawns
                if (streetTrait.getSpawner() != null) {
                    street.visible = true;
                    streetTrait.getSpawner().getTrait(VehicleSpawner).setActive(true);
                }
            } else {
                if (streetTrait.getSpawner() != null) {
                    street.visible = false;
                    streetTrait.getSpawner().getTrait(VehicleSpawner).setActive(false);
                }
            }

            if (player.transform.world.getLoc().y - 12 > street.transform.world.getLoc().y) {
                street.remove();
            }
        }

        // WIN LEVEL
        var finish = streetSystem.getFinish();
        if (finish != null) {
            if (player.transform.world.getLoc().y >= finish.transform.world.getLoc().y) {
                // Show Finish screen

                // Switch to endless mode
                this.setState(GAME_2);
            }
        }

        if (player != null && player.getTrait(Player).isDead()) {
            this.setState(GAME_OVER);
            trace("OVER?");
        }
    } 
}
