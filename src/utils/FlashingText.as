package utils {
	
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author 
	 */
	public class FlashingText extends FlxText {
		
		private var n:Number;
		private var da:Number;
		
		public function FlashingText(X:Number, Y:Number) {
			super(X, Y, FlxG.width - 8, "Press any key to continue");
			setFormat(null, 8, gfx.text_color, "right", gfx.text_shadow);
			n = FlxG.elapsed;
			da = n;
		}
		
		override public function update():void {
			alpha += da;
			if (alpha >= 1)
				da = -n;
			else if (alpha <= 0)
				da = n;
		}
	}
}
