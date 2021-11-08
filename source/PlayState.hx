package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{
	inline public static final WINDOW_WIDTH = 512;
	inline public static final GAME_WIDTH = 256;
	inline public static final GAME_SCALE = WINDOW_WIDTH / GAME_WIDTH;
	inline public static final CELL_SIZE:Int = 16;

	var map:FlxOgmo3Loader;

	public var tilemap:FlxTilemap;
	public var player:Player;

	override public function create()
	{
		super.create();
		var bg_00 = new FlxBackdrop("assets/images/park_bg_00.png", 0.2, 0.0, true, false);
		var bg_01 = new FlxBackdrop("assets/images/park_bg_01.png", 0.5, 0.0, true, false);
		var bg_02 = new FlxBackdrop("assets/images/park_bg_02.png", 0.8, 0.0, true, false);
		add(bg_00);	
		add(bg_01);	
		add(bg_02);	

		this.map = new FlxOgmo3Loader("assets/data/project.ogmo", "assets/data/level_test.json");
		this.map.loadEntities(placeEntities, "entities");
		this.tilemap = map.loadTilemap("assets/images/OGMO/tilemap.png", "tiles");
		add(this.tilemap);

		FlxG.worldBounds.set();

		FlxG.camera.minScrollX = 0;
		FlxG.camera.maxScrollX = this.tilemap.width;
		FlxG.camera.minScrollY = 0;
		FlxG.camera.maxScrollY = this.tilemap.height;
		FlxG.camera.follow(player, PLATFORMER, 1);
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
