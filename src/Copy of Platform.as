package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Platform extends Sprite
	{
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
		private var ice_acceleration:Number = 0.15;
		private var ice_friction:Number = 0.95;
		private var treadmill_speed:Number = 2;
		
		//player properties
		private var playerRightSide:int = 5;
		private var playerLeftSide:int = 6;
		private var max_speed:Number = 3;
		private var xspeed:Number = 0;
		private var yspeed:Number = 0;
		private var falling:Boolean = false;
		private var gravity:Number = 0.5;
		private var jump_speed:Number = 6;
		private var climbing:Boolean = false;
		private var climb_speed:Number = 0.8;
		
		//in game objects
		private var coins:Array = new Array();
		private var level:Array = new Array();
		private var levelObj:Array = new Array
		private var keys:Array = new Array();
		private var player:Array = new Array();
		private var enemy:Array = new Array();
		
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
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			//level definition. Perhaps recode this to our way? or something
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
			
			player = [4,8];
			
			coins[0] = [2, 2];
			coins[1] = [23, 4];
			
			enemy[0] = [10, 3, -2];
			enemy[1] = [3, 3, -2];
			
			keys[0] = [1, 5, 5, 8];
			
			create_level(level);
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
		}
		
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
		
		public function onEnterFrame(event:Event):void
		{
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
			
			level_container.x = int(-x_pos + 250);
			level_container.y = int(-y_pos + 200);
			
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
				if(coins[j].hitTestObject(h))
				{
					level_container.removeChild(coins[j]);
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
					bonus_speed = -treadmill_speed;
					break;
				case 4 :
					over = "treadmill";
					speed = ground_acceleration;
					friction = ground_friction;
					bonus_speed = treadmill_speed;
					break;
				case 5 :
					over = "cloud";
					speed = ground_acceleration;
					friction = ground_friction;
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
	}
}
