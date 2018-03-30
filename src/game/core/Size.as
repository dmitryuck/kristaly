package game.core 
{
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 * e-mail dmitriy.mihaylichenko@gmail.com
	 */
	public class Size 
	{
		private var _width:int;
		private var _height:int;
		
		public function Size(width:int, height:int) 
		{
			this.width = width;
			this.height = height;
		}
		
		public function get width():int 
		{
			return _width;
		}
		
		public function set width(value:int):void 
		{
			_width = value;
		}
		
		public function get height():int 
		{
			return _height;
		}
		
		public function set height(value:int):void 
		{
			_height = value;
		}
		
	}

}