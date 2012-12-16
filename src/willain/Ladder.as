package willain 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class Ladder extends FlxSprite 
	{
		[Embed(source="assets/ladder.png")]
		static public const Graphic:Class;
		
		public function Ladder(x:Number, y:Number, graphic:Class = null) : void 
		{
			super(x, y, Ladder.Graphic);
			
			velocity.x = velocity.y = 0;
			acceleration.x = acceleration.y = 0;
			drag.x = drag.y = 0;
			immovable = true;
		}
		
	}

}