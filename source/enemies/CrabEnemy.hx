package enemies;

import flixel.FlxG;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxTimer;

enum State
{
	Idling;
	Moving;
	Turning;
}

class CrabEnemy extends Enemy
{
	static inline final WIDTH:Int = 14;
	static inline final HEIGHT:Int = 10;
	static inline final OFFSET_Y:Int = 6;
	static inline final OFFSET_X:Int = 0;
	static inline final MOVE_SPEED:Float = 40;
	static inline final GRAVITY:Float = 1080;

	private var parent:PlayState;

	public var currentState:State;

	var stateTimer:FlxTimer;
	var timeIdle:Float = 0.25;
	var timeMoving:Float = 0.50;
	var timeTurning:Float = 0.50;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		this.parent = cast(FlxG.state);

		this.currentState = State.Idling;
		this.facing = FlxDirectionFlags.LEFT;

		stateTimer = new FlxTimer();
		var timeDelay:Float = parent.random.float(0.0, 0.5);
		stateTimer.start(timeDelay, handleState, 1);

		loadGraphic("assets/images/crab.png", true, PlayState.CELL_SIZE, PlayState.CELL_SIZE);
		setSize(WIDTH, HEIGHT);
		setFacingFlip(FlxDirectionFlags.LEFT, true, false);
		setFacingFlip(FlxDirectionFlags.RIGHT, false, false);
		animation.add("idle", [0]);
		animation.add("walk", [1, 0], 6, true);
		animation.play("idle");
	}

	override function update(elapsed:Float)
	{
		if (currentState == Moving)
		{
			if (this.facing == FlxDirectionFlags.LEFT && isTouching(FlxDirectionFlags.LEFT))
			{
				currentState = Turning;
				velocity.x = 0;
				stateTimer.start(timeTurning, handleState, 1);
			}
			else if (this.facing == FlxDirectionFlags.RIGHT && isTouching(FlxDirectionFlags.RIGHT))
			{
				currentState = Turning;
				velocity.x = 0;
				stateTimer.start(timeTurning, handleState, 1);
			}
		}
		animate();

		super.update(elapsed);
	}

	function handleState(timer:FlxTimer)
	{
		switch (currentState)
		{
			case Idling:
				handleState_idle();
			case Moving:
				handleState_moving();
			case Turning:
				handleState_turning();
		}
	}

	private function handleState_idle()
	{
		this.currentState = Moving;
		velocity.x = this.facing == FlxDirectionFlags.LEFT ? -MOVE_SPEED : MOVE_SPEED;
		stateTimer.start(timeMoving, handleState, 1);
	}

	private function handleState_moving()
	{
		this.currentState = Idling;
		velocity.x = 0;
		stateTimer.start(timeIdle, handleState, 1);
	}

	private function handleState_turning()
	{
		this.currentState = Moving;
		this.facing = this.facing == FlxDirectionFlags.LEFT ? FlxDirectionFlags.RIGHT : FlxDirectionFlags.LEFT;
		velocity.x = this.facing == FlxDirectionFlags.LEFT ? -MOVE_SPEED : MOVE_SPEED;
		stateTimer.start(timeMoving, handleState, 1);
	}

	public function animate()
	{
		switch (currentState)
		{
			case Idling:
				animation.play("idle");
			case Moving:
				animation.play("walk");
			case Turning:
				animation.play("idle");
		}
	}
}
