package
{	
	import starling.core.Starling;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;

	import game.core.Game;
	
	/**
	 * ...
	 * Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	[SWF(width="800", height="500", frameRate="60", backgroundColor="#002143")]
	public class Main extends Sprite 
	{
		
		public static var starling:Starling;		
		
		public function Main()
		{			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;		
			stage.displayState = StageDisplayState.NORMAL;

			starling = new Starling (Game, stage);
			starling.enableErrorChecking = true;
			starling.start();
		}
	}
}