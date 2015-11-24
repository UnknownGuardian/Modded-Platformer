package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PScrollingContentWindow extends PWindow
	{
		public var titleField:TextField;
		public var scrollUp:Sprite;
		public var scrollDown:Sprite;
		
		public var counter:int = 0;
		
		private var blur:Boolean = false;
		private var bg:Sprite;
		
		public function PScrollingContentWindow(xDim:int = 300, yDim:int = 300, title:String = "", text:String = "", onAgree:Function = null, onCancel:Function = null) 
		{
			super(xDim, yDim, text, onAgree, onCancel);
			
			titleField = new TextField();
			titleField.x = -xDim / 2;
			titleField.y = -yDim / 2;
			titleField.width = xDim;
			titleField.height = 30;
			titleField.selectable = false;
			titleField.defaultTextFormat = new TextFormat("Arial", 20, PColor.blendHexColors(0x666666,0x000000,0.5),true,null,null,null,null,'center');
			titleField.text = title;
			addChild(titleField);
			
			if (notification)
			{
				notification.y = titleField.y + titleField.height + 20;
				notification.height -= 20;
				
				var tempSprite:Sprite = new Sprite();
				tempSprite.graphics.beginFill(0xFF00FF, 1);
				tempSprite.graphics.drawRect(notification.x, notification.y, notification.width, notification.height - (agree? agree.height : cancel ? cancel.height : 0) - 10);
				//addChild(tempSprite);
				tempSprite.graphics.endFill();
				
				
				//notification.mask = tempSprite;
				notification.scrollRect = new Rectangle(0, 0, notification.width, notification.height - (agree? agree.height : cancel ? cancel.height : 0) - 10);
				
				trace(tempSprite.height);
				scrollUp = new Sprite();
				scrollUp.graphics.beginFill(0xFFFFFF, 1);
				scrollUp.graphics.drawRoundRectComplex(notification.x+5, notification.y-20, notification.width-10, 20,5,5,0,0);
				scrollUp.graphics.endFill();
				scrollUp.alpha = 0.1;
				scrollUp.addEventListener(MouseEvent.ROLL_OVER, rOver);
				scrollUp.addEventListener(MouseEvent.ROLL_OUT, rOut);
				addChild(scrollUp);				
				
				scrollDown = new Sprite();
				scrollDown.graphics.beginFill(0xFFFFFF, 1);
				scrollDown.graphics.drawRoundRectComplex(notification.x+5, notification.y + tempSprite.height-3, notification.width-10, 20,0,0,5,5);
				scrollDown.graphics.endFill();
				scrollDown.alpha = 0.1;
				scrollDown.addEventListener(MouseEvent.ROLL_OVER, rOver);
				scrollDown.addEventListener(MouseEvent.ROLL_OUT, rOut);
				addChild(scrollDown);
			}
			
			
		}
		public function blurBackground():void
		{
			blur = true;
			bg = new Sprite();
			bg.graphics.beginFill(0xFFFFFF, 0.3);
			bg.graphics.drawRect(0, 50, stage.stageWidth, stage.stageHeight-50);
			parent.addChild(bg);
			parent.swapChildren(bg, this);
		}
		
		private function rOver(e:MouseEvent):void 
		{
			counter = 0;
			e.currentTarget.alpha = 0.75;
			addEventListener(Event.ENTER_FRAME, frame);
		}
		
		private function rOut(e:MouseEvent):void 
		{
			removeEventListener(Event.ENTER_FRAME, frame);
			e.currentTarget.alpha = 0.1;
		}
		
		private function frame(e:Event):void 
		{
			counter++;
			if (counter < 4) return;
			counter = 0;
			//trace(notification.y, notification.height, notification.mask.y, notification.mask.height);
			if (scrollUp.alpha == 0.75) //mouse over
			{
				notification.scrollV--;
				////if(notification.scrollRect.y < notification.height)
				//if (notification.y + notification.height > notification.mask.height)
				{
					//notification.y += 2;
					////var rect:Rectangle = notification.scrollRect;
					////rect.y += 2;
					////notification.scrollRect = rect;
					//notification.scrollRect.y+=2;
				}				
			}
			else
			{
				notification.scrollV++;
				////if(notification.scrollRect.y < notification.height)
				//if (notification.y + notification.height < notification.mask.height)
				{
					//notification.y -= 2;
					//notification.scrollRect.y -= 2;
					////var rect2:Rectangle = notification.scrollRect;
					////rect2.y -= 2;
					////notification.scrollRect = rect2;
				}
			}
		}
		
		override public function kill():void
		{
			if (blur) bg.parent.removeChild(bg);
			super.kill();
			removeChild(scrollDown);
			removeChild(scrollUp);
			scrollUp.removeEventListener(MouseEvent.ROLL_OVER, rOver);
			scrollUp.removeEventListener(MouseEvent.ROLL_OUT, rOut);
			scrollDown.removeEventListener(MouseEvent.ROLL_OVER, rOver);
			scrollDown.removeEventListener(MouseEvent.ROLL_OUT, rOut);
		}
		
	}

}