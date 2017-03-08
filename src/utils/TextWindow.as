package utils {
	
	import objs.Character;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextWindow extends FlxBasic {
		
		static public const normal:uint = 0x0000;
		static public const angry:uint = 0x0001;
		static public const thougth:uint = 0x0002;
		static public const whisper:uint = 0x0003;
		
		private var _text:FlxText;
		private var _buf:String;
		private var _time:Number;
		
		private var _complete:Boolean;
		private var _justAny:Boolean;
		private var _ft:FlashingText;
		
		private var s:FlxSprite;
		
		public function TextWindow() {
			super();
			
			s = new FlxSprite(0, 75 + 12);
			
			_text = new FlxText(8+24, 75+8, FlxG.width - 16 - 24);
			_text.setFormat(null, 8, gfx.text_color, "left", gfx.text_shadow);
			_ft = new FlashingText(0, 75 + 90 - 20);
		}
		override public function destroy():void {
			super.destroy();
			_ft.destroy();
			_ft = null;
			_text.destroy();
			_ft = null;
			s.destroy();
			s = null;
		}
		
		override public function update():void {
			var justPressedAny:Boolean = false;
			if (!_justAny) {
				if (FlxG.keys.any()) {
					_justAny = true;
					justPressedAny = true;
				}
			}
			else {
				if (!FlxG.keys.any()) {
					_justAny = false;
				}
			}
			
			if (!_complete) {
				if (justPressedAny) {
					_text.text = _buf;
				}
				else {
					_time -= FlxG.elapsed;
					if (_time <= 0) {
						var l:int = _text.text.length;
						var c:String = _buf.charAt(l);
						_text.text = _buf.substr(0, l + 1);
						if (c == " ")
							_time += 0.05;
						else if (c == ",")
							_time += 0.075;
						else if (c == "." || c == "!" || c == "?")
							_time += 0.1;
						else {
							if (FlxG.random() * 1000 % 100 < 75)
								sfx.playTextSFX();
							_time += 0.035;
						}
						_complete = (_text.text.length == _buf.length);
					}
				}
			}
			else {
				_ft.update();
				if (justPressedAny) {
					kill();
				}
			}
		}
		
		override public function draw():void {
			_text.draw();
			if (_complete)
				_ft.draw();
			if (s.visible)
				s.draw();
		}
		
		public function show(target:String, text:String, type:uint):void {
			revive();
			
			s.visible = true;
			if (target == "player")
				s.loadGraphic(gfx.player_gfx, true, true, 32, 24);
			else if (target == "wife")
				s.loadGraphic(gfx.wife_gfx, true, true, 32, 24);
			else if (target == "boss")
				s.loadGraphic(gfx.boss_gfx, true, true, 32, 24);
			else
				s.visible = false;
			s.frame = 0;
			
			_text.text = "";
			_buf = text;
			_time = 0;
			_justAny = FlxG.keys.any();
			_complete = false;
			
			if (type == normal) {
				_text.color = gfx.text_color;
				_text.shadow = gfx.text_shadow;
			}
			else if (type == angry) {
				_text.color = gfx.text_color_angry;
				_text.shadow = gfx.text_shadow_angry;
			}
			else if (type == thougth) {
				_text.color = gfx.text_color_thought;
				_text.shadow = gfx.text_shadow_though;
			}
		}
		
		public function get complete():Boolean {
			return _complete && !alive;
		}
	}
}
