package willain 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class Bullet extends FlxSprite 
	{
		[Embed(source="assets/bullet.png")]
		static public const Graphic:Class;
		
		public var enemy:Boolean = false;
		public var damage:Number = 50;
		public var lethal:Boolean = true;
		
		public function Bullet(x:Number, y:Number, lethal:Boolean = true) 
		{
			super(x, y, Bullet.Graphic);
			
			lethal = lethal;
			maxVelocity.x = 150;
			maxVelocity.y = 10;
			acceleration.y = 0;
			acceleration.x = 200;
			drag.x = maxVelocity.x * 4;
		}
	}

}