package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import Playtomic.*;
	
	public class Platform extends Sprite
	{
		public var hud:UserInterface;
		public var instructionsWindow:PWindow;
		public var highScoresWindow:PScrollingContentWindow;
		public var finalTimeWindow:PWindowExtra;
		public var frameCounter:int = 0;
		public var coinCounter:int = 0;
		
		private var over:String = "";
		private var bonus_speed:Number = 0;
		
		//key presses
		public var leftPressed:Boolean = false;
		public var rightPressed:Boolean = false;
		public var upPressed:Boolean = false;
		public var downPressed:Boolean = false;
		public var spacePressed:Boolean = false;
		
		//location of the player
		private var x_pos:Number = 0;
		private var y_pos:Number = 0;
		
		//width, height of the file
		private var tile_size:Number = 20;
		
		//tile properties
		private var ground_acceleration:Number = 1;
		private var ground_friction:Number = 0.8;
		private var air_acceleration:Number = 0.5;
		private var air_friction:Number = 0.7;
		private var ice_acceleration:Number = 0.14;
		private var ice_friction:Number = 0.96;
		private var treadmill_speed:Number = 2;
		
		//player properties
		private var playerRightSide:int = 5;
		private var playerLeftSide:int = 6;
		private var max_speed:Number = 5;
		private var xspeed:Number = 0;
		private var yspeed:Number = 0;
		private var falling:Boolean = false;
		private var gravity:Number = 0.5;
		private var jump_speed:Number = 7;
		private var climbing:Boolean = false;
		private var climb_speed:Number = 2.6;
		
		//in game objects
		private var coins:Array = new Array();
		private var level:Array = new Array();
		private var levelObj:Array = new Array
		private var keys:Array = new Array();
		private var player:Array = new Array();
		private var enemy:Array = new Array();
		public var specialCoin:coin = new coin();
		
		//tiles that are steppable on (e.g. non air)
		private var walkable_tiles:Array = new Array(0, 5, 6, 7);
		
		//player
		private var h:hero = new hero();
		
		//holds level graphics in a container. Make it easy for scroll
		private var level_container:Sprite = new Sprite();
		
		//temp vars to hold position of tiles relative to the player
		private var bottom:Number;
		private var left:Number;
		private var right:Number;
		private var top:Number;
		private var bottom_left:Number;
		private var bottom_right:Number;
		private var top_left:Number;
		private var top_right:Number;
		
		//more temp player properties
		private var climbdir:Number;
		private var current_tile:Number;
		private var friction:Number;
		private var speed:Number;
		private var jumping:Boolean;
		private var walking:Boolean;
		private var prev_bottom:Number;
		
		public function Platform()
		{
			
		}
		public function init(levelData:String = ""):void
		{
			//decode level
			if (levelData != "")
			{
				var data:Array = levelData.split("_");
				var levelWidth:int = int(data[0]);
				var levelHeight:int = int(data[1]);
				trace("------------------Gathered Data--------------------");
				trace("Have: " + data[2]);
				var i:int = 0;
				var q:int = 0;
				for (i = 0; i < levelHeight; i++)
				{
					level[i] = [];
					for (q = 0; q < levelWidth; q++)
					{
						level[i].push(0);
					}
				}
				trace("------------------Building Level--------------------");
				var count:int = 0;
				for (q = 0; q < levelWidth; q++)
				
				{
					for (i = 0; i < levelHeight; i++)
					{
						level[i][q] = int(data[2].substring(count, count + 1))-1;
						count++;
					}
				}
				trace("------------------Level Built--------------------");
				for (i = 0; i < levelHeight; i++)
				{
					trace(level[i]);
				}
				trace("-----------------Adding Items--------------------");
				trace("Have: " + data[3]);
				var playerEndX:int;
				var playerEndY:int;
				count = 0;
				for (q = 0; q < levelWidth; q++)
				{
					for (i = 0; i < levelHeight; i++)
					{
						var itemType:int = int(data[3].substring(count, count + 1)) - 1;
						trace(itemType);
						switch(itemType)
						{
							case 1 : { keys[0] = [i,q]; break; }
							case 2 : { coins.push([i, q]); break; }
							case 3 : { player =   [i, q] ; break; }
							case 4 : { playerEndX = i; playerEndY = q; break; }
						}
						count++;
					}
				}
				
				keys[0].push(playerEndX, playerEndY);
			}
			else
			{
				//level definition. Perhaps recode this to our way? or something
				/*
				level[0] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
				level[1] = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
				level[2] = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 1, 0, 0, 0, 0, 1];
				level[3] = [1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1];
				level[4] = [1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1];
				level[5] = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1];
				level[6] = [1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 1, 0, 0, 0, 0, 0, 1];
				level[7] = [1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 1];
				level[8] = [1, 1, 1, 1, 0, 9, 0, 0, 0, 5, 5, 0, 0, 0, 7, 0, 0, 6, 0, 0, 0, 0, 7, 0, 1];
				level[9] = [1, 1, 1, 1, 1, 1, 1, 2, 2, 8, 8, 8, 8, 1, 1, 3, 3, 1, 4, 4, 1, 8, 1, 8, 1];
				*/
				level[0]  = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
				level[1]  = [1,1,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1];
				level[2]  = [1,0,0,1,0,0,0,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,6,1];
				level[3]  = [1,0,1,1,1,1,1,1,0,0,1,1,8,8,8,8,8,1,0,0,0,0,0,0,0,6,1];
				level[4]  = [1,0,0,0,0,0,0,0,0,1,1,8,8,8,8,1,1,1,0,0,0,0,0,0,0,6,1];
				level[5]  = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,5,5,1];
				level[6]  = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,1];
				level[7]  = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,1];
				level[8]  = [1,6,2,2,2,2,2,2,2,2,0,2,2,2,2,2,2,2,2,8,8,8,8,8,8,8,1];
				level[9]  = [1,6,0,0,0,0,2,0,0,0,0,2,2,2,2,2,2,2,1,0,0,0,0,0,0,0,1];
				level[10] = [1,6,0,0,0,0,2,8,3,3,3,2,1,1,1,1,1,2,1,0,0,0,0,0,0,0,1];
				level[11] = [1,6,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,0,1,1,1,1,5,5,1];
				level[12] = [1,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,5,5,1];
				level[13] = [1,1,1,1,1,1,1,0,1,1,1,1,1,0,0,1,1,1,1,1,1,1,0,1,5,5,1];
				level[14] = [1,0,0,1,8,8,1,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,5,5,1];
				level[15] = [1,0,0,1,8,8,1,0,1,5,5,0,0,0,2,2,3,3,3,3,3,3,3,1,5,5,1];
				level[16] = [1,0,0,1,1,8,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5,1];
				level[17] = [1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,1];
				level[18] = [1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,1];
				level[19] = [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,5,1];
				level[20] = [1,1,1,1,1,0,0,7,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,5,5,1];
				level[21] = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
			}
			
			
			//player = [1,14];
			player = [2, 2];
			coins = [	[6, 1],
						[6, 2],
						[5, 2],
						[4, 2],
						[4, 1],
						[3, 1],
						[2, 1],
						[2, 2],
						[1, 2],
						[1, 3],
						[1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4], [8, 4],
						[8, 3],
						[9, 3],
						[9, 2],
						[10, 2],
						[10, 1], [11, 1], [12, 1], [13, 1], [14, 1], [15, 1], [16, 1], [17, 1], [18, 1], [19, 1], [20, 1], [21, 1], [22, 1], [23, 1], [24, 1],
						[24, 3],
						[24, 4],
						[21, 5],
						[21, 4],
						[22, 4],
						[23, 4],
						[20, 5],
						[19, 5],
						[18, 5],
						[18, 6],
						[17, 7],
						[16, 7],
						[15, 7],
						[14, 7],
						[13, 7],
						[12, 7],
						[11, 7],
						[10, 6],
						[9, 7],
						[8, 7],
						[7, 7],
						[6, 7],
						[5, 7],
						[4, 7],
						[3, 7],
						[2, 7],
						[1, 7],
						[1, 6],
						[8, 9],
						[9, 9],
						[10, 9],
						[10, 8],
						[3, 10],
						[4, 10],
						[4, 9],
						[3, 9],
						[2, 12],
						[3, 12],
						[4, 12],
						[5, 12],
						[7, 11],
						[9, 11],
						[17, 12],
						[16, 12],
						[15, 12],
						[15, 11],
						[11, 12],
						[10, 12],
						[7, 14],
						[7, 15],
						[7, 16],
						[7, 17],
						[7, 18],
						[7, 19],
						[7, 13],
						[2, 17],
						[3, 17],
						[3, 18],
						[4, 18],
						[4, 19],
						[5, 19],
						[5, 20],
						[6, 20],
						[10, 19],
						[11, 19],
						[12, 19],
						[14, 19],
						[15, 19],
						[16, 19],
						[20, 18],
						[21, 17],
						[19, 19],
						//[10, 14],
						//[9, 14],
						[11, 15],
						[22, 14],
						[21, 14],
						[20, 14],
						[19, 14],
						[18, 14],
						[16, 14],
						[17, 14],
						[21, 12],
						[20, 12],
						[20, 10],
						[21, 10],
						[25, 10],
						[24, 10],
						[25, 16],
						[24, 16],
						[24, 15],
						[25, 15],
						[25, 14],
						[24, 14],
						[24, 13],
						[25, 13],
						[25, 12],
						[24, 12],
						[24, 11],
						[25, 11]
			];
			
			//enemy[0] = [10, 3, -2];
			//enemy[1] = [3, 3, -2];
			
			//keys[0] = [1, 5, 5, 8];
			
			hud = new UserInterface();
			
			
			create_level(level);
			
			addEventListener(Event.ADDED_TO_STAGE, displayInstructions);
		}
		public function displayInstructions(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addChild(hud);
			onEnterFrame();
			instructionsWindow = new PWindow(300,300,"Welcome to Minimal Platformer.\n\n\nCompete internationally against other users for the best scores.\n\nTime - Coins - Combo", removeWindow,null);
			instructionsWindow.y = stage.stageHeight / 2;
			stage.addChild(instructionsWindow);
			
			PAnimation.centerWindow(instructionsWindow);
			PAnimation.fadeInWindow(instructionsWindow);
			
		}
		
		public function removeWindow(e:MouseEvent):void
		{
			PAnimation.moveWindowRight(instructionsWindow, stage.stageWidth / 2);
			PAnimation.fadeOutWindow(instructionsWindow, startGame);
		}
		public function startGame():void
		{
			
			if (instructionsWindow)
			{
				instructionsWindow.kill();
				stage.removeChild(instructionsWindow);
				instructionsWindow = null;
			}
			if (finalTimeWindow)
			{
				finalTimeWindow.kill();
				stage.removeChild(finalTimeWindow);
				finalTimeWindow = null;
			}
			stage.stageFocusRect = false;
			stage.focus = this;
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
			frameCounter = 0;
			coinCounter = 0;
		}
		
		/*
		private function traceSpot(e:MouseEvent):void 
		{
			trace("[" + e.currentTarget.y / tile_size + ",", e.currentTarget.x / tile_size + "],");
			e.currentTarget.graphics.beginFill(0xFF00FF, 1);
			e.currentTarget.graphics.drawCircle(tile_size/2, tile_size/2, 3);
			e.currentTarget.graphics.endFill();
		}*/
		
		public function key_down(e:KeyboardEvent):void
		{
			var k:int = e.keyCode;
			
			if (k == 32) {
				spacePressed = true;
			}
			
			if ( k == 65 || k == 37 ) {
				leftPressed = true;
			}
			
			if ( k == 87 || k == 38 ) {
				upPressed = true;
			}
			
			if ( k == 68 || k == 39 ) {
				rightPressed = true;
			}
			
			if ( k == 83 || k == 40 ) {
				downPressed = true;
			}
		}
		
		public function key_up(e:KeyboardEvent):void
		{
			var k:int = e.keyCode;
			
			if (k == 32) {
				spacePressed = false;
			}
			
			if ( k == 65 || k == 37 ) {
				leftPressed = false;
			}
			
			if ( k == 87 || k == 38 ) {
				upPressed = false;
			}
			
			if ( k == 68 || k == 39 ) {
				rightPressed = false;
			}
			
			if ( k == 83 || k == 40 ) {
				downPressed = false;
			}
		}
		
		public function create_level(l:Array):void
		{
			var level_height:Number = l.length;
			var level_width:Number = l[0].length;
			
			addChild(level_container);
			
			for (var j:Number = 0; j<level_height; j++)
			{
				levelObj[j] = new Array();
				for (var i:Number = 0; i<level_width; i++)
				{
					//if (l[j][i] != 0)
					{
						var t:Tile = new Tile();
						//t.addEventListener(MouseEvent.CLICK, traceSpot);
						t.x = i*tile_size;
						t.y = j*tile_size;
						t.gotoAndStop(l[j][i]+1);
						levelObj[j][i] = t;
						level_container.addChild(levelObj[j][i]);
					}
				}
			}
			
			place_player();
			level_container.addChild(h);
			
			for (var m:int = 0; m < coins.length; m++)
			{
				var c:coin = new coin();
				c.x = coins[m][0] * tile_size + tile_size / 2;
				c.y = coins[m][1] * tile_size + tile_size/2 + 1;
				
				coins[m] = c;
				level_container.addChild(coins[m]);
			}
			
			specialCoin = new coin();
			specialCoin.filters = [new GlowFilter(0xFFCC00,1,12,12,3)];
			specialCoin.x = 7*tile_size + tile_size / 2;
			specialCoin.y = tile_size + tile_size / 2;
			coins.push(specialCoin);
			level_container.addChild(specialCoin);
			
			for (var n:int = 0; n < keys.length; n++)
			{
				var _k:key = new key();
				_k.x = keys[n][0] * tile_size + tile_size / 2;
				_k.y = keys[n][1] * tile_size + tile_size / 2 + 1;
				_k.openX = keys[n][2];
				_k.openY = keys[n][3];
				keys[n] = _k;
				level_container.addChild(keys[n]);
			}
			
			for (var k:int = 0; k < enemy.length; k++)
			{
				var foe:patrol = new patrol();
				foe.speed = enemy[k][2];
				foe.x = enemy[k][0] * tile_size + tile_size / 2;
				foe.y = enemy[k][1] * tile_size + tile_size / 2 + 1;
				
				enemy[k] = foe;
				level_container.addChild(enemy[k]);
			}
		}
		
		public function onEnterFrame(event:Event = null):void
		{
			frameCounter++;
			hud.updateTime(frameCounter);
			ground_under_feet();
			
			walking = false;
			climbing = false;
			if (leftPressed) {
				xspeed-=speed;
				walking = true;
			}
			if (rightPressed) {
				xspeed += speed;
				walking = true;
			}
			if (upPressed) {
				get_edges();
				if (top_right == 6 || bottom_right == 6 || top_left == 6 || bottom_left == 6) {
					jumping = false;
					falling = false;
					climbing = true;
					climbdir = -1;
				}
			}
			if (downPressed) {
				get_edges();
				if (over == "ladder" || top_right == 6 || bottom_right == 6 || top_left == 6 || bottom_left == 6) {
					jumping = false;
					falling = false;
					climbing = true;
					climbdir = 1;
				}
			}
			if (spacePressed) {
				get_edges();
				if (!falling && !jumping) {
					jumping = true;
					yspeed = -jump_speed;
				}
			}
			if (!walking) {
				xspeed *= friction;
				if (Math.abs(xspeed)<0.5) {
					xspeed = 0;
				}
			}
			if (xspeed>max_speed) {
				xspeed = max_speed;
			}
			if (xspeed<max_speed*-1) {
				xspeed = max_speed*-1;
			}
			if (falling || jumping) {
				yspeed += gravity;
			}
			if (climbing) {
				yspeed = climb_speed*climbdir;
			}
			if (!falling && !jumping && !climbing) {
				yspeed = 0;
			}
			xspeed += bonus_speed;
			check_collisions();
			h.x = x_pos;
			h.y = y_pos;
			
			level_container.x += (int( -x_pos + 320) - level_container.x) / 4;
			level_container.y += (int( -y_pos + 240) - level_container.y) / 4;
			
			xspeed -= bonus_speed;
			
			for (var i:int = 0; i < enemy.length; i++)
			{
				enemy[i].x_pos = enemy[i].x;
				enemy[i].y_pos = enemy[i].y;
				
				enemy[i].x_pos += enemy[i].speed;
				
				enemy[i].left_foot_x = Math.floor((enemy[i].x_pos-playerLeftSide)/tile_size);
				enemy[i].right_foot_x = Math.floor((enemy[i].x_pos+playerRightSide)/tile_size);
				enemy[i].foot_y = Math.floor((enemy[i].y_pos+9)/tile_size);
				enemy[i].bottom = Math.floor((enemy[i].y_pos+8)/tile_size);
				enemy[i].left_foot = level[enemy[i].foot_y][enemy[i].left_foot_x];
				enemy[i].right_foot = level[enemy[i].foot_y][enemy[i].right_foot_x];
				enemy[i].left = level[enemy[i].bottom][enemy[i].left_foot_x];
				enemy[i].right = level[enemy[i].bottom][enemy[i].right_foot_x];
				
				if (enemy[i].left_foot != 0 && enemy[i].right_foot != 0 && enemy[i].left == 0 && enemy[i].right == 0)
				{
					enemy[i].x = enemy[i].x_pos;
				}
				else {
					enemy[i].speed *= -1;
				}
			}
			
			for (var j:int = 0; j < coins.length; j++)
			{
				if(coins[j].parent && coins[j].hitTestObject(h))
				{
					coinCounter++;
					hud.updateCoins(coinCounter);
					hud.updateCombo((135 - coinCounter) * 1.5 + (frameCounter) * 2);
					if (coins[j] == specialCoin)
					{
						endGame();
					}
					else
					{
						coins[j].parent.removeChild(coins[j]);
						
						//level_container.removeChild(coins[j]);
					}
				}
			}
			
			for (var k:int = 0; k < keys.length; k++)
			{
				if(keys[k].hitTestObject(h))
				{
					level[keys[k].openY][keys[k].openX] = 0;
					
					level_container.removeChild(levelObj[keys[k].openY][keys[k].openX]);
					level_container.removeChild(keys[k]);
				}
			}
		}
		
		public function ground_under_feet():void
		{
			bonus_speed = 0;
			var left_foot_x:Number = Math.floor((x_pos-playerLeftSide)/tile_size);
			var right_foot_x:Number = Math.floor((x_pos+playerRightSide)/tile_size);
			var foot_y:Number = Math.floor((y_pos+9)/tile_size);
			var left_foot:Number = level[foot_y][left_foot_x];
			var right_foot:Number = level[foot_y][right_foot_x];
			if (left_foot != 0) {
				current_tile = left_foot;
			} else {
				current_tile = right_foot;
			}
			switch (current_tile) {
				case 0 :
					speed = air_acceleration;
					friction = air_friction;
					falling = true;
					break;
				case 1 :
					over = "ground";
					speed = ground_acceleration;
					friction = ground_friction;
					break;
				case 2 :
					over = "ice";
					speed = ice_acceleration;
					friction = ice_friction;
					break;
				case 3 :
					over = "treadmill";
					speed = ground_acceleration;
					friction = ground_friction;
					bonus_speed = -treadmill_speed;  //left moving
					break;
				case 4 :
					over = "treadmill";
					speed = ground_acceleration;
					friction = ground_friction;
					bonus_speed = treadmill_speed;  //right moving
					break;
				case 5 :
					over = "cloud";
					speed = ground_acceleration;
					friction = ground_friction;  //jump up able platform
					break;
				case 6 :
					over = "ladder";
					speed = ground_acceleration;
					friction = ground_friction;
					break;
					
				case 7 :
					over = "trampoline";
					speed = ground_acceleration;
					friction = ground_friction;
					break;
				case 8 :
					over = "spikes";
					if (left_foot == 8 && right_foot == 8)
					{
						place_player();
					}
					break;
			}
		}
		
		public function check_collisions():void
		{
			y_pos += yspeed;
			get_edges();

			if (yspeed>0) {
				if ((bottom_right != 0 && bottom_right != playerLeftSide) || (bottom_left != 0 && bottom_left != playerLeftSide)) {
					if (bottom_right != playerRightSide && bottom_left != playerRightSide) {
						if ((bottom_right == 7 || bottom_left == 7) && (Math.abs(yspeed)>1))
						{
							// trampoline
							yspeed *= -1;
							jumping = true;
							falling = true;
						}else {
							y_pos = bottom*tile_size-9;
							yspeed = 0;
							falling = false;
							jumping = false;
						}
					} else {
						if (prev_bottom<bottom) {
							y_pos = bottom*tile_size-9;
							yspeed = 0;
							falling = false;
							jumping = false;
						}
					}
				}
			}
						
			if (yspeed<0) {
				if ((top_right != 0 && top_right != playerRightSide && top_right != playerLeftSide) || (top_left != 0 && top_left != playerRightSide && top_left != playerLeftSide)) {
					y_pos = bottom*tile_size+1+8;
					yspeed = 0;
					falling = false;
					jumping = false;
				}
			}
			x_pos += xspeed;
			get_edges();
					 
			if (xspeed < 0) {
				if (!is_walkable(top_left) || !is_walkable(bottom_left)) {
					x_pos = (left + 1) * tile_size + playerLeftSide;
					xspeed = 0;
				}
			}
											   
			if (xspeed>0) {
				if (!is_walkable(top_right) || !is_walkable(bottom_right)) {
					x_pos = right * tile_size - playerLeftSide;
					xspeed = 0;
				}
			}
			
			prev_bottom = bottom;
		}
		
		public function get_edges():void
		{
			right = Math.floor((x_pos+playerRightSide)/tile_size);
			left = Math.floor((x_pos-playerLeftSide)/tile_size);
			bottom = Math.floor((y_pos+8)/tile_size);
			top = Math.floor((y_pos-9)/tile_size);

			top_right = level[top][right];
			top_left = level[top][left];
			bottom_left = level[bottom][left];
			bottom_right = level[bottom][right];
		}
		
		public function place_player():void
		{
			x_pos = (player[0] * tile_size) + (tile_size / 2);
			y_pos = (player[1] * tile_size) + (tile_size / 2 + 1);
			
			h.x = x_pos;
			h.y = y_pos;
		}
		
		public function is_walkable(tile:int):Boolean {
			var walkable:Boolean = false;
			for (var i:int = 0; i < walkable_tiles.length; i++)
			{
				if (tile == walkable_tiles[i])
				{
					walkable = true;
					break;
				}
			}
			
			return (walkable);
		}
		
		public function endGame():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var scoreFrames:PlayerScore = new PlayerScore();
			scoreFrames.Name = ((Math.random() * 90)>>0) + "test";
			scoreFrames.Points = frameCounter;
			
			var scoreCoins:PlayerScore = new PlayerScore();
			scoreCoins.Name = scoreFrames.Name;
			scoreCoins.Points = coinCounter;
			
			var scoreCombo:PlayerScore = new PlayerScore();
			scoreCombo.Name = scoreFrames.Name;
			scoreCombo.Points = (135-coinCounter)*1.5 + (frameCounter)*2;
			
			finalTimeWindow = new PWindowExtra(300, 300, "You beat the level in\n" + frameCounter + "\nframes with\n" + coinCounter + "\ncoins!", closeTimeWindow, backToMenu, "Highscores", viewHighScores);
			finalTimeWindow.y = stage.stageHeight / 2;
			stage.addChild(finalTimeWindow);
			
			PAnimation.centerWindow(finalTimeWindow);
			PAnimation.fadeInWindow(finalTimeWindow);
		}
		
		public function viewHighScores(e:MouseEvent):void
		{
			//Leaderboards.List("Combo", loadedHighScores,{perpage:50, highest:false});
			setTimeout(loadedHighScores, 100, { Success:false} );
			
			highScoresWindow = new PScrollingContentWindow(540, 380, "= HighScores =", "Loading Scores", closeHighScoreWindow);
			highScoresWindow.x = stage.stageWidth / 2;
			highScoresWindow.y = stage.stageHeight / 2 + 25;
			stage.addChild(highScoresWindow);
			highScoresWindow.blurBackground();
			PAnimation.fadeInWindow(highScoresWindow);
		}
		
		public function loadedHighScores(scores:Array, numscores:int, response:Object):void
		{
			if (!highScoresWindow || highScoresWindow.parent == null) return;
			
			if(response.Success)
			{
				trace(scores.length + " scores returned out of " + numscores);
				highScoresWindow.notification.defaultTextFormat = new TextFormat("Arial", 12,null,null,null,null,null,null,'left');
				highScoresWindow.notification.text = "Rank                Score                    User\n";
				for(var i:int=0; i<scores.length; i++)
				{
					var score:PlayerScore = scores[i];
					
					highScoresWindow.notification.appendText(getFormattedScore(score,i+1));
					//highScoresWindow.notification.appendText("  " + (i+1) + "\t\t" + score.Name + "\t\t\t\t" + score.Points + "\n");
					trace(" - " + score.Name + " got " + score.Points + " on " + score.SDate);
					
					// including custom data?  score.CustomData["property"]
				}
				highScoresWindow.notification.appendText("\n  ");
			}
			else
			{
				// score listing failed because of response.ErrorCode
				highScoresWindow.notification.appendText("Error: " + response.ErrorCode);
			}
		}
		
		public function getFormattedScore(score:PlayerScore, num:int):String
		{
			var s:String = "";
			s += "  ";
			s += num;
			if (num < 10) s += "  ";
			s += "                         ";
			s += score.Points;
			if (score.Points < 100) s += "  ";
			if (score.Points < 1000) s += "  ";
			if (score.Points < 10000) s += "  ";
			s += "                         ";
			s += score.Name.substr(0, 20);
			s += "\n";
			return s;
		}
		
		public function closeHighScoreWindow(e:MouseEvent):void
		{
			PAnimation.fadeOutWindow(highScoresWindow, killHighScoresWindow );
		}
		
		public function killHighScoresWindow():void
		{
			highScoresWindow.kill()
			highScoresWindow = null;
		}
		
		public function backToMenu(e:MouseEvent):void
		{
			var i:int = 0;
			for (i = 0; i < coins.length; i++)
			{
				if (coins[i].parent)
					coins[i].parent.removeChild(coins[i]);
			}
			for (i = 0; i < levelObj.length; i++)
			{
				if (levelObj[i].parent)
					levelObj[i].parent.removeChild(levelObj[i]);
			}
			for (i = 0; i < keys.length; i++)
			{
				if (keys[i].parent)
					keys[i].parent.removeChild(keys[i]);
			}
			
			level.length = 0;
			coins.length = 0;
			levelObj.length = 0;
			keys.length = 0;
			
			while (level_container.numChildren > 0)
			{
				level_container.removeChildAt(0);
			}
			
			h = null;
			specialCoin = null;
			
			stage.removeChild(hud);
			hud = null;
			
			
			PAnimation.moveWindowRight(finalTimeWindow, stage.stageWidth / 2);
			PAnimation.fadeOutWindow(finalTimeWindow, createMenu);
		}
		
		public function createMenu():void
		{
			var m:MainMenu = new MainMenu();
			stage.addChild(m);
			parent.removeChild(this);
		}
		
		public function closeTimeWindow(e:MouseEvent):void
		{
			PAnimation.moveWindowRight(finalTimeWindow, stage.stageWidth / 2);
			PAnimation.fadeOutWindow(finalTimeWindow, startGame);
			
			leftPressed = false;
			rightPressed = false;
			upPressed = false
			downPressed = false;
			spacePressed = false;
			falling = false;
			climbing = false;
			xspeed = yspeed = 0;
			
			var i:int = 0;
			for (i = 0; i < coins.length; i++)
			{
				coins[i].parent.removeChild(coins[i]);
				level_container.addChild(coins[i]);
			}
			
			place_player();
			onEnterFrame();
		}
	}
}
