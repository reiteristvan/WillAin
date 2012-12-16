package willain 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class Enemy extends FlxSprite 
	{		
		public var fireRate:Number = 0.9;
		public var fireRateCounter:Number = 0;
		public var paralizeTimer:Number = 15;
		public var paralized:Boolean = false;
		public var range:Number = 96;
		public var startPosition:FlxPoint;
		
		public function Enemy(x:Number, y:Number, graphic:Class = null) : void 
		{
			super(x, y, graphic);
			startPosition = new FlxPoint(x, y);
			
			makeGraphic(32, 32, 0xFF004455);
			
			maxVelocity.x = 60;
			maxVelocity.y = 200;
			acceleration.y = 220;
			drag.x = maxVelocity.x * 4;
			facing = FlxObject.RIGHT;
			health = 100;
		}
		
		public function setParalize(value:Boolean) : void
		{
			paralized = value;
			
			if(value == false)
				paralizeTimer = 15;
		}
	}

}