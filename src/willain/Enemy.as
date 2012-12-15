package willain 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class Enemy extends FlxSprite 
	{		
		public function Enemy(x:Number, y:Number, graphic:Class = null) : void 
		{
			super(x, y, graphic);
			
			makeGraphic(32, 32, 0xFF004455);
			
			maxVelocity.x = 80;
			maxVelocity.y = 200;
			acceleration.y = 220;
			health = 100;
		}	
	}

}