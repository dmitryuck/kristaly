package game.core 
{	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import deng.fzip.FZipFile;
	import deng.fzip.FZipEvent;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class Source
	{
		private var _fileName:String;

		private var fileInZip:FZipFile;
		
		private var sourceType:String;
		
		public static const SOURCE_TYPE_FLASH:String = "FLASH";
		public static const SOURCE_TYPE_VECTOR:String = "VECTOR";		
		public static const SOURCE_TYPE_RASTER:String = "RASTER";
		
		public static const SOURCE_TYPE_SCENE:String = "SCENE";
		public static const SOURCE_TYPE_WINDOW:String = "WINDOW";
		
		public static const SOURCE_TYPE_SOUND:String = "SOUND";
		public static const SOURCE_TYPE_MUSIC:String = "MUSIC";
		
		public static const SOURCE_TYPE_UNDEF:String = "UNDEF";
		
		
		public function Source(fileName:String = "") 
		{			
			if (fileName) setSource(fileName);		
		}		
		
		// Установка ресурса
		public function setSource(fileName:String):void
		{
			this.fileName = fileName;				

			fileInZip = new FZipFile();				
			fileInZip = Game.assets.getFileByName("assets/" + fileName);
			
			setSourceType(fileName);
		}
		
		// Получить контент ресурса в виде масива байтов
		public function getSource():ByteArray
		{
			if (fileInZip)
			{
				return fileInZip.content;					
			}			
			
			return null;
		}		
		
		// Получить тип даного ресурса
		public function getSourceType():String
		{
			if (sourceType) return sourceType; else return Source.SOURCE_TYPE_UNDEF;
		}
		
		// Установить тип даного ресурса
		private function setSourceType(fileName:String):void
		{
			var pointPosition:int;
			
			for (var i:int = 0; i < fileName.length; i++)
			{
				if (fileName.charAt(i) == ".")
				{
					pointPosition = i; 
					break;
				}
			}
			
			var file:String = fileName.slice(pointPosition, fileName.length);
			
			switch (file)
			{
				// Растры
				case ".png": sourceType = SOURCE_TYPE_RASTER;
				break;
				case ".bmp": sourceType = SOURCE_TYPE_RASTER;
				break;
				case ".jpg": sourceType = SOURCE_TYPE_RASTER;
				break;				
				// Векторные
				case ".svg": sourceType = SOURCE_TYPE_VECTOR;
				break;
				case ".swf": sourceType = SOURCE_TYPE_FLASH;
				break;				
				// Аудио
				case ".wav": sourceType = SOURCE_TYPE_SOUND;
				break;
				case ".mp3": sourceType = SOURCE_TYPE_MUSIC;
				break;
				case ".ogg": sourceType = SOURCE_TYPE_MUSIC;
				break;				
				// Сцена
				case ".scn": sourceType = SOURCE_TYPE_SCENE;
				break;
				// Окно
				case ".wnd": sourceType = SOURCE_TYPE_WINDOW;
				break;
				
				default: sourceType = SOURCE_TYPE_UNDEF;
				break;
			}
		}			
		
		public function get fileName():String 
		{
			return _fileName;
		}
		
		public function set fileName(value:String):void 
		{
			_fileName = value;
		}
		
	}

}