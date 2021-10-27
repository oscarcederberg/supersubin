package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	static inline final WIDTH:Int = 4;
	static inline final HEIGHT:Int = 16;
	static inline final MOVE_SPEED:Float = PlayState.CELL_SIZE * 4;
	static inline final JUMP_SPEED:Float = PlayState.CELL_SIZE * 16;
	static inline final GRAVITY:Float = PlayState.CELL_SIZE * 30;

	var parent:PlayState;

	var jumping:Bool;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		this.parent = cast(FlxG.state);

		this.facing = FlxObject.RIGHT;
		this.jumping = false;
		drag.x = MOVE_SPEED * 8;
		acceleration.y = GRAVITY;
		maxVelocity.x = MOVE_SPEED;
		maxVelocity.y = JUMP_SPEED;

		loadGraphic("assets/images/subin.png", true, PlayState.CELL_SIZE, PlayState.CELL_SIZE);
		setSize(WIDTH, HEIGHT);
		centerOffsets();
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("idle", [0]);
		animation.add("jump", [2]);
		animation.add("walk", [1, 0], 4, true);
		animation.play("idle");
	}

	override public function update(elapsed:Float):Void
	{
		movement();
		animate();

		super.update(elapsed);
	}

	function movement():Void
	{
		var _up:Bool = FlxG.keys.pressed.UP;
		var _down:Bool = FlxG.keys.pressed.DOWN;
		var _left:Bool = FlxG.keys.pressed.LEFT;
		var _right:Bool = FlxG.keys.pressed.RIGHT;

		var _action:Bool = FlxG.keys.pressed.Z;
		var _jump:Bool = FlxG.keys.justPressed.X;

		velocity.x = 0;
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

		if (_left)
		{
			facing = FlxObject.LEFT;
		}
		else if (_right)
		{
			facing = FlxObject.RIGHT;
		}

		if (_left)
		{
			velocity.x = -MOVE_SPEED;
		}
		else if (_right)
		{
			velocity.x = MOVE_SPEED;
		}

		if (this.isTouching(FlxObject.FLOOR))
		{
			if (_jump && !_action && !jumping)
			{
				jumping = true;
				velocity.y = -maxVelocity.y;
			}
			else
			{
				jumping = false;
			}
		}
	}

	function animate()
	{
		var _up:Bool = FlxG.keys.pressed.UP;
		var _down:Bool = FlxG.keys.pressed.DOWN;
		var _left:Bool = FlxG.keys.pressed.LEFT;
		var _right:Bool = FlxG.keys.pressed.RIGHT;

		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

		if (!jumping)
		{
			if (this.isTouching(FlxObject.FLOOR))
			{
				if (_left || _right)
				{
					animation.play("walk");
				}
				else
				{
					animation.play("idle");
				}
			}
			else
			{
				animation.play("jump");
			}
		}
		else if (jumping || velocity.y != 0)
		{
			if (!this.isTouching(FlxObject.CEILING) && !this.isTouching(FlxObject.FLOOR))
				animation.play("jump");
		}
	}
}
