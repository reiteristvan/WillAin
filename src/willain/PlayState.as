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
		
		private var fireRateCounter:Number = 0;
		
		public function PlayState() : void
		{
			level = new FlxTilemap();
			player = new Player(10, 10);
			
			enemies = new FlxGroup();
			items = new FlxGroup();
			bullets = new FlxGroup();
			
			level.loadMap(FlxTilemap.arrayToCSV(Global.DummyLevel, 32), Global.TileGraphic, 32, 32);
			
			add(level);
			add(enemies);
			add(items);
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
						
			if (FlxG.keys.LEFT)
			{
				player.acceleration.x = -player.maxVelocity.x * 4;
				player.facing = FlxObject.LEFT;
			}
			
			if (FlxG.keys.RIGHT)
			{
				player.acceleration.x = player.maxVelocity.x * 4;
				player.facing = FlxObject.RIGHT;
			}
			
			if((FlxG.keys.SPACE || FlxG.keys.UP) && player.isTouching(FlxObject.FLOOR))
				player.velocity.y = -player.maxVelocity.y / 2;
			if (FlxG.keys.X && fireRateCounter >= player.fireRate)
			{
				shoot(false, new FlxPoint(player.x + 32, player.y + 16), player.facing);
				fireRateCounter = 0;
			}
		
			enemies.members.forEach(updateEnemies);
				
			super.update();
			
			FlxG.collide(level, player);
			FlxG.collide(level, enemies);
			FlxG.collide(level, items);
			
			FlxG.collide(bullets, player, bulletCollision);
			FlxG.collide(bullets, enemies, bulletCollision);
			FlxG.collide(bullets, level, bulletCollision);
			
			FlxG.collide(items, player, itemCollision);
		}
		
		private function shoot(enemy:Boolean, position:FlxPoint, direction:uint) : void
		{
			var bullet:Bullet = new Bullet(position.x, position.y);
			bullet.enemy = enemy;
			
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
				player.hurt(bullet.damage);
			else
				b.hurt(bullet.damage);
				
			bullet.kill();
		}
		
		private function itemCollision(a:FlxObject, b:FlxObject) : void
		{
			
		}
	}

}