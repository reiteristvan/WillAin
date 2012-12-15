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
		
		public function Bullet(x:Number, y:Number) 
		{
			super(x, y);
			
			makeGraphic(6, 3, 0xFFFF0011);
			
			maxVelocity.x = 150;
			maxVelocity.y = 10;
			acceleration.y = 0;
			acceleration.x = 150;
			drag.x = maxVelocity.x * 4;
		}
	}

}