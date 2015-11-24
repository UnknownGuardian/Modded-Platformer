package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PWindow extends Sprite
	{
		public var agree:PButton;
		public var cancel:PButton;
		public var notification:TextField;
		
		public function PWindow(xDim:int = 300, yDim:int = 300, text:String = "", onAgree:Function = null, onCancel:Function = null) 
		{
			graphics.lineStyle(3, PColor.blendHexColors(0x666666,0x000000,0.25));
			graphics.beginFill(0x666666, 0.8);
			graphics.drawRect( -xDim / 2, -yDim / 2, xDim, yDim);
			graphics.endFill();
			
			if (onAgree!=null)
			{
				agree = new PButton(xDim / 3, 30, 0x00FF00, "continue", onAgree);
				if (onCancel!=null) //shove to one side
				{
					agree.x = -xDim/2 + agree.width/2 + 8;
				}
				agree.y = yDim / 2 - agree.height / 2 - 8;
				addChild(agree);
			}
			
			if (onCancel!=null)
			{
				cancel = new PButton(xDim / 3, 30, 0xFF0000, "cancel", onCancel);
				if (onAgree!=null) //shove to one side
				{
					cancel.x = xDim / 2 - cancel.width / 2 - 8;
				}
				cancel.y = yDim / 2 - cancel.height / 2 - 8;
				addChild(cancel);
			}
			
			if (text != "")
			{
				notification = new TextField();
				notification.x = -xDim / 2;
				notification.y = -yDim / 2;
				notification.width = xDim;
				notification.height = yDim - (onAgree != null ? agree.height : onCancel != null ? cancel.height : 0) - 10;
				notification.multiline = true;
				notification.wordWrap = true;
				notification.selectable = false;
				notification.defaultTextFormat = new TextFormat("Arial", 20, PColor.blendHexColors(0x666666,0x000000,0.5),true,null,null,null,null,'center');
				notification.text = text;
				addChild(notification);
			}
		}
		public function kill():void
		{
			graphics.clear();
			if (agree) agree.kill();
			if (cancel) cancel.kill();
			if (notification) removeChild(notification);
		}
	}

}