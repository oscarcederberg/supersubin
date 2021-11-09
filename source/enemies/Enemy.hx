package enemies;

import flixel.FlxSprite;

abstract class Enemy extends FlxSprite{
    public function new(x:Float, y:Float){
        super(x,y);
    }
}