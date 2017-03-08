package utils {
	import org.flixel.FlxG;
	import org.si.sion.SiONData;
	import org.si.sion.SiONDriver;
	/**
	 * ...
	 * @author 
	 */
	public class SFX {
		
		[Embed(source = "../../assets/sfx/mp3/step02.mp3")]		private var mp3_step:Class;
		[Embed(source = "../../assets/sfx/mp3/type01.mp3")]		private var mp3_type:Class;
		[Embed(source = "../../assets/sfx/mp3/moveSelection.mp3")]		private var mp3_option:Class;
		[Embed(source = "../../assets/sfx/mp3/selected.mp3")]	private var mp3_selected:Class;
		[Embed(source = "../../assets/sfx/mp3/explosion03.mp3")]	private var mp3_explosion:Class;
		
		[Embed(source = "../../assets/sfx/vmml/song-dream.txt", mimeType = "application/octet-stream")]		private var vmml_dream:Class;
		[Embed(source = "../../assets/sfx/vmml/song-home.txt", mimeType = "application/octet-stream")]		private var vmml_home:Class;
		[Embed(source = "../../assets/sfx/vmml/song-work.txt", mimeType = "application/octet-stream")]		private var vmml_work:Class;
		[Embed(source = "../../assets/sfx/vmml/song-bar.txt", mimeType = "application/octet-stream")]		private var vmml_bar:Class;
		private var vmml_menu:Class = null;
		
		static public const self:SFX = new SFX();
		
		public var curSong:int = -1;
		public var songVol:Number = 1.0;
		public var sfxVol:Number = 0.6;
		
		private var driver:SiONDriver;
		private var dream_song:SiONData;
		private var home_song:SiONData;
		private var work_song:SiONData;
		private var bar_song:SiONData;
		private var menu_song:SiONData;
		
		public function playDreamSong():void {
			playSong(0, dream_song);
			driver.autoStop = false;
		}
		public function playHomeSong():void {
			playSong(1, home_song);
			driver.autoStop = false;
		}
		public function playWorkSong():void {
			if (!work_song)
				return;
			playSong(2, work_song);
			driver.autoStop = false;
		}
		public function playBarSong():void {
			if (!bar_song)
				return;
			playSong(3, bar_song);
			driver.autoStop = false;
		}
		public function playMenuSong():void {
			//if (!menu_song)
			//	return;
			//playSong(4, menu_song);
			playSong(3, bar_song);
			driver.autoStop = false;
		}
		
		public function playTextSFX():void {
			FlxG.loadSound(mp3_type, sfxVol, false, true, true);
		}
		public function playStepSFX():void {
			FlxG.loadSound(mp3_step, sfxVol, false, true, true);
		}
		public function playOptionSFX():void {
			FlxG.loadSound(mp3_option, sfxVol, false, true, true);
		}
		public function playSelectedSFX():void {
			FlxG.loadSound(mp3_selected, sfxVol, false, true, true);
		}
		public function playExplosionSFX():void {
			FlxG.loadSound(mp3_explosion, sfxVol, false, true, true);
		}
		
		public function get playing():Boolean {
			if (driver)
				return driver.isPlaying;
			return false;
		}
		public function get finished():Boolean {
			if (driver)
				return !driver.isPlaying;
			return true;
		}
		public function set volume(val:Number):void {
			if (driver)
				driver.volume = val;
			sfxVol = val;
		}
		public function resumeMusic():void {
			if (driver && driver.isPaused)
				driver.resume();
		}
		public function stopMusic():void {
			if (driver && driver.isPlaying)
				driver.stop();
		}
		public function pauseMusic():void {
			if (driver && driver.isPlaying)
				driver.pause();
		}
		
		private function playSong(i:int, song:SiONData):void {
			if (curSong == i)
				return;
			curSong = i;
			driver.play(song);
			driver.volume = FlxG.volume;
			if (FlxG.mute)
				driver.pause();
		}
		
		public function init():void {
			var tmp:String;
			var arr:Array;
			var buf:String;
			
			driver = new SiONDriver();
			driver.volume = songVol;
			
			// loads dream
			tmp = new vmml_dream;
			buf = "";
			arr = tmp.split("\n");
			for each (tmp in arr) {
				if (tmp.indexOf("//") == 0)
					continue;
				buf += tmp;
			}
			dream_song = driver.compile(buf);
			// loads home
			tmp = new vmml_home;
			buf = "";
			arr = tmp.split("\n");
			for each (tmp in arr) {
				if (tmp.indexOf("//") == 0)
					continue;
				buf += tmp;
			}
			home_song = driver.compile(buf);
			// loads work
			if (vmml_work) {
				tmp = new vmml_work;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				work_song = driver.compile(buf);
			}
			// loads bar
			if (vmml_bar) {
				tmp = new vmml_bar;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				bar_song = driver.compile(buf);
			}
			// loads menu
			if (vmml_menu) {
				tmp = new vmml_menu;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				menu_song = driver.compile(buf);
			}
		}
	}
}
