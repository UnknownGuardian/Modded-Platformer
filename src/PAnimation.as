package  
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import flash.display.Stage;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PAnimation
	{
		public static var stage:Stage;
		
		public function PAnimation() 
		{
			
		}
		
		public static function registerStage(stageRef:Stage):void
		{
			stage = stageRef;
		}
		
		public static function centerWindow(w:PWindow, easeType:Function = null):void
		{
			TweenLite.to(w, 1, { x:stage.stageWidth / 2, y:stage.stageHeight / 2, ease:easeType});
		}
		public static function moveWindowRight(w:PWindow, distance:Number = 1000, easeType:Function = null):void
		{
			TweenLite.to(w, 1, {x:distance.toString(), ease:easeType});
		}
		public static function moveWindowLeft(w:PWindow, distance:Number = 1000, easeType:Function = null):void
		{
			TweenLite.to(w, 1, {x:(-1*distance).toString(), ease:easeType});
		}
		
		public static function fadeInWindow(w:PWindow):void
		{
			w.alpha = 0;
			TweenLite.to(w, 1, { alpha:1, overwrite:false } );
		}
		public static function fadeOutWindow(w:PWindow, onComplete:Function = null):void
		{
			TweenLite.to(w, 1, { alpha:0, overwrite:false, onComplete:onComplete } );
		}
		
	}

}