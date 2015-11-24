package {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Creator extends Sprite
	{
		public var display:Sprite;
		public var tabContainer:Sprite;
		public var tileContainer:Sprite;
		public var currentTile:int = -1;
		public var currentItem:int = -1;
		public var tileList:Vector.<Tile> = new Vector.<Tile>();
		
		public var levelWidth:int = 27;
		public var levelHeight:int = 22;
		
		public var mouseDown:Boolean = false;
		
		private var tileTab:TileTab;
		private var itemTab:ItemTab;
		private var testTab:TestTab;
		private var errorField:TextField;
		private var itemContainer:Sprite;
		private var startLoc:ItemHolder;
		private var endLoc:ItemHolder;
		
		public function Creator()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			display = new Sprite();
			addChild(display);
			display.graphics.beginFill(0x000000, 0.5);
			display.graphics.drawRect(stage.stageWidth-50, 0, 50, stage.stageHeight);
			display.graphics.endFill();
			display.graphics.beginFill(0x000000, 0.8);
			display.graphics.drawRect(0, 0, 10, stage.stageHeight);
			display.graphics.drawRect(10, 0, stage.stageWidth - 60, 10);
			display.graphics.drawRect(stage.stageWidth - 63, 10, 13, stage.stageHeight - 19);
			display.graphics.endFill();
			display.graphics.beginFill(0x000000, 0.8);
			display.graphics.drawRect(10, stage.stageHeight-9, stage.stageWidth - 60, 10);
			display.graphics.endFill();
			
			tabContainer = new Sprite();
			addChild(tabContainer);
			
			tileTab = new TileTab();
			tileTab.x = 615;
			tileTab.y = tileTab.height / 2 + 5;
			tileTab.addEventListener(MouseEvent.CLICK, showTab);
			tabContainer.addChild(tileTab);
			
			itemTab = new ItemTab();
			itemTab.x = 615;
			itemTab.y = tileTab.y + tileTab.height + 5;
			itemTab.addEventListener(MouseEvent.CLICK, showTab);
			tabContainer.addChild(itemTab);
			
			testTab = new TestTab();
			testTab.x = 615;
			testTab.y = stage.stageHeight - testTab.height/2 - 5;
			testTab.addEventListener(MouseEvent.CLICK, showTab);
			tabContainer.addChild(testTab);
			
			errorField = new TextField();
			errorField.x = 540;
			errorField.y = 75;
			errorField.background = true;
			errorField.backgroundColor = 0x000000;
			errorField.defaultTextFormat = new TextFormat("Arial", 10, 0xFFFFFF);
			errorField.antiAliasType = AntiAliasType.ADVANCED;
			errorField.text = "Errors: ";
			errorField.multiline = true;
			errorField.wordWrap = true;
			errorField.width = 100;
			errorField.height = 365;
			
			addChild(errorField);
			
			tileContainer = new Sprite();
			tileContainer.x = stage.stageWidth-50;
			addChild(tileContainer);
			tileContainer.visible = false;
			
			var t:Tile = new Tile();
			for (var i:int = 0; i < t.totalFrames; i++)
			{
				var innerTile:Tile = new Tile();
				innerTile.x = 15;
				innerTile.y = i * 30 + 100;
				innerTile.gotoAndStop(i + 1);
				tileContainer.addChild(innerTile);
				innerTile.addEventListener(MouseEvent.CLICK, selectTile);
			}
			
			itemContainer = new Sprite();
			itemContainer.x = stage.stageWidth - 50;
			addChild(itemContainer);
			itemContainer.visible = false;
			
			var h:ItemHolder = new ItemHolder();
			for (var r:int = 1; r < h.totalFrames; r++)
			{
				var innerHolder:ItemHolder = new ItemHolder();
				innerHolder.gotoAndStop(r + 1);
				innerHolder.x = 25;
				innerHolder.y = (r-1) * 30 + 100;
				itemContainer.addChild(innerHolder);
				innerHolder.addEventListener(MouseEvent.CLICK, selectItem);
			}
			
			
			for (var j:int = 0; j < levelWidth; j++)
			{
				for (var k:int = 0; k < levelHeight; k++)
				{
					var ti:Tile = new Tile();
					ti.x = ti.width * j + 10;
					ti.y = ti.height * k + 10;
					ti.gotoAndStop(1);
					display.addChild(ti);
					tileList.push(ti);
					ti.addEventListener(MouseEvent.ROLL_OVER, rOver);
					ti.addEventListener(MouseEvent.CLICK, rOver);
					
					var holder:ItemHolder = new ItemHolder();
					holder.x = ti.width * j + 10 + ti.width/2;
					holder.y = ti.height * k + 10 + ti.height/2;
					holder.gotoAndStop(1);
					holder.mouseEnabled = false;
					display.addChild(holder);
					holder.mouseChildren = false;
					
					ti.item = holder;
				}
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
		}
		
		private function showTab(e:MouseEvent):void 
		{
			if (e.currentTarget == tileTab)
			{
				tileContainer.visible = true;
				itemContainer.visible = false;
				errorField.visible = false;
			}
			else if(e.currentTarget == itemTab)
			{
				tileContainer.visible = false;
				itemContainer.visible = true;
				errorField.visible = false;
			}
			else if(e.currentTarget == testTab)
			{
				tileContainer.visible = false;
				itemContainer.visible = false;
				errorField.visible = true;
				
				runErrorTesting();
			}
		}
		
		public function runErrorTesting():void
		{
			if (startLoc == null) {	errorField.text = "Add a starting location."; return; }
			if (endLoc == null) {	errorField.text = "Add a ending location."; return; }
			if (getChangedTiles() < 1) {	errorField.text = "You need to have at least 1 tile that is not air."; return; }
			errorField.text = "No Errors.\nCompiling level.";
			
			var p:Platform = new Platform();
			p.init(toString());
			stage.addChild(p);
			
			kill();
		}
		
		private function getChangedTiles():int
		{
			var count:int = 0;
			for (var i:int = 0; i < tileList.length; i++)
			{
				if (tileList[i].currentFrame != 1)
				{
					count++;
				}
			}
			return count;
		}
		
		private function rOver(e:MouseEvent):void 
		{
			if (currentTile != -1)
			{
				if (e.type == MouseEvent.CLICK)
				{
					e.currentTarget.gotoAndStop(currentTile);
				}
				else //MouseEvent.ROLL_OVER
				{
					if (mouseDown)
					{
						e.currentTarget.gotoAndStop(currentTile);
					}
				}
			}
			else if (currentItem != -1)
			{
				var item:Sprite;
				var obj:MovieClip = MovieClip(e.currentTarget);
				if (e.type == MouseEvent.CLICK)
				{
					if (currentItem == 6)
					{
						obj.item.gotoAndStop(1);
						if (ItemHolder(obj.item) == endLoc) endLoc = null;
						if (ItemHolder(obj.item) == startLoc) startLoc = null;
					}
					else
					{
						obj.item.gotoAndStop(currentItem);
						if (currentItem == 4)
						{
							if (ItemHolder(obj.item) == endLoc) endLoc = null;
							if (startLoc != null)
							{
								startLoc.gotoAndStop(1);
							}
							startLoc = ItemHolder(obj.item);
						}
						else if (currentItem == 5)
						{
							if (ItemHolder(obj.item) == startLoc) startLoc = null;
							if (endLoc != null)
							{
								endLoc.gotoAndStop(1);
							}
							endLoc = ItemHolder(obj.item);
						}
						else
						{
							if (ItemHolder(obj.item) == endLoc) endLoc = null;
							if (ItemHolder(obj.item) == startLoc) startLoc = null;
						}
					}
				}
				else //MouseEvent.ROLL_OVER
				{
					if (mouseDown)
					{
						if (currentItem == 6)
						{
							obj.item.gotoAndStop(1);
							if (ItemHolder(obj.item) == endLoc) endLoc = null;
							if (ItemHolder(obj.item) == startLoc) startLoc = null;
						}
						else if (currentItem == 4 || currentItem == 5)
						{
							return;
						}
						else
						{
							obj.item.gotoAndStop(currentItem);
							if (ItemHolder(obj.item) == endLoc) endLoc = null;
							if (ItemHolder(obj.item) == startLoc) startLoc = null;
						}
					}
				}
			}
		}
		
		private function mDown(e:MouseEvent):void 
		{
			mouseDown = true;
		}
		private function mUp(e:MouseEvent):void 
		{
			mouseDown = false;
		}
		
		private function selectTile(e:MouseEvent):void 
		{
			currentTile = e.currentTarget.currentFrame;
			currentItem = -1;
		}
		private function selectItem(e:MouseEvent):void 
		{
			currentTile = -1;
			currentItem = e.currentTarget.currentFrame;
		}
		
		
		override public function toString():String
		{
			var s:String = "";
			s += levelWidth + "_" + levelHeight + "_";
			var i:int = 0;
			for (i; i < tileList.length; i++)
			{
				s += tileList[i].currentFrame;
			}
			s += "_";
			for (i = 0; i < tileList.length; i++)
			{
				s += tileList[i].item.currentFrame;
			}
			return s;
		}
		
		
		
		
		public function kill():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mUp);
			removeChild(display);
			
			
			removeChild(tabContainer);
			
			tileTab.removeEventListener(MouseEvent.CLICK, showTab);
			tabContainer.removeChild(tileTab);
			tileTab = null;
			
			itemTab.removeEventListener(MouseEvent.CLICK, showTab);
			tabContainer.removeChild(itemTab);
			itemTab = null
			
			testTab.removeEventListener(MouseEvent.CLICK, showTab);
			tabContainer.removeChild(testTab);
			testTab = null;
			
			tabContainer = null;
			
			removeChild(errorField);
			errorField = null;
			
			removeChild(tileContainer);
			
			var innerTile:Tile;
			while (tileContainer.numChildren > 0)
			{
				innerTile = Tile(tileContainer.getChildAt(0));
				innerTile.removeEventListener(MouseEvent.CLICK, selectTile);
				tileContainer.removeChild(innerTile);
			}
			innerTile = null;
			tileContainer = null;
			
			removeChild(itemContainer);
			
			var innerHolder:ItemHolder;
			while (itemContainer.numChildren > 0)
			{
				innerHolder = ItemHolder(itemContainer.getChildAt(0));
				innerHolder.removeEventListener(MouseEvent.CLICK, selectItem);
				itemContainer.removeChild(innerHolder);
			}
			innerHolder = null;
			itemContainer = null;
			
			var ti:Tile;
			for (var j:int = 0; j < tileList.length; j++)
			{
				ti = tileList[j];
				display.removeChild(ti.item);
				display.removeChild(ti);
				ti.removeEventListener(MouseEvent.ROLL_OVER, rOver);
				ti.removeEventListener(MouseEvent.CLICK, rOver);
			}
			ti = null;
			tileList.length = 0;
			
			parent.removeChild(this);
		}
		
	}
}
