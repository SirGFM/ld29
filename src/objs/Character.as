package objs {
	
	import objs.base.Base;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class Character extends Base {
		
		private var walkTimer:Number;
		
		public function Character() {
			super();
			walkTimer = 0;
			addAnimation("stand", [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,1], 16);
			addAnimation("walk", [3,4,5,6], 6, true);
			addAnimation("sit", [7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,9,8], 16);
			addAnimation("sleep", [12], 0, false);
			addAnimation("wakeup", [12, 11, 10], 16, false);
			addAnimation("lie", [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,12,11], 16, true);
		}
		
		override public function update():void {
			super.update();
			if (velocity.x > 0) {
				facing = RIGHT;
				play("walk");
			}
			else if (velocity.x < 0) {
				facing = LEFT;
				play("walk");
			}
			if (_curAnim) {
				if (_curAnim.name == "walk") {
					if (velocity.x == 0)
						play("stand");
					else {
						walkTimer -= FlxG.elapsed;
						if (walkTimer <= 0) {
							sfx.playStepSFX();
							walkTimer += 1 / 3;
						}
					}
				}
				else if (finished && _curAnim.name == "wakeup")
					play("lie");
			}
		}
		
		override public function play(AnimName:String, Force:Boolean = false):void {
			super.play(AnimName, Force);
			if (AnimName == "walk" && (!_curAnim || _curAnim.name != "walk"))
				walkTimer += 1 / 3;
		}
	}
}
