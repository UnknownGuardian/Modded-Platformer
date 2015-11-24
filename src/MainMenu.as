package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class MainMenu extends Sprite
	{
		public var titleText:Title;
		public var createText:CreateLevel;
		public var loadText:LoadLevel;
		
		public function MainMenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.ENTER_FRAME, frame);
			
			titleText = new Title();
			titleText.y = -200;
			titleText.x = stage.stageWidth / 2;
			addChild(titleText);
			titleText.addEventListener(MouseEvent.ROLL_OVER,rOver);
			titleText.addEventListener(MouseEvent.ROLL_OUT,rOut);
			
			createText = new CreateLevel();
			createText.y = 800;
			createText.x = stage.stageWidth / 2;
			addChild(createText);
			createText.addEventListener(MouseEvent.CLICK, createLevel);
			createText.addEventListener(MouseEvent.ROLL_OVER,rOver);
			createText.addEventListener(MouseEvent.ROLL_OUT,rOut);
			
			loadText = new LoadLevel();
			loadText.y = 800;
			loadText.x = stage.stageWidth / 2;
			addChild(loadText);
			loadText.addEventListener(MouseEvent.CLICK, loadLevel);
			loadText.addEventListener(MouseEvent.ROLL_OVER,rOver);
			loadText.addEventListener(MouseEvent.ROLL_OUT, rOut);
		}
		
		private function createLevel(e:MouseEvent):void 
		{	
			var w:PScrollingContentWindow = new PScrollingContentWindow(300, 300, "= HighScores =", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", kill);
			w.x = stage.stageWidth / 2
			w.y = stage.stageHeight / 2;
			stage.addChild(w);
			return;//uncomment out when not needed
			stage.addChild(new Creator());
			kill();
		}
		
		private function loadLevel(e:MouseEvent):void 
		{
			var p:Platform = new Platform();
			p.init();
			stage.addChild(p);
			kill();
		}
		
		public function kill():void
		{
			removeEventListener(Event.ENTER_FRAME, frame);
			
			removeChild(titleText);
			titleText.removeEventListener(MouseEvent.ROLL_OVER,rOver);
			titleText.removeEventListener(MouseEvent.ROLL_OUT,rOut);
			
			removeChild(createText);
			createText.removeEventListener(MouseEvent.CLICK, createLevel);
			createText.removeEventListener(MouseEvent.ROLL_OVER,rOver);
			createText.removeEventListener(MouseEvent.ROLL_OUT,rOut);
			
			removeChild(loadText);
			loadText.removeEventListener(MouseEvent.CLICK, loadLevel);
			loadText.removeEventListener(MouseEvent.ROLL_OVER,rOver);
			loadText.removeEventListener(MouseEvent.ROLL_OUT,rOut);
		}
		
		private function rOut(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = 1;
			e.currentTarget.scaleY = 1;
		}
		
		private function rOver(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = 2;
			e.currentTarget.scaleY = 2;
		}
		
		public function frame(e:Event):void
		{
			var dy:int = (100 + (stage.stageHeight / 2 - stage.mouseY) / 6);
			titleText.y += (dy - titleText.y)/10;
			titleText.x = stage.stageWidth / 2 + (stage.stageWidth / 2 - stage.mouseX) / 20;
			
			
			dy = (200 + (stage.stageHeight / 2 - stage.mouseY) / 5);
			createText.y += (dy - createText.y)/10;
			createText.x = stage.stageWidth / 2 + (stage.stageWidth / 2 - stage.mouseX) / 20;
			
			dy = (250 + (stage.stageHeight / 2 - stage.mouseY) / 4);
			loadText.y += (dy - loadText.y)/10;
			loadText.x = stage.stageWidth / 2 + (stage.stageWidth / 2 - stage.mouseX) / 20;
		}
	}
}
