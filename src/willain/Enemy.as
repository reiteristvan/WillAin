package willain 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class Enemy extends FlxSprite 
	{		
		public var paralizeTimer:Number = 15;
		public var paralized:Boolean = false;
		
		public function Enemy(x:Number, y:Number, graphic:Class = null) : void 
		{
			super(x, y, graphic);
			
			makeGraphic(32, 32, 0xFF004455);
			
			maxVelocity.x = 80;
			maxVelocity.y = 200;
			acceleration.y = 220;
			health = 100;
		}
		
		public function setParalize(value:Boolean) : void
		{
			paralized = true;
		}
	}

}