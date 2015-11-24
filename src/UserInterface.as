package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class UserInterface extends Sprite
	{
		public var time:TextField;
		public var coins:TextField;
		public var combo:TextField;
		public var statTime:TextField;
		public var statCoin:TextField;
		public var statCombo:TextField;
		
		public function UserInterface() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(PColor.blendHexColors(0x666666, 0x000000, 0.5),0.8);
			graphics.drawRect(0, 0, stage.stageWidth, 50);
			graphics.endFill();
			graphics.lineStyle(3, 0x666666);
			graphics.moveTo(0, 50);
			graphics.lineTo(stage.stageWidth, 50);
			
			
			graphics.lineStyle(2, 0xFFFFFF, 1);
			
			time = new TextField();
			time.x = 205;
			time.y = 0;
			time.width = 75;
			time.height = 52;
			time.defaultTextFormat = new TextFormat("Arial", 18, 0xFFFFFF, true, null, null, null, null, 'center');
			time.text = "Time";
			time.selectable = false;
			addChild(time);
			graphics.drawRect(time.x, time.y, time.width, time.height-1);
			
			coins = new TextField();
			coins.x = 283;
			coins.y = 0;
			coins.width = 75;
			coins.height = 52;
			coins.defaultTextFormat = new TextFormat("Arial", 18, 0xFFFFFF, true, null, null, null, null, 'center');
			coins.text = "Coins";
			coins.selectable = false;
			addChild(coins);
			graphics.drawRect(coins.x, coins.y, coins.width, coins.height-1);
			
			combo = new TextField();
			combo.x = 361;
			combo.y = 0;
			combo.width = 75;
			combo.height = 52;
			combo.defaultTextFormat = new TextFormat("Arial", 18, 0xFFFFFF, true, null, null, null, null, 'center');
			combo.text = "Combo";
			combo.selectable = false;
			addChild(combo);
			graphics.drawRect(combo.x, combo.y, combo.width, combo.height - 1);
			
			statTime = new TextField();
			statTime.x = time.x;
			statTime.y = time.y + 30;
			statTime.width = 75;
			statTime.height = 20;
			statTime.defaultTextFormat = new TextFormat("Arial", 16, 0xFFFFFF, true, null, null, null, null, 'center');
			statTime.text = "000";
			statTime.selectable = false;
			addChild(statTime);
			
			
			statCoin = new TextField();
			statCoin.x = coins.x;
			statCoin.y = coins.y + 30;
			statCoin.width = 75;
			statCoin.height = 20;
			statCoin.defaultTextFormat = new TextFormat("Arial", 16, 0xFFFFFF, true, null, null, null, null, 'center');
			statCoin.text = "000";
			statCoin.selectable = false;
			addChild(statCoin);
			
			statCombo = new TextField();
			statCombo.x = combo.x;
			statCombo.y = combo.y + 30;
			statCombo.width = 75;
			statCombo.height = 20;
			statCombo.defaultTextFormat = new TextFormat("Arial", 16, 0xFFFFFF, true, null, null, null, null, 'center');
			statCombo.text = "000";
			statCombo.selectable = false;
			addChild(statCombo);
			
		}
		
		public function kill():void
		{
			while (numChildren > 0) removeChildAt(0);
		}
		
		public function updateTime(num:int):void
		{
			statTime.text = num.toString();
		}
		public function updateCoins(num:int):void
		{
			statCoin.text = num.toString();
		}
		public function updateCombo(num:Number):void
		{
			statCombo.text = num.toString();
		}
	}

}