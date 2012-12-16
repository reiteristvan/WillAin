package willain
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author Istvan Reiter
	 */
	public class Main extends FlxGame
	{
		public function Main() : void 
		{
			super(640, 480, PlayState, 1, 60);
		}
	}
	
}