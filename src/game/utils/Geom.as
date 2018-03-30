package game.utils 
{
	import flash.geom.*;
	import game.core.GameObject;
	import game.core.Position;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 * e-mail dmitriy.mihaylichenko@gmail.com
	 */
	public class Geom
	{
		
		public function Geom() 
		{
			
		}
		
		// Дистанция между точками
		public static function getDistance(a:Point, b:Point):Number
		{
			return Math.sqrt(Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2));
		}		
		
		// Поворот обьекта к точке движения
		public static function rotateToPoint(currentRotation:Number, currentPosition:Point, newPosition:Point):Number
		{
			var newRotation:int = Math.round(Math.atan2(newPosition.y - currentPosition.y, newPosition.x - currentPosition.x) / Math.PI * 180) + 90;
			
			var angle:Number = getBetweenTwoAngles(currentRotation, newRotation);
			
			//trace(angle);
			//trace(newRotation);
			//trace(currentRotation);
			//trace("-----");			
			
			//if (angle < 0) return newRotation + angle * -1; else return  newRotation;
			
			//if (currentRotation + newRotation > 360) angle = 
			
			function minAngle(from:Number, to:Number):Number 
			{
				to = to % 360;
				from = from % 360;
				if(to < 0) to += 360;
				if (from < 0) from += 360;
				var cw:Number = to - from;
				if (cw < 0) cw += 360;
				var ccw:Number = from - to;
				if (ccw < 0) ccw += 360;
				return (cw < ccw ? cw : - ccw);
			}
			
			return newRotation;
		}
		
		// Угол между точками
		public static function getAngle(a:Point, b:Point):Number
		{
			return Math.round(Math.acos((b.x - a.x) / getDistance(a, b)) / Math.PI * 180);
		}
		
		public static function getVector(length:Number, angle:Number):Point 
		{
			var a:Number = Math.abs(length) * Math.cos(angle);
			var b:Number = Math.abs(length) * Math.sin(angle);
			return new Point(a, b);
		}		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//

		public static function sign(value:Number):int 
		{
			return value == 0?0:(value < 0? -1:1);
		}

		public static function distance(p1:Point, p2:Point):Number
		{
			return Math.sqrt(Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2));
		}

		public static function percent(value:Number, basis:Number, number_after_dot:uint = 2):Number
		{
			return round(value / basis * 100, number_after_dot);
		}

		public static function round(value:Number, number_after_dot:uint = 3):Number
		{
			var delim:Number = Math.pow(10, number_after_dot);
			return Math.floor(value * delim) / delim;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		static public function toRadians(value:Number):Number
		{
			return value * Math.PI / 180;
		}

		static public function toGrad(value:Number):Number
		{
			return value / Math.PI * 180;
		}

		static public function getBetweenTwoAngles(angle1:Number, angle2:Number):Number
		{
			angle1 = normalizeAngle(angle1);
			angle2 = normalizeAngle(angle2);

			var min:Number = Math.min(angle1, angle2);
			var max:Number = Math.max(angle1, angle2);

			var signMin:int = sign(min);
			var signMax:int = sign(max);

			var result:Number = 0;
			if (signMin == signMax) {
				result = (angle2 - angle1);
			}else {
				result = normalizeAngle(360 - (angle1 - angle2));
			}

			return result;
		}

		static public function normalizeAngle(angle:Number):Number
		{
			var norm360:Number = normalizeAngleTo360(angle);

			var sign:int = sign(norm360);
			var abs:Number = Math.abs(norm360);
			var result:Number = abs;

			if (sign == 1 && abs > 180) {
				if (abs < 180) {
					result = abs;
				}else {
					result = abs - 360;
				}
			}else if (sign == -1) {
				if (abs < 180) {
					result = - abs;
				}else {
					result = 360 -abs;
				}
			}

			return result;
		}

		static public function normalizeAngleTo360(angle:Number):Number
		{
			var sign:int = sign(angle);
			var result:Number = Math.abs(angle);
			var count:int = result / 360;
			if (count >= 1) result -= count * 360;
			return result * sign;
		}
		
		/*public function set angle(value:Number):void 
		{
			if (value != _angle) {
				_angle = normalizeAngle(value);
				_radAngle = toRadians(_angle);// * Math.PI / 180;
				_sin = Math.sin(_radAngle);
				_cos = Math.cos(_radAngle);
			}
			_angle = value;
		}*/

	}

}