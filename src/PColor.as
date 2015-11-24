package  
{
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PColor
	{
		
		public function PColor() 
		{
			
		}
		
		//http://www.pixelwit.com/blog/2007/05/hexadecimal-color-fading/
		public static function blendHexColors (hex:uint, hex2:uint, ratio:Number):uint
		{
			var r:Number  = hex >> 16;
			var g:Number = hex >> 8 & 0xFF;
			var b:Number  = hex & 0xFF;
			r += ((hex2 >> 16)-r)*ratio;
			g += ((hex2 >> 8 & 0xFF)-g)*ratio;
			b += ((hex2 & 0xFF)-b)*ratio;
			return(r<<16 | g<<8 | b);
		}
	}

}