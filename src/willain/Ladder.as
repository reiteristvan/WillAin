package willain 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class Ladder extends FlxSprite 
	{
		public function Ladder(x:Number, y:Number, graphic:Class = null) : void 
		{
			super(x, y, graphic);
			
			makeGraphic(32, 32, 0xFF00FF00);
			velocity.x = velocity.y = 0;
			acceleration.x = acceleration.y = 0;
			drag.x = drag.y = 0;
			immovable = true;
		}
		
	}

}