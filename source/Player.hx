package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	static inline final WIDTH:Int = 4;
	static inline final HEIGHT:Int = 16;
	static inline final MOVE_SPEED:Float = 80;
	static inline final JUMP_SPEED:Float = 180;
	static inline final JUMP_MAX:Float = 260;
	static inline final GRAVITY:Float = 1080;

	private var parent:PlayState;

	var jumpTimer:FlxTimer;
	var jumpTime = 0.225;
	var canVariableJump:Bool;
	var jumping:Bool;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		this.parent = cast(FlxG.state);

		this.facing = FlxObject.RIGHT;

		jumpTimer = new FlxTimer();
		canVariableJump = false;
		jumping = false;

		acceleration.y = GRAVITY;
		maxVelocity.y = JUMP_MAX;

		loadGraphic("assets/images/subin.png", true, PlayState.CELL_SIZE, PlayState.CELL_SIZE);
		setSize(WIDTH, HEIGHT);
		centerOffsets();
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("idle", [0]);
		animation.add("jump", [2]);
		animation.add("walk", [1, 0], 6, true);
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
		var _jump:Bool = FlxG.keys.pressed.X;

		velocity.x = 0;
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

		if (_left)
		{
			facing = FlxObject.LEFT;
			velocity.x = -MOVE_SPEED;
		}
		else if (_right)
		{
			facing = FlxObject.RIGHT;
			velocity.x = MOVE_SPEED;
		}
		else
		{
			velocity.x = 0;
		}

		if (this.isTouching(FlxObject.FLOOR))
		{
			jumping = false;
			canVariableJump = true;
			if (_jump)
			{
				jumping = true;
				velocity.y = -JUMP_SPEED;
			}
		}
		else if (!jumping)
		{
			canVariableJump = false;
		}
		else
		{
			if (!_jump)
			{
				canVariableJump = false;
			}
		}

		if (canVariableJump && _jump)
		{
			if (!jumpTimer.active)
			{
				jumpTimer.start(jumpTime, onVariableJumpEnds, 1);
			}
			velocity.y = -JUMP_SPEED;
		}
	}

	private function onVariableJumpEnds(timer:FlxTimer)
	{
		canVariableJump = false;
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
