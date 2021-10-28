package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.tile.FlxTilemapExt;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	inline public static final WINDOW_WIDTH = 512;
	inline public static final GAME_WIDTH = 256;
	inline public static final GAME_SCALE = WINDOW_WIDTH / GAME_WIDTH;
	inline public static final CELL_SIZE:Int = 16;

	var map:FlxOgmo3Loader;

	public var tilemap:FlxTilemapExt;
	public var player:Player;

	override public function create()
	{
		this.map = new FlxOgmo3Loader("assets/data/project.ogmo", "assets/data/level_test.json");
		this.map.loadEntities(placeEntities, "entities");
		this.tilemap = map.loadTilemapExt("assets/images/OGMO/tilemap.png", "tiles");
		this.tilemap.setSlopes([18, 19, 20, 25, 26, 27], [4, 5, 6, 11, 12, 13]);
		this.tilemap.setGentle([19, 26, 5, 12], [18, 20, 25, 27, 4, 6, 11, 13]);
		this.tilemap.setDownwardsGlue(true, 0.1);
		add(this.tilemap);

		FlxG.camera.minScrollX = 0;
		FlxG.camera.maxScrollX = this.tilemap.width;
		FlxG.camera.minScrollY = 0;
		FlxG.camera.maxScrollY = this.tilemap.height;
		FlxG.camera.follow(player, PLATFORMER, 1);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.R)
		{
			FlxG.switchState(new PlayState());
		}

		FlxG.collide(player, tilemap);
	}

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				player = new Player(entity.x, entity.y);
				add(player);
		}
	}
}
