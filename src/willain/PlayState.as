package willain 
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
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
		private var lethalBullet:Boolean = false;
		
		public function PlayState() : void
		{
			level = new FlxTilemap();
			player = new Player(32, 32);
			
			enemies = new FlxGroup();
			items = new FlxGroup();
			bullets = new FlxGroup();
			ladders = new FlxGroup();
			
			level.loadMap(FlxTilemap.arrayToCSV(Global.DummyLevel, 40), Global.TileGraphic, 32, 32);
			
			var e:Enemy = new Enemy(6 * 32, 10 * 32);
			enemies.add(e);
			
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
			if(fireRateCounter <= player.fireRate)
				fireRateCounter += FlxG.elapsed;
			
			if (player.invisible)
			{
				player.invisibilityTimer -= FlxG.elapsed;
				
				if (player.invisibilityTimer <= 0)
					player.setInvisibility(false);
			}
			else
			{
				if (player.invisibilityTimer <= 5)
					player.invisibilityTimer += FlxG.elapsed;
			}
			
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
				shoot(false, new FlxPoint(player.x + 48, player.y + 16), player.facing);
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
			
			FlxG.overlap(bullets, player, bulletCollision);
			FlxG.overlap(bullets, enemies, bulletCollision);
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
				bullet.x -= 24;
			}
			
			bullets.add(bullet);
		}
		
		private function updateEnemies(item:*, index:int, array:Array) : void
		{
			var enemy:Enemy = item as Enemy;
			enemy.acceleration.x = 0;
			
			// handle paralizing
			if (enemy.paralized)
			{
				enemy.paralizeTimer -= FlxG.elapsed;
				
				if (enemy.paralizeTimer <= 0)
				{
					enemy.setParalize(false);
				}
				
				return;
			}
			
			if (enemy.fireRateCounter <= enemy.fireRate)
				enemy.fireRateCounter += FlxG.elapsed;
			
			// player is line of sigth
			if (!player.invisible && (player.y == enemy.y) && (Math.abs(player.x - enemy.x) < 64))
			{
				if (player.x < enemy.x)
					enemy.facing = FlxObject.LEFT;
				else
					enemy.facing = FlxObject.RIGHT;
				
				if (enemy.fireRateCounter >= enemy.fireRate)
				{
					shoot(true, new FlxPoint(enemy.x + 48, enemy.y + 16), enemy.facing);
					enemy.fireRateCounter = 0;
				}
					
				return;
			}
			
			// patrol
			if (enemy.x > enemy.startPosition.x + enemy.range)
				enemy.facing = FlxObject.LEFT;
			else if (enemy.x < enemy.startPosition.x - enemy.range)
				enemy.facing = FlxObject.RIGHT;
			
			if (enemy.facing == FlxObject.LEFT)
				enemy.acceleration.x = -enemy.maxVelocity.x * 4;
			else
				enemy.acceleration.x = enemy.maxVelocity.x * 4;
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
				bullets.remove(a, true);
				return;
			}
			
			var bullet:Bullet = a as Bullet;
			
			if (b is Player && bullet.enemy)
			{
				player.hurt(bullet.damage);
			}
			else if(b is Enemy)
			{
				if (bullet.lethal)
				{
					b.kill();
					enemies.remove(b, true);
				}
				else
				{
					var e:Enemy = b as Enemy;
					e.setParalize(true);
				}
			}
			
			bullet.kill();
			bullets.remove(bullet, true);
		}
		
		private function itemCollision(a:FlxObject, b:FlxObject) : void
		{
			
		}
	}

}