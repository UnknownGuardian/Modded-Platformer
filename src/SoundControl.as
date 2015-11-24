package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class SoundControl extends Sprite
	{
		private var counter:int = 0;
		private var nextSound:int = Math.random()*300;
		
		public function SoundControl() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.ENTER_FRAME, frame);
		}
		
		private function frame(e:Event):void 
		{
			counter++;
			if (counter > nextSound)
			{
				counter = 0;
				nextSound = Math.random() * 120 + 210;
				
				var r:int = (Math.random() * 10) >> 0 + 1;
				var s:Sound;
				if (r == 1) s = new Drone1();
				else if (r == 2) s = new Drone2();
				
			}
		}
		
	}

}