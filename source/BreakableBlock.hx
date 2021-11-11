package;

import flixel.FlxG;
import flixel.FlxSprite;

class BreakableBlock extends FlxSprite{
    var parent:PlayState;

    public function new(x:Float, y:Float){
        super(x,y);
		this.parent = cast(FlxG.state);
		
        loadGraphic("missing", false, PlayState.CELL_SIZE, PlayState.CELL_SIZE);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

    private function onCollide(block:BreakableBlock, player:Player) {
        if(player.y < (block.y + block.height) && player.velocity.y < 0){
            block.destroy();
        }
    }
}