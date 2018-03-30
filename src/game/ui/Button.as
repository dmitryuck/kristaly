package game.ui
{	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;	
	import starling.events.TouchPhase;
	
	import game.core.Audio;
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	
	public class Button extends Component
	{
		public var normalState:String;
		public var downState:String;
		public var disabledState:String;
		
		public static const BUTTON_TYPE_CHECK:String = "BUTTON_TYPE_CHECK";
		public static const BUTTON_TYPE_RADIO:String = "BUTTON_TYPE_RADIO";
		
		public var buttonType:String;
		
		public var text:Text;
		
		private var _enabled:Boolean = true;
		
		private var _checked:Boolean;
		public var group:String;
		
		public var buttonClick:Function;
		
		
		public function Button(normalState:String, downState:String = null, buttonClick:Function = null, text:Text = null, disabledState:String = null)
		{
			super(normalState);
			
			useHandCursor = true;
			
			this.normalState = normalState;
			this.downState = downState;
			this.disabledState = disabledState;
			
			this.buttonClick = buttonClick;
			
			this.text = text;
		}
		
		// Установить новый текст
		public function setText(text:String, textStyle:Object = null):void
		{
			if (this.text) this.text.setText(text);
			else
			{
				this.text = new Text(text, textStyle);
				
				addText();
			}
		}
		
		// Добавить текст на кнопку
		public function addText():void
		{
			if (text)
			{
				text.x = Math.round((this.width - text.textField.width) / 2);
				text.y = Math.round((this.height - text.textField.height) / 2);
				
				addChild(text);				
			}
		}
		
		// Кнопка создана
		override protected function onCreate(e:ComponentEvent):void 
		{
			super.onCreate(e);
			
			/*addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			addEventListener(MouseEvent.CLICK, onClick);*/
			
			addEventListener(TouchEvent.TOUCH, onButtonTouch);
			
			addText();
		}
		
		// Кнопка удалена
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			/*removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			removeEventListener(MouseEvent.CLICK, onClick);*/
			
			removeEventListener(TouchEvent.TOUCH, onButtonTouch);
		}
		
		// Нажатие на кнопку
		protected function onButtonTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			
			if (touch != null)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					onMouseDown();
				}
				
				if (touch.phase == TouchPhase.ENDED)
				{					
					onMouseUp();					
								
					if (enabled && buttonClick != null) buttonClick();					
				}
			}
			
			/*var touches:Vector.<Touch> = e.getTouches(this);
			var clicked:Component = e.currentTarget as Component;
			
			if (touches.length == 1)
			{
				var touch:Touch = touches[0];
				
				if (touch.phase == TouchPhase.BEGAN)
				{
					onMouseDown();
				}
				
				if (touch.phase == TouchPhase.ENDED)
				{
					//trace (e.currentTarget, e.target);
					
					onMouseUp();
					
					if (e.target == this)
					{
						if (enabled && buttonClick != null) buttonClick();
					}
				}
			}*/
		}
		
		// Кнопка нажата
		protected function onMouseDown():void 
		{
			if (enabled && downState)
			{
				if (buttonType == BUTTON_TYPE_CHECK)
				{
					if (checked) setSource(normalState);
					//if (!checked) setSource(downState);
					
					checked = !checked;
				} else setSource(downState);
			}
		}
		
		// Кнопка отпущена
		protected function onMouseUp():void 
		{
			if (enabled && fileName != normalState)
			{
				if (buttonType == BUTTON_TYPE_CHECK)
				{
					if (!checked) setSource(normalState); else setSource(downState);
				}	else if (!buttonType) setSource(normalState);
			}
		}
		
		// Отжать кнопку или перевести в невыбранное состояние
		public function unCheck():void
		{
			if (buttonType == BUTTON_TYPE_CHECK && checked)
			{
				checked = false;
				
				setSource(normalState);
			}
		}
		
		// Установка свойств
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			if (value == false && disabledState)
			{
				setSource(disabledState);
				//addEventListener(MouseEvent.CLICK, onClick);
			} else if (value == true)
			{
				setSource(normalState);
				//removeEventListener(MouseEvent.CLICK, onClick);
			}
			
			_enabled = value;
		}
		
		public function get checked():Boolean 
		{
			return _checked;
		}
		
		public function set checked(value:Boolean):void 
		{
			if (value == true) setSource(downState); else setSource(normalState);
			
			_checked = value;
		}
		
	}
}