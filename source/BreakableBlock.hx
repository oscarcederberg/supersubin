package;

import flixel.FlxSprite;

class BreakableBlock extends FlxSprite{
    public function new(x:Float, y:Float){
        super(x,y);
		
        loadGraphic("missing", false, PlayState.CELL_SIZE, PlayState.CELL_SIZE);
    }
}