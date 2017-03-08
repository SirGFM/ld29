package objs.base {
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class Base extends FlxSprite {
		
		public var label:String;
		public var num:Number;
		
		public function Base() {
			super();
		}
		
		public function load(gfx:Class, Width:int=0, Height:int=0, anim:Boolean = false):void {
			loadGraphic(gfx, anim, anim, Width, Height);
		}
	}
}
