package willain 
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class PlayState extends FlxState 
	{
		private var level:FlxTilemap;
		private var player:Player;
		
		private var enemies:FlxGroup;
		private var items:FlxGroup;
		private var bullets:FlxGroup;
		private var ladders:FlxGroup;
		
		private var fireRateCounter:Number = 0;
		private var lethalBullet:Boolean = true;
		
		public function PlayState() : void
		{
			level = new FlxTilemap();
			player = new Player(32, 32);
			
			enemies = new FlxGroup();
			items = new FlxGroup();
			bullets = new FlxGroup();
			ladders = new FlxGroup();
			
			level.loadMap(FlxTilemap.arrayToCSV(Global.DummyLevel, 40), Global.TileGraphic, 32, 32);
			
			add(level);
			add(enemies);
			add(items);
			add(ladders);
			add(bullets);
			add(player);
		}
	
		override public function create():void 
		{
			FlxG.mouse.hide();
			
			super.create();
			
			FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			FlxG.worldBounds.width = level.width;
			FlxG.worldBounds.height = level.height;
		}
		
		override public function update():void 
		{
			fireRateCounter += FlxG.elapsed;
			player.acceleration.x = 0;
			
			if (player.onLadder)
				player.acceleration.y = 0;
			
			// move left
			if (FlxG.keys.LEFT)
			{
				player.acceleration.x = -player.maxVelocity.x * 4;
				player.facing = FlxObject.LEFT;
			}
			
			// move right
			if (FlxG.keys.RIGHT)
			{
				player.acceleration.x = player.maxVelocity.x * 4;
				player.facing = FlxObject.RIGHT;
			}
			
			// jump && climb
			if (player.onLadder)
			{
				player.acceleration.y = 0;
				
				if (FlxG.keys.SPACE || FlxG.keys.UP)
					player.velocity.y = -player.maxVelocity.y / 2;
				else if (FlxG.keys.DOWN)
					player.velocity.y = player.maxVelocity.y / 2;
				else 
					player.velocity.y = 0;
			}
			else
			{
				player.acceleration.y = 250;
				
				if ((FlxG.keys.SPACE || FlxG.keys.UP) && player.isTouching(FlxObject.FLOOR))
				{
					player.velocity.y = -player.maxVelocity.y / 2;					
				}
			}
			
			// shoot
			if (FlxG.keys.X && fireRateCounter >= player.fireRate)
			{
				shoot(false, new FlxPoint(player.x + 32, player.y + 16), player.facing);
				fireRateCounter = 0;
			}
			
			// invisibility
			if (FlxG.keys.C)
				player.setInvisibility(!player.invisible);
			
			// bullet type
			if (FlxG.keys.V)
				lethalBullet = !lethalBullet;
				
			enemies.members.forEach(updateEnemies);
				
			super.update();
			
			FlxG.collide(level, player);
			FlxG.collide(level, enemies);
			FlxG.collide(level, items);
			
			player.onLadder = FlxG.overlap(ladders, player);
			
			FlxG.collide(bullets, player, bulletCollision);
			FlxG.collide(bullets, enemies, bulletCollision);
			FlxG.collide(bullets, level, bulletCollision);
			FlxG.collide(items, player, itemCollision);
		}
		
		private function shoot(enemy:Boolean, position:FlxPoint, direction:uint) : void
		{
			var bullet:Bullet = new Bullet(position.x, position.y);
			bullet.enemy = enemy;
			bullet.lethal = lethalBullet;
			
			if (direction == FlxObject.LEFT)
			{
				bullet.acceleration.x *= -1;
				bullet.x -= 16;
			}
			
			bullets.add(bullet);
		}
		
		private function updateEnemies(item:*, index:int, array:Array) : void
		{
			var enemy:Enemy = item as Enemy;
			
			if (enemy.paralized)
			{
				enemy.paralizeTimer -= FlxG.elapsed;
				
				if (enemy.paralizeTimer <= 0)
				{
					enemy.setParalize(false);
					enemy.paralizeTimer = 15;
				}
			}
		}
		
		private function playerNearLadder(a:FlxObject, b:FlxObject) : void
		{
			player.onLadder = true;
		}
		
		private function bulletCollision(a:FlxObject, b:FlxObject) : void
		{
			if (b is FlxTilemap)
			{
				a.kill();
				return;
			}
			
			var bullet:Bullet = a as Bullet;
			
			if (b is Player && bullet.enemy)
			{
				player.hurt(bullet.damage);
			}
			else
			{
				if (bullet.lethal)
				{
					b.hurt(bullet.damage);
				}
				else
				{
					var e:Enemy = b as Enemy;
					e.setParalize(true);
				}
				
				bullet.kill();
			}
		}
		
		private function itemCollision(a:FlxObject, b:FlxObject) : void
		{
			
		}
	}

}