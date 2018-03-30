package game.core 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 * e-mail dmitriy.mihaylichenko@gmail.com
	 */
	public class Audio
	{
		public static var musicChannel:SoundChannel;
		public static var playList:Object;
		
		public static var canSoundPlay:Boolean = true;
		public static var canMusicPlay:Boolean = true;
		
		
		public function Audio() 
		{
			
		}
		
		// Проиграть звук
		public static function playSound(fileName:String, onComplete:Function = null):void
		{
			if (canSoundPlay)
			{
				var source:Source = new Source(fileName);
				
				var byteArray:ByteArray = new ByteArray();
				byteArray = source.getSource();
				
				byteArray.position = 0;
				
				var sound:Sound = new Sound();			
				
				sound.loadCompressedDataFromByteArray(byteArray, byteArray.length);			
				
				var soundChannel:SoundChannel = sound.play();
				soundChannel.addEventListener(Event.SOUND_COMPLETE, onPlayingComplete);
				
				if (!playList) playList = new Object();
				
				var index:int = getObjectSize(playList);
				
				playList[index] = soundChannel;
				
				function getObjectSize(obj:Object):int
				{
					var length:int = 0;
					
					if (obj != { } || obj != null)
					{
						for (var s:String in obj)
						{						
							length++;
						}
					} 
					return length;
				}
				
				function onPlayingComplete(e:Event):void
				{
					if (onComplete != null) onComplete();					
					playList[index] = null;
				}
			}
		}
		
		// Остановить все проигрываемые звуки
		public static function stopAllSounds():void
		{
			if (playList)
			{
				for each (var soundChannel:SoundChannel in playList)
				{
					if (soundChannel)
					{
						soundChannel.stop();
						soundChannel = null;
					}
				}
			}
		}
		
		// Проиграть музыку
		public static function playMusic(fileName:String, loop:Boolean = false, onComplete:Function = null):void
		{
			stopMusic();
			
			if (canMusicPlay)
			{			
				var source:Source = new Source(fileName);
				
				var byteArray:ByteArray = new ByteArray();
				byteArray = source.getSource();
				
				byteArray.position = 0;
				
				var sound:Sound = new Sound();			
				
				sound.addEventListener(Event.SOUND_COMPLETE, onPlayingComplete);
				sound.loadCompressedDataFromByteArray(byteArray, byteArray.length);
				
				if (!musicChannel) musicChannel = new SoundChannel();
				
				musicChannel = sound.play(0, loop ? 10 : 0);
				
				function onPlayingComplete(e:Event):void
				{
					if (onComplete) onComplete();
				}
			}
		}
		
		// Остановить проигрывание музыки
		public static function stopMusic():void
		{
			if (musicChannel)
			{
				musicChannel.stop();				
				musicChannel = null;
			}			
		}
	}

}