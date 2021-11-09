package;

import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.addons.display.FlxBackdrop;

class MovingBackdrop extends FlxBackdrop{
    public var myVelocity:FlxVector;

    public function new(graphic:FlxGraphicAsset, velocityX:Float, velocityY:Float, scrollX:Float, scrollY:Float, repeatX:Bool, repeatY:Bool){
        super(graphic, scrollX, scrollY, repeatX, repeatY);

        myVelocity = new FlxVector(velocityX, velocityY);
        this.velocity.set(velocityX, velocityY); 
    }

    override function update(elapsed:Float){
        super.update(elapsed);
        //var newPos = this.getPosition().addPoint(myVelocity.scale(elapsed));
        //this.setPosition(newPos.x, newPos.y);
    }
}