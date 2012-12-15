package willain 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class Bullet extends FlxSprite 
	{
		public var enemy:Boolean = false;
		public var damage:Number = 10;
		public var lethal:Boolean = true;
		
		public function Bullet(x:Number, y:Number, lethal:Boolean = true) 
		{
			super(x, y);
			
			makeGraphic(6, 3, 0xFFFF0011);
			
			lethal = lethal;
			maxVelocity.x = 150;
			maxVelocity.y = 10;
			acceleration.y = 0;
			acceleration.x = 150;
			drag.x = maxVelocity.x * 4;
		}
	}

}