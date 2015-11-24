package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PButton extends Sprite
	{
		public var field:TextField;
		public var clickReturn:Function;
		
		public function PButton(xDim:int = 100, yDim:int = 30, fillColor:uint = 0x666666, text:String = "", onClick:Function = null) 
		{
			graphics.lineStyle(3, PColor.blendHexColors(fillColor,0x000000,0.25));
			graphics.beginFill(fillColor, 0.5);
			graphics.drawRect( -xDim / 2, -yDim / 2, xDim, yDim);
			graphics.endFill();
			
			if (text != "")
			{
				field = new TextField();
				field.x = -xDim / 2;
				field.y = -yDim / 2;
				field.width = xDim;
				field.height = yDim;
				field.selectable = false;
				field.defaultTextFormat = new TextFormat("Arial", 20, PColor.blendHexColors(fillColor,0x000000,0.5),true,null,null,null,null,'center');
				field.text = text;
				addChild(field);
			}
			
			clickReturn = onClick;
			if (onClick != null)
			{
				addEventListener(MouseEvent.CLICK, onClick);
			}
			addEventListener(MouseEvent.ROLL_OVER, rOver);			
			addEventListener(MouseEvent.ROLL_OUT, rOut);			
		}
		
		public function rOver(e:MouseEvent):void
		{
			filters = [new GlowFilter(0xFFFFFF)];
		}
		public function rOut(e:MouseEvent):void
		{
			filters = [];
		}
		
		public function kill():void
		{
			graphics.clear();
			removeEventListener(MouseEvent.ROLL_OVER, rOver);			
			removeEventListener(MouseEvent.ROLL_OUT, rOut);	
			if (clickReturn != null) removeEventListener(MouseEvent.CLICK, clickReturn);
			parent.removeChild(this);
		}
	}

}