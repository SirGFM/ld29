package utils {
	/**
	 * ...
	 * @author 
	 */
	public class GFX {
		
		static public const self:GFX = new GFX();
		
		[Embed(source = "../../assets/gfx/window.png")]	public var window_gfx:Class;
		[Embed(source = "../../assets/tilemaps/window-tm.txt", mimeType = "application/octet-stream")]	public var window_tm:Class;
		
		// Title:
		[Embed(source = "../../assets/gfx/placeholder/title.png")]	public var title:Class;
		// Misc:
		[Embed(source = "../../assets/gfx/personae.png")]	public var personae_gfx:Class;
		[Embed(source = "../../assets/gfx/shatter.png")]	public var shatter_gfx:Class;
		// Characters:
		[Embed(source = "../../assets/gfx/player.png")]	public var player_gfx:Class;
		[Embed(source = "../../assets/gfx/wife.png")]	public var wife_gfx:Class;
		[Embed(source = "../../assets/gfx/boss.png")]	public var boss_gfx:Class;
		[Embed(source = "../../assets/gfx/bartender.png")]	public var bartender_gfx:Class;
		// Dream Scene:
		[Embed(source = "../../assets/gfx/dream-bg.png")]	public var dream_bg:Class;
		[Embed(source = "../../assets/gfx/dream-fg.png")]	public var dream_fg:Class;
		// Dream Scene:
		[Embed(source = "../../assets/gfx/placeholder/home-bg.png")]	public var home_bg:Class;
		[Embed(source = "../../assets/gfx/placeholder/home-fg.png")]	public var home_fg:Class;
		// Work Scene:
		[Embed(source = "../../assets/gfx/work-bg.png")]	public var work_bg_gfx:Class;
		[Embed(source = "../../assets/gfx/work-fg.png")]	public var work_fg_gfx:Class;
		// Bar Scene:
		[Embed(source = "../../assets/gfx/bar-bg.png")]		public var bar_bg_gfx:Class;
		[Embed(source = "../../assets/gfx/bar-fg.png")]		public var bar_fg_gfx:Class;
		
		public const text_color:uint = 0xffffff;
		public const text_shadow:uint = 0xaaaaaaaa;
		public const text_midcolor:uint = 0xffdddddd;
		public const text_bgcolor:uint = 0xffc0c0c0;
		public const text_color_thought:uint = 0xffddddff;
		public const text_shadow_though:uint = 0xaa8888aa;
		public const text_color_angry:uint = 0xffffdddd;
		public const text_shadow_angry:uint = 0xaaaa8888;
	}
}
