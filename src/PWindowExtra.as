package  
{
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PWindowExtra extends PWindow
	{
		public var extraButton:PButton;
		
		public function PWindowExtra(xDim:int = 300, yDim:int = 300, text:String = "", onAgree:Function = null, onCancel:Function = null, buttonText:String = "", onButtonClick:Function = null) 
		{
			super(xDim, yDim, text, onAgree, onCancel);
			
			if (onButtonClick != null)
			{
				extraButton = new PButton(xDim/2, 30, 0xFFCC00, buttonText, onButtonClick);
				extraButton.y = (onAgree != null? agree.y - agree.height / 2 - extraButton.height / 2 - 8 : onCancel != null ? cancel.y - cancel.height / 2 - extraButton.height / 2 - 8: yDim / 2 - extraButton.height / 2 - 8 );
				addChild(extraButton);
			}
		}
		override public function kill():void
		{
			if (extraButton) extraButton.kill();
			super.kill();
		}
	}

}