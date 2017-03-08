package states {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import utils.textmenu.HorizontalOption;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Menustate extends FlxState {
		
		override public function create():void {
			var s:FlxSprite = new FlxSprite(0, 0, gfx.work_bg_gfx);
			s.setOriginToCorner();
			s.scale.make(2, 2);
			s.setOriginToCorner();
			add(s);
			
			s = new FlxSprite(0, 32, gfx.title);
			s.x = (FlxG.width - s.width) / 2;
			add(s);
			
			var map:FlxTilemap;
			var str:String = new gfx.window_tm;
			map = new FlxTilemap();
			map.loadMap(str, gfx.window_gfx, 10, 10, FlxTilemap.OFF, 0, 0);
			map.y = 150;
			add(map);
			
			var tm:TextMenu = new TextMenu(170, test_cb);
			tm.addOption(new Option("New game"));
			tm.addOption(new HorizontalOption("Pixel filter", ["ON", "OFF"], (Main.filter.visible==true)?0:1));
			add(tm);
			
			FlxG.camera.bgColor = 0xffbacbb9;
			sfx.playBarSong();
		}
		
		private function test_cb(tm:TextMenu):void {
				if (tm.currentOpt == "New game") {
					if (tm.selected) {
						FlxG.fade(0xff000000, 1, function():void { FlxG.switchState(new Playstate()); } );
					}
				}
				else if (tm.currentOpt == "Pixel filter") {
					if (tm.currentHorizontalOpt == "ON")
						Main.filter.visible = true;
					else if (tm.currentHorizontalOpt == "OFF")
						Main.filter.visible = false;
				}
		}
	}
}
