package states {
	
	import objs.base.Base;
	import objs.BaseObject;
	import objs.Character;
	import objs.BGsprite;
	import objs.BGtilemap;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	import utils.TextWindow;
	
	/**
	 * ...
	 * @author 
	 */
	public class Basestate extends FlxState {
		
		static public const s0_dream:uint = 0x0001;
		static public const s1_home:uint = 0x0002;
		static public const s2_work:uint = 0x0003;
		static public const s3_work:uint = 0x0004;
		static public const s4_bar:uint = 0x0005;
		static public const s4_home:uint = 0x0006;
		static public const s5_dream:uint = 0x0007;
		
		private const _stateEvent:Vector.<StateEvent> = new Vector.<StateEvent>();
		
		private var _current:uint;
		private var _max:uint;
		private var _list:Vector.<StateEvent>;
		private var _chars:Vector.<Base>;
		
		private var _init:Boolean;
		private var _focusChar:Character;
		private var _focusBase:Base;
		private var _focusObj:BaseObject;
		private var _curMarkers:Array;
		private var _curTextWindow:TextWindow;
		private var fade:FlxSprite;
		private var _id:uint;
		
		private var _shatter:FlxEmitter;
		
		private var _window:FlxTilemap;
		
		public function Basestate() {
			super();
			_list = new Vector.<StateEvent>();
			_chars = new Vector.<Base>();
		}
		override public function create():void {
			super.create();
			
			fade = new FlxSprite();
			fade.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			fade.visible = false;
			
			var str:String = new gfx.window_tm;
			_window = new FlxTilemap();
			_window.loadMap(str, gfx.window_gfx, 10, 10, FlxTilemap.OFF, 0, 0);
			_window.y = 75;
			
			_shatter = new FlxEmitter();
			_shatter.makeParticles(gfx.shatter_gfx, 32, 1, true, 0);
			_shatter.visible = false;
			add(_shatter);
		}
		override public function destroy():void {
			clearScene();
			_chars = null;
			_list = null;
			fade.destroy();
			fade = null;
			_focusChar = null;
			_focusObj = null;
			_window.destroy();
			_window = null;
			//_curTextWindow.destroy();
			//_curTextWindow = null;
			super.destroy();
		}
		
		override public function update():void {
			var se:StateEvent;
			var char:Character;
			var i:int;
			var l:int;
			
			if (_current == 0 && !_init) {
				sort("ID");
			}
			if (_current == _max || !alive)
				return;
			// first, call the non blocking ones
			while (1) {
				if (_current == _max)
					return;
				se = _list[_current];
				if (se.event == StateEvent.marker) {
					_current++;
				}
				else if (se.event == StateEvent.call) {
					se.f();
					_current++;
				}
				else
					break;
				_init = false;
			}
			se = _list[_current];
			// now, check the current action and execute
			switch (se.event) {
				case StateEvent.moveChar: {
					if (!_init) {
						_focusBase = findBase(se.label);
						if (_focusBase != null) {
							_focusBase.velocity.x = (se.x - _focusBase.x) / se.time;
							_focusBase.velocity.y = (se.y - _focusBase.y) / se.time;
							//_focusBase = char;
							_init = true;
						}
						else
							throwError();
					}
					else {
						if (_focusBase.velocity.x > 0 && _focusBase.x >= se.x || _focusBase.velocity.x < 0 && _focusBase.x <= se.x)
							_focusBase.velocity.x = 0;
						if (_focusBase.velocity.y > 0 && _focusBase.y >= se.y || _focusBase.velocity.y < 0 && _focusBase.y <= se.y)
							_focusBase.velocity.y = 0;
						if (_focusBase.velocity.x == 0 && _focusBase.velocity.y == 0) {
							inc();
						}
					}
				}break;
				case StateEvent.sayChar: {
					if (!_init) {
						_curTextWindow = recycle(TextWindow) as TextWindow;
						_curTextWindow.show(se.label, se.text, se.type);
						_init = true;
					}
					else {
						if (_curTextWindow.complete) {
							inc();
						}
					}
				}break;
				case StateEvent.goto: {
					if (!gotoLabel(se.label))
						_current++;
				}break;
				case StateEvent.gotoif: {
					if (se.f()) {
						if (!gotoLabel(se.label)) {
							inc();
						}
					}
					else
						inc();
				}break;
				case StateEvent.showOptions: {
					var tm:TextMenu;
					if (!_init) {
						char = findChar(se.label);
						if (char == null)
							throwError();
						tm = new TextMenu(se.y, textMenuCallback);
						add(tm);
						i = 0;
						l = se.options.length;
						while (i < l) {
							tm.addOption(new Option(se.options[i]));
							i++;
						}
						_curMarkers = se.markers;
						_init = true;
					}
				}break;
				case StateEvent.fadeout: {
					if (!_init) {
						fade.visible = true;
						fade.alpha = 0;
						fade.velocity.x = FlxG.elapsed / se.time;
						_init = true;
					}
					else {
						fade.alpha += fade.velocity.x;
						if (fade.alpha >= 1) {
							fade.alpha = 1;
							inc();
						}
					}
				}break;
				case StateEvent.fadein: {
					if (!_init) {
						fade.visible = true;
						fade.alpha = 1;
						fade.velocity.x = FlxG.elapsed / se.time;
						_init = true;
					}
					else {
						fade.alpha -= fade.velocity.x;
						if (fade.alpha <= 0) {
							fade.alpha = 0;
							inc();
							fade.visible = false;
						}
					}
				}break;
				case StateEvent.fadeobjout: {
					if (!_init) {
						_focusObj = findObject(se.label);
						if (!_focusObj) {
							_init = true;
							throwError();
							return;
						}
						_focusObj.visible = true;
						_focusObj.alpha = 1;
						_focusObj.num = FlxG.elapsed / se.time;
						_init = true;
					}
					else {
						_focusObj.alpha -= _focusObj.num;
						if (_focusObj.alpha <= 0) {
							_focusObj.alpha = 0;
							inc();
							_focusObj.visible = false;
						}
					}
				}break;
				case StateEvent.fadeobjin: {
					if (!_init) {
						_focusObj = findObject(se.label);
						if (!_focusObj) {
							_init = true;
							throwError();
							return;
						}
						_focusObj.visible = true;
						_focusObj.alpha = 0;
						_focusObj.num = FlxG.elapsed / se.time;
						_init = true;
					}
					else {
						_focusObj.alpha += _focusObj.num;
						if (_focusObj.alpha >= 1) {
							_focusObj.alpha = 1;
							inc();
						}
					}
				}break;
				case StateEvent.shatter: {
					_shatter.start(true, 2.25);
					sfx.playExplosionSFX();
					inc();
				}break;
			}
			
			super.update();
		}
		
		override public function draw():void {
			_window.draw();
			super.draw();
			_shatter.draw();
			if (fade.visible)
				fade.draw();
		}
		
		////////////////////////////////////////////
		// Functions called for executing action  //
		////////////////////////////////////////////
		
		protected function findChar(label:String):Character {
			var i:int = 0;
			var l:int = _chars.length;
			
			while (i < l) {
				var char:Character = _chars[i++] as Character;
				if (char && char.label == label)
					return char;
			}
			return null;
		}
		protected function findObject(label:String):BaseObject {
			var i:int = 0;
			var l:int = _chars.length;
			
			while (i < l) {
				var obj:BaseObject = _chars[i++] as BaseObject;
				if (obj && obj.label == label)
					return obj;
			}
			return null;
		}
		protected function findBase(label:String):Base {
			var i:int = 0;
			var l:int = _chars.length;
			
			while (i < l) {
				var base:Base = _chars[i++] as Base;
				if (base && base.label == label)
					return base;
			}
			return null;
		}
		
		private function gotoLabel(label:String):Boolean {
			var i:int = _current+1;
			var se:StateEvent;
			
			while (i != _current) {
				se = _list[i++]
				if (se.event != StateEvent.marker)
					continue;
				if (se.label == label) {
					_current = i;
					return true;
				}
				if (i == _max)
					i = 0;
			}
			return false;
		}
		
		private function throwError():void {
			kill();
			FlxG.flash();
			add(new FlxText(10, 32, FlxG.width - 64, "ERROR!ERROR!ERROR!ERROR!ERROR!ERROR!ERROR!ERROR!ERROR!ERROR!ERROR!ERROR!"));
		}
		
		private function inc():void {
			_current++;
			_init = false;
		}
		
		private function textMenuCallback(tm:TextMenu):void {
			if (tm.selected) {
				sfx.playSelectedSFX();
				gotoLabel(_curMarkers[tm.current]);
				tm.kill();
				_init = false;
			}
			else
				sfx.playOptionSFX();
		}
		
		//////////////////////////////////////////////
		// Functions for modifying visual/cur mobs  //
		//////////////////////////////////////////////
		
		protected function clearScene():void {
			kill();
			revive();
			while (_chars.length > 0)
				_chars.pop();
			while (_list.length > 0)
				_stateEvent.push(_list.pop());
			_current = 0;
			_max = 0;
			_init = false;
			_id = 0;
		}
		
		protected function showScene(n:uint):void {
			var tm:BGtilemap;
			var s:BGsprite;
			var b:Base;
			
			switch(n) {
				case s0_dream:
				case s5_dream: {
					sfx.playDreamSong();
					s = recycle(BGsprite) as BGsprite;
					s.reset(0, 0);
					s.loadGraphic(gfx.dream_bg);
					s.ID = _id++;
					b = addBase(Character, "player", 64, 26, true, FlxObject.RIGHT);
					b.load(gfx.player_gfx, 32, 24, true);
					b.play("sleep");
					
					b = addBase(BaseObject, "joker", 25, 11, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 0;
					if (n == s5_dream) {
						b.x = 64;
						b.y = 33;
					}
					b = addBase(BaseObject, "wall", 129, 11, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 2;
					if (n == s5_dream) {
						b.x = 64;
						b.y = 33;
					}
					b = addBase(BaseObject, "owl", 75, 61, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 4;
					if (n == s5_dream) {
						b.x = 64;
						b.y = 33;
					}
					
					// TODO add particles emitter
					
					s = recycle(BGsprite) as BGsprite;
					s.reset(58, 0);
					s.loadGraphic(gfx.dream_fg);
					s.ID = _id++;
				}break;
				case s1_home: {
					sfx.playHomeSong();
					s = recycle(BGsprite) as BGsprite;
					s.reset(0, 0);
					s.loadGraphic(gfx.home_bg);
					s.ID = _id++;
					b = addBase(Character, "player", 6, 49, true, FlxObject.RIGHT);
					b.load(gfx.player_gfx, 32, 24, true);
					b.play("sleep");
					s = recycle(BGsprite) as BGsprite;
					s.reset(18, 55);
					s.loadGraphic(gfx.home_fg);
					s.ID = _id++;
					b = addBase(Character, "wife", 149, 48, true, FlxObject.LEFT);
					b.load(gfx.wife_gfx, 32, 24, true);
					b.play("stand");
					
					b = addBase(BaseObject, "joker", 6, 48, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 1;
					b = addBase(BaseObject, "wall", 6, 48, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 3;
					b = addBase(BaseObject, "owl", 6, 48, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 5;
					
					_shatter.x = 6+11;
					_shatter.y = 48+13;
				}break;
				case s2_work: {
					sfx.playWorkSong();
					s = recycle(BGsprite) as BGsprite;
					s.reset(0, 0);
					s.loadGraphic(gfx.work_bg_gfx);
					s.ID = _id++;
					b = addBase(Character, "boss", 73, 44, true, FlxObject.RIGHT);
					b.load(gfx.boss_gfx, 32, 24, true);
					b.play("stand");
					s = recycle(BGsprite) as BGsprite;
					s.reset(32, 43);
					s.loadGraphic(gfx.work_fg_gfx);
					s.ID = _id++;
					b = addBase(Character, "player", 149, 44, true, FlxObject.LEFT);
					b.load(gfx.player_gfx, 32, 24, true);
					b.play("stand");
					
					b = addBase(BaseObject, "joker", 94, 43, false, FlxObject.LEFT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 0;
					b = addBase(BaseObject, "wall", 94, 43, false, FlxObject.LEFT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 2;
					b = addBase(BaseObject, "owl", 94, 43, false, FlxObject.LEFT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 4;
					
					_shatter.x = 95+16;
					_shatter.y = 43+6;
				}break;
				case s3_work: {
					sfx.playWorkSong();
					s = recycle(BGsprite) as BGsprite;
					s.reset(0, 0);
					s.loadGraphic(gfx.work_bg_gfx);
					s.ID = _id++;
					b = addBase(Character, "player", 34, 40, true, FlxObject.RIGHT);
					b.load(gfx.player_gfx, 32, 24, true);
					b.play("stand");
					s = recycle(BGsprite) as BGsprite;
					s.reset(32, 43);
					s.loadGraphic(gfx.work_fg_gfx);
					s.ID = _id++;
					b = addBase(Character, "boss", -23, 45, true, FlxObject.LEFT);
					b.load(gfx.boss_gfx, 32, 24, true);
					b.play("stand");
					
					b = addBase(BaseObject, "joker", 34, 39, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 0;
					b = addBase(BaseObject, "wall", 34, 39, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 2;
					b = addBase(BaseObject, "owl", 34, 39, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 4;
					
					_shatter.x = 34+16;
					_shatter.y = 39+6;
				}break;
				case s4_bar: {
					sfx.playBarSong();
					s = recycle(BGsprite) as BGsprite;
					s.reset(0, 0);
					s.loadGraphic(gfx.bar_bg_gfx);
					s.ID = _id++;
					
					b = addBase(Character, "bartender", 89, 40, true, FlxObject.LEFT);
					b.load(gfx.bartender_gfx, 32, 24, true);
					b.play("stand");
					
					s = recycle(BGsprite) as BGsprite;
					s.reset(59, 54);
					s.loadGraphic(gfx.bar_fg_gfx);
					s.ID = _id++;
					
					b = addBase(Character, "boss", 79, 45, true, FlxObject.LEFT);
					b.load(gfx.boss_gfx, 32, 24, true);
					b.play("sit");
					b = addBase(Character, "player", 55, 45, true, FlxObject.RIGHT);
					b.load(gfx.player_gfx, 32, 24, true);
					b.play("sit");
					
					b = addBase(BaseObject, "joker", 55, 44, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 0;
					b = addBase(BaseObject, "wall", 55, 44, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 2;
					b = addBase(BaseObject, "owl", 55, 44, false, FlxObject.RIGHT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 4;
					
					_shatter.x = 55+16;
					_shatter.y = 44+6;
				}break;
				case s4_home: {
					sfx.playHomeSong();
					s = recycle(BGsprite) as BGsprite;
					s.reset(0, 0);
					s.loadGraphic(gfx.home_bg);
					s.ID = _id++;
					s = recycle(BGsprite) as BGsprite;
					s.reset(18, 55);
					s.loadGraphic(gfx.home_fg);
					s.ID = _id++;
					b = addBase(Character, "wife", 55, 48, true, FlxObject.RIGHT);
					b.load(gfx.wife_gfx, 32, 24, true);
					b.play("stand");
					b = addBase(Character, "player", 157, 48, true, FlxObject.LEFT);
					b.load(gfx.player_gfx, 32, 24, true);
					b.play("stand");
					
					b = addBase(BaseObject, "joker", 87, 47, false, FlxObject.LEFT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 0;
					b = addBase(BaseObject, "wall", 87, 47, false, FlxObject.LEFT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 2;
					b = addBase(BaseObject, "owl", 87, 47, false, FlxObject.LEFT);
					b.load(gfx.personae_gfx, 32, 25, true);
					b.frame = 4;
					
					_shatter.x = 87+16;
					_shatter.y = 47+6;
				}break;
			}
		}
		
		protected function addBase(type:Class, label:String, X:Number, Y:Number, Visible:Boolean, facing:uint):Base {
			var base:Base = recycle(type) as Base;
			base.reset(X, Y);
			base.visible = Visible;
			base.label = label;
			base.facing = facing;
			base.ID = _id++;
			_chars.push(base);
			return base;
		}
		
		///////////////////////////////////////////////
		// Functions for creating scripted sequence  //
		///////////////////////////////////////////////
		
		protected function get complete():Boolean {
			return _current == _max;
		}
		
		/**
		 * 
		 * @param	label
		 * @param	X
		 * @param	Y
		 * @param	time
		 */
		protected function addMoveCharTo(label:String, X:Number, Y:Number, time:Number):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.moveChar;
			se.label = label;
			se.x = X;
			se.y = Y;
			se.time = time;
			_list.push(se);
		}
		
		protected function addSayChar(label:String, text:String, type:uint):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.sayChar;
			se.label = label;
			se.text = text
			se.type = type;
			_list.push(se);
		}
		
		protected function addPutLabel(label:String):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.marker;
			se.label = label;
			_list.push(se);
		}
		
		protected function addGotoLabel(label:String):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.goto;
			se.label = label;
			_list.push(se);
		}
		
		protected function addGotoLabelIf(label:String, f:Function):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.gotoif;
			se.label = label;
			se.f = f;
			_list.push(se);
		}
		
		protected function addCallFunction(label:String, f:Function):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.call;
			se.label = label; // NOTE label here for debugging only
			se.f = f;
			_list.push(se);
		}
		
		protected function addShowOptions(label:String, options:Array, markers:Array):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.showOptions;
			se.label = label;
			se.options = options;
			se.markers = markers;
			se.y = 75+8;
			_list.push(se);
		}
		
		protected function addFadeout(label:String, time:uint):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.fadeout;
			se.label = label;
			se.time = time;
			_list.push(se);
		}
		
		protected function addFadein(label:String, time:uint):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.fadein;
			se.label = label;
			se.time = time;
			_list.push(se);
		}
		
		protected function addFadeoutObj(label:String, time:uint):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.fadeobjout;
			se.label = label;
			se.time = time;
			_list.push(se);
		}
		
		protected function addFadeinObj(label:String, time:uint):void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.fadeobjin;
			se.label = label;
			se.time = time;
			_list.push(se);
		}
		
		protected function addShatter():void {
			var se:StateEvent = getStateEvent();
			se.event = StateEvent.shatter;
			_list.push(se);
		}
		
		////////////////////////////////////
		// Always make pools of objects!  //
		////////////////////////////////////
		
		private function getStateEvent():StateEvent {
			_max++;
			if (_stateEvent.length > 0)
				return _stateEvent.pop().clear();
			return (new StateEvent()).clear();
		}
	}
}

class StateEvent {
	
	///////////////////////////
	// Possible event types  //
	///////////////////////////
	
	static public const moveChar:uint =	0x0001;
	static public const sayChar:uint=	0x0002;
	static public const marker:uint	=	0x0003;
	static public const goto:uint	=	0x0004;
	static public const gotoif:uint	=	0x0005;
	static public const call:uint	=	0x0006;
	static public const showOptions:uint=0x0007;
	static public const fadeout:uint=	0x0008;
	static public const fadein:uint	=	0x0009;
	static public const fadeobjout:uint=0x000a;
	static public const fadeobjin:uint=	0x000b;
	static public const shatter:uint=	0x000c;
	
	/**
	 * Event type
	 */
	public var event:uint;
	/**
	 * Label for referenced object
	 */
	public var label:String;
	/**
	 * Referenced object x position.
	 */
	public var x:Number;
	/**
	 * Referenced object y position.
	 */
	public var y:Number;
	/**
	 * Whether more than one event might occur at the same time (not implemented)
	 */
	public var blocking:Boolean;
	/**
	 * Used with 'sayChar'. Text to be written on screen.
	 */
	public var text:String;
	/**
	 * 'sayChar': type of ballon to be shown;
	 */
	public var type:uint;
	/**
	 * 'moveChar': how long should moving take;
	 */
	public var time:Number;
	/**
	 * 'gotoif': Function that returns true if should jump;
	 * 'call': Function to be called (can play song, flash the screen, etc);
	 */
	public var f:Function;
	/**
	 * 'showOptions': Possible options;
	 */
	public var options:Array;
	/**
	 * 'showOptions': Markers for "going to" when a option is selected;
	 */
	public var markers:Array
	
	public function clear():StateEvent {
		event = 0;
		label = "";
		x = 0;
		y = 0;
		blocking = true;
		text = "";
		type = 0;
		time = 0;
		f = null;
		while (options && options.length > 0)
			options.pop();
		options = null;
		while (markers && markers.length > 0)
			markers.pop();
		markers = null;
		
		return this;
	}
}
