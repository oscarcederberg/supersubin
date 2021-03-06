package;

import haxe.Log;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.math.FlxVector;
import enemies.Enemy;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

enum State{
	Idling;
	Moving;
	Jumping;
}

class Player extends FlxSprite{
	static inline final WIDTH:Int = 4;
	static inline final HEIGHT:Int = 16;
	static inline final MOVE_SPEED:Float = 80;
	static inline final JUMP_SPEED:Float = 180;
	static inline final JUMP_MAX:Float = 260;
	static inline final GRAVITY:Float = 1080;
	static inline final BOUNCE_FORCE:Float = 10000;
	static inline final DAMAGE_FORCE:Float = 15000;

	private var parent:PlayState;

	public var currentState:State;

	var jumpTimer:FlxTimer;
	var timeJump = 0.225;
	var canVariableJump:Bool;

	var bounceTimer:FlxTimer;
	var bounceDelay = 0.025;
	var damageDelay = 0.05;
	var bounceVector:FlxVector;

	public function new(x:Float, y:Float){
		super(x, y);
		this.parent = cast(FlxG.state);

		this.currentState = Idling;
		this.facing = FlxDirectionFlags.RIGHT;

		jumpTimer = new FlxTimer();
		canVariableJump = false;

		bounceTimer = new FlxTimer();
		bounceVector = new FlxVector(0,0);

		acceleration.y = GRAVITY;
		maxVelocity.y = JUMP_MAX;

		loadGraphic("assets/images/subin.png", true, PlayState.CELL_SIZE, PlayState.CELL_SIZE);
		setSize(WIDTH, HEIGHT);
		centerOffsets();
		setFacingFlip(FlxDirectionFlags.LEFT, true, false);
		setFacingFlip(FlxDirectionFlags.RIGHT, false, false);
		animation.add("idle", [0]);
		animation.add("jump", [2]);
		animation.add("walk", [1, 0], 6, true);
		animation.play("idle");
	}

	override public function update(elapsed:Float):Void{
		movement();
		animate();

		FlxG.overlap(this, parent.enemies, onEnemyOverlap);
		acceleration.x = bounceVector.x;
		acceleration.y = GRAVITY + bounceVector.y;

		super.update(elapsed);
	}

	function onEnemyOverlap(player:Player, enemy:Enemy):Void{
		var angle = FlxAngle.angleBetweenPoint(enemy, player.getMidpoint(), false);
	
		var tookDamage = false;
		if(angle == Math.PI || angle < -5/6*Math.PI){
			tookDamage = true;
			angle = -3/4*Math.PI;
		} else if(angle == 0 || angle > -1/6*Math.PI){
			tookDamage = true;
			angle = -1/4*Math.PI;
		}
		
		if(!FlxSpriteUtil.isFlickering(player)){
			if(tookDamage){
				bounceVector.setPolarRadians(DAMAGE_FORCE, angle);
				bounceTimer.start(bounceDelay, (_) -> bounceVector.y = 0);
				currentState = Jumping;
				FlxSpriteUtil.flicker(player, 1.5, 0.04, true, false);
			} else{
				bounceVector.setPolarRadians(BOUNCE_FORCE, angle);
				bounceTimer.start(bounceDelay, (_) -> bounceVector.y = 0);
				currentState = Jumping;
				canVariableJump = true;
			}
		}
	}

	function movement():Void{
		var _up:Bool = FlxG.keys.pressed.UP;
		var _down:Bool = FlxG.keys.pressed.DOWN;
		var _left:Bool = FlxG.keys.pressed.LEFT;
		var _right:Bool = FlxG.keys.pressed.RIGHT;
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

		var _action:Bool = FlxG.keys.pressed.Z;
		var _jump:Bool = FlxG.keys.pressed.X;

		var _canMove = true;

		switch (currentState){
			case Jumping:
				movement_jump(_jump);
			case Idling:
				if (_jump){
					currentState = Jumping;
					movement_jump(true);
				} else if (_left || _right){
					currentState = Moving;
				}
			case Moving:
				if (_jump){
					currentState = Jumping;
					movement_jump(true);
				} else if (!_left && !_right){
					currentState = Idling;
				}
		}

		if (_left && _canMove){
			facing = FlxDirectionFlags.LEFT;
			velocity.x = -MOVE_SPEED;
			bounceVector.x = 0;
		}
		else if (_right){
			facing = FlxDirectionFlags.RIGHT;
			velocity.x = MOVE_SPEED;
			bounceVector.x = 0;
		}
		else{
			velocity.x = 0;
		}
	}

	private function movement_jump(jumpPressed:Bool){
		if (this.isTouching(FlxDirectionFlags.FLOOR)){
			bounceVector.x = 0;
			currentState = Idling;
			canVariableJump = true;
			if (jumpPressed){
				currentState = Jumping;
				velocity.y = -JUMP_SPEED;
			}
		} else{
			if (!jumpPressed || isTouching(FlxDirectionFlags.CEILING)){
				canVariableJump = false;
			}
		}

		if (canVariableJump && jumpPressed){
			if (!jumpTimer.active){
				jumpTimer.start(timeJump, (_) -> canVariableJump = false, 1);
			}
			velocity.y = -JUMP_SPEED;
		}
	}

	function animate(){
		switch (currentState){
			case Idling:
				animation.play("idle");
			case Moving:
				animation.play("walk");
			case Jumping:
				animation.play("jump");
		}
	}
}
