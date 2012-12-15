package willain 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class Player extends FlxSprite 
	{
		public var fireRate:Number = 0.5;
		
		public function Player(x:Number, y:Number, graphic:Class = null) : void
		{
			super(x, y, graphic);
			
			makeGraphic(32, 32, 0xFFFF0000);
			
			maxVelocity.x = 100;
			maxVelocity.y = 270;
			acceleration.y = 250;
			drag.x = maxVelocity.x * 4;
			facing = FlxObject.RIGHT;
			health = 100;
		}
		
		override public function update() : void 
		{
			super.update();
		}
	}

}