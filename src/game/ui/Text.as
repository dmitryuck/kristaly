package game.ui 
{
	import starling.display.Sprite;	
	import starling.text.TextField;
	import starling.utils.Color;
	
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class Text extends Component 
	{
		private var _text:String;
		
		public var textField:TextField;
		public var textFormat:TextFormat;	
		
		private const defFontSize:int = 20;
		private const defFieldHeight:int = 100;
		private const defFieldWidth:int = 100;
		
		public function Text(text:String, style:Object = null) 
		{
			super(null);
			
			this._text = text;

			textField = new TextField(defFieldWidth, defFieldHeight, text, "Arial", defFontSize);
			
			if(style != null)
			{
				for (var key:String in style)
				{
					textField.width = style["width"];
					textField.height = style["height"];
					
					textField.fontSize = style["fontSize"];
					
					textField.color = Color.WHITE;
				}
			}
			
			//var styleSheet:StyleSheet = new StyleSheet();			
			//styleSheet.setStyle("p", style);
			
			//var htmlText:String = "<p>" + text + "</p>";
			
			//textField.styleSheet = styleSheet;
			//textField.htmlText = htmlText;
			
			//textField.embedFonts = true;
			
			//textField.selectable = false;
			//textField.multiline = true;
			//textField.wordWrap = true;
			
			//textField.autoSize = TextFieldAutoSize.LEFT;
			//textField.antiAliasType = AntiAliasType.ADVANCED;
			
			/*textFormat = new TextFormat();	
			
			textFormat.size = style["size"];
			textFormat.color = style["color"];
			textFormat.font = style["fontFamily"];
				
			textFormat.align = TextFormatAlign.LEFT;
			
			textField.setTextFormat(textFormat);
			
			textField.text = text;
			
			/*switch (style["align"])
			{
				case "left" : textField.autoSize = TextFieldAutoSize.LEFT;
				break;
				
				case "center" : textField.autoSize = TextFieldAutoSize.CENTER;
				break;
				
				default : textField.autoSize = TextFieldAutoSize.LEFT;
			}*/
			
			addChild(textField);
		}
		
		// Установить новый текст
		public function setText(text:String):void
		{
			//var htmlText:String = "<p>" + text + "</p>";
			
			textField.text = text;
		}
		
		public function getText():String
		{
			return _text;
		}
	}

}