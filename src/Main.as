package {
	
	import com.wordpress.gfmgamecorner.LogoGFM;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import states.Menustate;
	import states.Playstate;
	import utils.SFX;
	
	// Game link:
	// https://dl.dropboxusercontent.com/u/55733901/LD48/ld29/gfm_ld29.html
	
	[SWF(width="640",height="480",backgroundColor="0x000000")]
	[Frame(factoryClass="Preloader")]
	/**
	 * ...
	 * @author 
	 */
	public class Main extends FlxGame {
		
		static public var filter:Bitmap;
		
		private const sfx:SFX = SFX.self;
		private var logo:LogoGFM;
		
		public function Main():void {
			super(320, 240, Menustate, 2, 60, 60);
			
			logo = null;
			return;
			
			logo = new LogoGFM(true);
			logo.scaleX = 2;
			logo.scaleY = 2;
			logo.x = (500 - logo.width) / 2;
			logo.y = (500 - logo.height) / 2;
			addChild(logo);
		}
		
		override protected function create(FlashEvent:Event):void {
			if (logo)
				if (logo.visible)
					return;
				else {
					removeChild(logo);
					logo.destroy();
					logo = null;
				}
			
			super.create(FlashEvent);
			
			addOverlay();
			
			sfx.init();
		}
		
		override protected function onFocus(FlashEvent:Event = null):void {
			super.onFocus(FlashEvent);
			if (!FlxG.mute)
				sfx.resumeMusic();
		}
		override protected function onFocusLost(FlashEvent:Event = null):void {
			var X:Number = x;
			var Y:Number = y;
			super.onFocusLost(FlashEvent);
			sfx.pauseMusic();
			x = X;
			y = Y;
		}
		override protected function showSoundTray(Silent:Boolean = false):void {
			super.showSoundTray(Silent);
			if (FlxG.mute) {
				sfx.pauseMusic();
			}
			else {
				sfx.resumeMusic();
				sfx.volume = FlxG.volume;
			}
			FlxG.resetInput();
		}
		
		private function addOverlay():void {
			var i:int;
			var j:int;
			var k:int;
			var bm:BitmapData = new BitmapData(640, 480, true, 0);
			var v:Vector.<uint> = bm.getVector(bm.rect);
			
			var dark:uint = 0x66000000;
			var mid:uint = 0x44000000;
			var light:uint = 0x22000000;
			var clear:uint = 0x00000000;
			
			j = 0;
			while (j < 75) {
				i = 0;
				while (i < 160) {
					k = (j*640 + i)*4;
					v[k] = mid; v[k+1] = light; v[k+2] = clear; v[k+3] = clear;
					k += 640;
					v[k] = mid; v[k+1] = light; v[k+2] = light; v[k+3] = clear;
					k += 640;
					v[k] = dark; v[k+1] = mid; v[k+2] = light; v[k+3] = light;
					k += 640;
					v[k] = dark; v[k+1] = dark; v[k+2] = mid; v[k+3] = mid;
					i++;
				}
				j++;
			}
			j = 0
			while (j < 90) {
				i = 0;
				while (i < 320) {
					k = (j*640 + i)*2+75*4*640;
					v[k] = light; v[k+1] = clear;
					k += 640;
					v[k] = mid; v[k+1] = light;
					i++;
				}
				j++;
			}
			
			bm.setVector(bm.rect, v);
			filter = new Bitmap(bm);
			//filter.visible = false;
			addChild(filter);
		}
	}
}
