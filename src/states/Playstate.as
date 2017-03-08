package states {
	
	import objs.base.Base;
	import objs.BaseObject;
	import objs.BGsprite;
	import objs.Character;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import utils.TextWindow;
	/**
	 * ...
	 * @author 
	 */
	public class Playstate extends Basestate {
		
		private var _scene:uint;
		
		private var _jokerOK:Boolean;
		private var _wallOK:Boolean;
		private var _owlOK:Boolean;
		
		override public function create():void {
			super.create();
			
			_scene = s0_dream;
			//FlxG.timeScale = 4;
			
			var cam:FlxCamera = new FlxCamera(0, 0, 160, 75, 4);
			cam.bgColor = 0xffff0000;
			cam.scroll.make(0, 0);
			FlxG.resetCameras(cam);
			cam = new FlxCamera(0, 300, 320, 90, 2);
			cam.bgColor = 0xff5a729b;
			cam.scroll.make(0, 75);
			FlxG.addCamera(cam);
			
			_jokerOK = true;
			_wallOK = true;
			_owlOK = true;
		}
		
		override public function update():void {
			if (complete) {
				clearScene();
				showScene(_scene);
				switch (_scene) {
					case s0_dream: {
						scene00_dream();
					} break;
					case s1_home: {
						scene01_home();
					} break;
					case s2_work: {
						scene02_work();
					} break;
					case s3_work: {
						scene03_work();
					} break;
					case s4_bar: {
						scene04_bar();
					} break;
					case s4_home: {
						scene04_home();
					} break;
					case s5_dream: {
						scene05_dream();
					} break;
				}
			}
			super.update();
		}
		
		protected function scene00_dream():void {
			addFadein("s0-fadein", 1);
			addSayChar("", "What have we gotten here?          \nDid you forget who you are?", TextWindow.thougth);
			addSayChar("", "Humans are indeed complex creatures...          \nThey don't always show their core to others.", TextWindow.thougth);
			addSayChar("", "After hiding their true fellings for too long, it's not uncommon for them to get lost.", TextWindow.thougth);
			addSayChar("", "Luckily, I have a few gifts that shall be of help to you.", TextWindow.thougth);
			addSayChar("", "Take these masks. Wearing one will change your persona, so that you'll once again be able to behave as usual in front of others.", TextWindow.thougth);
			addFadeinObj("joker", 1);
			addSayChar("", "This first one it the JOKER. Use this when you are the most at ease.", TextWindow.thougth);
			addMoveCharTo("joker", 64, 33, 2);
			addFadeoutObj("joker", 1);
			addFadeinObj("wall", 1);
			addSayChar("", "Next it the WALL. If you feel insecure, of even afraid that your feeling or opinions might hurt those near to you, wear this to shield your feelings.", TextWindow.thougth);
			addMoveCharTo("wall", 64, 33, 2);
			addFadeoutObj("wall", 1);
			addFadeinObj("owl", 1);
			addSayChar("", "Finally, take the OWL. When you must use all your knowledge and logical reasoning, this one shall assist you.", TextWindow.thougth);
			addMoveCharTo("owl", 64, 33, 2);
			addFadeoutObj("owl", 1);
			addSayChar("", "Beware, though, that misusing the personae will shatter them. After that, you'll be left only with your true self.", TextWindow.thougth);
			addSayChar("", "Enough, already.           \nWake up, little one, and make good use of those gifts.", TextWindow.thougth);
			addFadeout("s0-fadeout", 1);
			addCallFunction("s0-next-scene", function():void { _scene = s1_home; } );
		}
		
		protected function scene01_home():void {
			var arr:Array = ["JOKER", "WALL", "OWL"];
			
			addFadein("s1-fadein", 1);
			addMoveCharTo("wife", 45, 48, 4.5);
			addCallFunction("wake-player", function():void { var b:Character = findChar("player"); b.play("wakeup"); } );
			addSayChar("wife", "Oh, you're finally awake. I was starting to get worried, since you're late and wouldn't answer my calls...", TextWindow.normal);
			addSayChar("wife", "Anything wrong? You're quieter than usual...", TextWindow.normal);
			addShowOptions("player", getPersonArr(arr, "SELF"), arr);
		addPutLabel("JOKER");
			addFadeinObj("joker", 1);
			addSayChar("player", "For one moment I thought that the dream-world had finally became one with the real word...", TextWindow.normal);
			addSayChar("wife", "That wasn't funny, it was just stupid... And what's with you making jokes like that? You're usually less talkative... Something must have happened...", TextWindow.normal);
			addCallFunction("s1-shatter-joker", function():void { _jokerOK = false; } );
			addShatter();
			addFadeoutObj("joker", 0.5);
			addGotoLabel("SELF");
		addPutLabel("WALL");
			addFadeinObj("wall", 1);
			addSayChar("player", "Nothing to worry about. I was just in a deep sleep... Sorry for worrying you.", TextWindow.normal);
			addSayChar("wife", "Good to know. Try not to stay awake until late at night and this might not happen." , TextWindow.normal);
			addFadeoutObj("wall", 1);
			addGotoLabel("END");
		addPutLabel("OWL");
			addFadeinObj("owl", 1);
			addSayChar("player", "I was in a weird place. it seemed too real to be a dream. There, I regained something once lost....", TextWindow.normal);
			addSayChar("wife", "Right... So what you're saying is that you didn't want to wake up from a dream...", TextWindow.normal);
			addCallFunction("s1-shatter-owl", function():void { _owlOK = false; } );
			addShatter();
			addFadeoutObj("owl", 0.5);
			addGotoLabel("SELF");
		addPutLabel("SELF");
			addSayChar("player", "I... don't know...", TextWindow.normal);
			addSayChar("player", "I didn't even hear the alarm clock... nor did I heard you...", TextWindow.normal);
			addSayChar("player", "Sorry... I was just in a deep sleep... I think...", TextWindow.normal);
			addSayChar("wife", "No need to get like that. It happens, sometimes... I think.", TextWindow.normal);
			addSayChar("wife", "Just try not to stay awake until late at night and this might not happen." , TextWindow.normal);
		addPutLabel("END");
			addSayChar("wife", "Well, what matter now is that you're awake now... And late! Hurry up and go work at once!", TextWindow.normal);
			addFadeout("s1-fadeout", 1);
			addCallFunction("s1-next-scene", function():void { _scene = s2_work; } );
		}
		
		private function scene02_work():void {
			var arr:Array = ["JOKER", "WALL", "OWL"];
			
			addFadein("s2-fadein", 1);
			addMoveCharTo("player", 95, 44, 3);
			addSayChar("boss", "So you finally decided to appear?     \nWell, better late than never...", TextWindow.angry);
			addSayChar("boss", "But avoid this at all cost. Things have being hectic without anyone pulling one of those stunts.", TextWindow.normal);
			addSayChar("boss", "Remember that project we've been working on? Well, turns out it's due today today. Go to your desk at once!", TextWindow.normal);
			addShowOptions("player", getPersonArr(arr, "SELF"), arr);
		addPutLabel("JOKER");
			addFadeinObj("joker", 1);
			addSayChar("player", "You see, sometime ago I though on the solution to the main problem on that project!", TextWindow.normal);
			addSayChar("player", "Let's just erase everything and, by trival solution, there'll no problem left. It's as simples as that.", TextWindow.normal);
			addSayChar("boss", "Now is not the time for jokes! Hurry to your desk and only leave it to tell me the project is finished!", TextWindow.angry);
			addCallFunction("s1-shatter-joker", function():void { _jokerOK = false; } );
			addShatter();
			addFadeoutObj("joker", 0.5);
			addGotoLabel("SELF");
		addPutLabel("WALL");
			addFadeinObj("wall", 1);
			addSayChar("player", "Isn't there another one to do that? I'm no sure I'll be able to handle it in time...", TextWindow.normal);
			addSayChar("boss", "Didn't we hire you to do this job? No complaints now!", TextWindow.angry);
			addSayChar("boss", "Also, no used being humble. We are sure you will be able to finish it in time.", TextWindow.normal);
			addCallFunction("s1-shatter-wall", function():void { _wallOK = false; } );
			addShatter();
			addFadeoutObj("wall", 0.5);
			addGotoLabel("SELF");
		addPutLabel("OWL");
			addFadeinObj("owl", 1);
			addSayChar("player", "I'll do everything on my reach. If it can be done, then we will do so in due time!", TextWindow.normal);
			addSayChar("boss", "Good to hear! I'm waiting your call!", TextWindow.normal);
			addFadeoutObj("owl", 1);
			addGotoLabel("END");
		addPutLabel("SELF");
			addSayChar("player", "Ok... sorry... I'll do my best!", TextWindow.normal);
		addPutLabel("END");
			addFadeout("s2-fadeout", 1);
			addCallFunction("s2-next-scene", function():void { _scene = s3_work; } );
		}
		
		private function scene03_work():void {
			var arr:Array = ["JOKER", "WALL", "OWL"];
			
			addFadein("s3-fadein", 1);
			
			addSayChar("player", "It's finally time to go back home.", TextWindow.thougth);
			addSayChar("player", "I'm tired, but happy that we were able to finish that in time.", TextWindow.thougth);
			addMoveCharTo("boss", 56, 45, 2);
			addCallFunction("boss-turn", function():void { findChar("boss").facing = FlxObject.LEFT; } );
			addSayChar("boss", "Hey! Good job!", TextWindow.normal);
			addSayChar("boss", "We are going to the bar celebrate the conclusion of that project. Want to come?", TextWindow.normal);
			addShowOptions("player", getPersonArr(arr, "SELF"), arr);
		addPutLabel("JOKER");
			addFadeinObj("joker", 1);
			addSayChar("player", "So that's how it is? I was part of that but you were about to leave without calling me? Haha.", TextWindow.normal);
			addSayChar("player", "I'll be right there with you guys!", TextWindow.normal);
			addSayChar("boss", "That's what I'm talking about! Let's go already!", TextWindow.normal);
			addCallFunction("s3-next-scene-bar", function():void { _scene = s4_bar; } );
			addFadeoutObj("joker", 1);
			addGotoLabel("END");
		addPutLabel("WALL");
			addFadeinObj("wall", 1);
			addSayChar("player", "Sorry, I'm tired right now... I'm also not really in the mood to hanging out...", TextWindow.normal);
			addSayChar("boss", "Fine, man... But you should at least be sincere with your self.", TextWindow.normal);
			addCallFunction("s1-shatter-wall", function():void { _wallOK = false; } );
			addShatter();
			addFadeoutObj("wall", 0.5);
			addGotoLabel("SELF");
		addPutLabel("OWL");
			addFadeinObj("owl", 1);
			addSayChar("player", "I'll pass. There'll be an even more troublesome project soon, right? I want to rest and be prepared for it", TextWindow.normal);
			addSayChar("boss", "If you are trying to blow way our will to party, bad luck, pal.", TextWindow.normal);
			addCallFunction("s1-shatter-owl", function():void { _owlOK = false; } );
			addShatter();
			addFadeoutObj("owl", 0.5);
			addGotoLabel("SELF");
		addPutLabel("SELF");
			addSayChar("player", "No, realy... I'm tired...", TextWindow.normal);
			addSayChar("player", "I wouldn't mind hanging out with you guys, but I'd prefer to stay at home, resting...", TextWindow.normal);
			addSayChar("boss", "Well, OK then... Anyway, we are going.", TextWindow.normal);
			addCallFunction("s3-next-scene-home", function():void { _scene = s4_home; } );
		addPutLabel("END");
			addFadeout("s3-fadeout", 1);
		}
		
		protected function scene04_bar():void {
			var arr:Array = ["JOKER", "WALL", "OWL"];
			
			addFadein("s4-2-fadein", 1);
			addSayChar("boss", "Nothing like relaxing after such a troublesome thing. Of course, there will be other and this probably won't be the last project to get behind the schedule...", TextWindow.normal);
			addSayChar("boss", "Still, now is not the time to get worried. We should just enjoy that we completed that project.", TextWindow.normal);
			addSayChar("boss", "...", TextWindow.normal);
			addSayChar("boss", "Say... I noticed you aren't drink. Got something on your mind?", TextWindow.normal);
			addShowOptions("player", getPersonArr(arr, "SELF"), arr);
		addPutLabel("JOKER");
			addFadeinObj("joker", 1);
			addSayChar("player", "I wasn't going to drink because of work tomorrow... but we should just forget that and celebrate, right?", TextWindow.normal);
			addSayChar("boss", "Just don't drink so much that you won't be able to work tomorrow. Haha.", TextWindow.normal);
			addFadeoutObj("joker", 1);
			addGotoLabel("END");
		addPutLabel("WALL");
			addFadeinObj("wall", 1);
			addSayChar("player", "Well...", TextWindow.normal);
			addSayChar("player", "...", TextWindow.normal);
			addSayChar("boss", "If you didn't want to come in the first place, you hadn't to, you know right?", TextWindow.normal);
			addCallFunction("s1-shatter-wall", function():void { _wallOK = false; } );
			addShatter();
			addFadeoutObj("wall", 0.5);
			addGotoLabel("END");
		addPutLabel("OWL");
			addFadeinObj("owl", 1);
			addSayChar("player", "I just don't want to drink, as tomorrow we've got to work again...", TextWindow.normal);
			addSayChar("boss", "If you didn't want to come in the first place, you hadn't to, you know right?", TextWindow.normal);
			addShatter();
			addFadeoutObj("owl", 0.5);
			addSayChar("player", "I know... And... it isn't because I'm not drinking that we can't have fun...", TextWindow.normal);
			addSayChar("player", "But, I gotta say that I'm kinda tired... I think I'll leave already...", TextWindow.normal);
		addPutLabel("SELF");
			addSayChar("player", "But, I gotta say that I'm kinda tired... I think I'll leave already...", TextWindow.normal);
		addPutLabel("END");
			addFadeout("s4-2-fadeout", 1);
			addCallFunction("s4-2-next-scene", function():void { _scene = s5_dream; } );
		}
		
		protected function scene04_home():void {
			var arr:Array = ["JOKER", "WALL", "OWL"];
			
			addFadein("s4-fadein", 1);
			addMoveCharTo("player", 87, 48, 2);
			addSayChar("wife", "Oh!    \nHome already!", TextWindow.normal);
			addSayChar("wife", "I was sure you were going to hangout with the people from work.", TextWindow.normal);
			addShowOptions("player", getPersonArr(arr, "SELF"), arr);
		addPutLabel("JOKER");
			addFadeinObj("joker", 1);
			addSayChar("player", "Hangout with those bunch of losers? Nah, not in the mood.", TextWindow.normal);
			addSayChar("wife", "Don't even joke like that! Ther are nice people and I know you like them all!", TextWindow.normal);
			addCallFunction("s1-shatter-joker", function():void { _jokerOK = false; } );
			addShatter();
			addFadeoutObj("joker", 0.5);
			addGotoLabel("SELF");
		addPutLabel("WALL");
			addFadeinObj("wall", 1);
			addSayChar("player", "I didn't want to go all that much...", TextWindow.normal);
			addSayChar("wife", "Which meand you prefered to stay here at home, right? I find that cure in you.", TextWindow.normal);
			addFadeoutObj("wall", 1);
			addGotoLabel("END");
		addPutLabel("OWL");
			addFadeinObj("owl", 1);
			addSayChar("player", "Today isn't even the weekend. I'm not going to a bar if I have to work on the next day", TextWindow.normal);
			addSayChar("wife", "As if this would be enough to stop you if you really wanted to go...", TextWindow.normal);
			addCallFunction("s1-shatter-owl", function():void { _owlOK = false; } );
			addShatter();
			addFadeoutObj("owl", 0.5);
			addGotoLabel("SELF");
		addPutLabel("SELF");
			addSayChar("wife", "Well, what matter is that you are here and we are happy.", TextWindow.normal);
		addPutLabel("END");
			addFadeout("s4-fadeout", 1);
			addCallFunction("s4-next-scene", function():void { _scene = s5_dream; } );
		}
		
		private function scene05_dream():void {
			addFadein("s5-fadein", 1);
			addSayChar("", "How was it?", TextWindow.thougth);
			addSayChar("", "Did using those personas helped you remember who you really are?", TextWindow.thougth);
			addGotoLabelIf("BROKEN", function():Boolean { return !(_owlOK && _wallOK && _jokerOK); } );
			addSayChar("", "At least you did remember how to change your persona. Just try no to over do it again.", TextWindow.thougth);
			addSayChar("", "Did you really have to keep yourself behind masks all this time?    \nPerhaps, that's really part of youself...", TextWindow.thougth);
			addSayChar("", "Even if you weren't like thaat, you made yourself into that. So, no one can say it aint your true self.", TextWindow.thougth);
			addGotoLabel("CONT");
		addPutLabel("BROKEN");
			addSayChar("", "You may have failed to use the personas sometimes... But what happened then? Those around you noticed you weren't being yourself, right?", TextWindow.thougth);
			addSayChar("", "They looked into you, through the mask. And that helped you to be yourself, right?", TextWindow.thougth);
			addSayChar("", "This doesn't mean you weren't still wearing a mask... Humans are just like that. They doesn't usually feel comfortable when being looked their inner selves...", TextWindow.thougth);
			addSayChar("", "They may pretend, choose the best way to phrase what they want to say, keep quiet... Anything to avoid having it's core revealed.", TextWindow.thougth);
			addSayChar("", "In order for them to bear each other, this became a necessary skill. No one is really to blame.", TextWindow.thougth);
		addPutLabel("CONT");
			addSayChar("", "Now...        \nI don't think you'll be needing those masks anymore right?", TextWindow.thougth);
			addFadeinObj("joker", 1);
			addMoveCharTo("joker", -40, 0, 2);
			addFadeinObj("wall", 1);
			addMoveCharTo("wall", FlxG.width + 40, 0, 2);
			addFadeinObj("owl", 1);
			addMoveCharTo("owl", FlxG.width/2 + 30, -30, 2);
			addSayChar("", "I'll be going now. I have only one last thing to say to you:", TextWindow.thougth);
			addSayChar("", "Just be your self...          \nwhatever that means to you.", TextWindow.thougth);
			addFadeout("s5-fadeout", 1);
			addCallFunction("s5-next-scene", function():void { FlxG.switchState(new Menustate()); } );
		}
		
		private function getPersonArr(markers:Array, errorLabel:String):Array {
			var arr:Array = [];
			if (_jokerOK)
				arr.push("Wear JOKER persona");
			else {
				arr.push("JOKER shattered; Speak your mind");
				markers[0] = errorLabel;
			}
			if (_wallOK)
				arr.push("Wear WALL persona");
			else {
				arr.push("WALL shattered; Speak your mind");
				markers[1] = errorLabel;
			}
			if (_owlOK)
				arr.push("Wear OWL persona");
			else {
				arr.push("OWL shattered; Speak your mind");
				markers[2] = errorLabel;
			}
			return arr;
		}
	}
}
