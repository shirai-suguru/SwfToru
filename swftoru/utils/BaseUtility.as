package swftoru.utils{

	import flash.utils.*;

	public class BaseUtility{

		//waitä÷êî
		public static function wait(count:uint ):void{
			var start:uint = getTimer();
			while(getTimer() - start < count){
			}
		}	
		
		public static function base64encode(data:ByteArray):String {
			const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
			var output:String = "";
			var dataBuffer:Array;
			var outputBuffer:Array = new Array(4);
			data.position = 0;
			
			while (data.bytesAvailable > 0) {
				dataBuffer = new Array();
				for (var i:uint = 0; i < 3 && data.bytesAvailable > 0; i++)
					dataBuffer[i] = data.readUnsignedByte();
				outputBuffer[0] = (dataBuffer[0] & 0xfc) >> 2;
				outputBuffer[1] = ((dataBuffer[0] & 0x03) << 4) | ((dataBuffer[1]) >> 4);
				outputBuffer[2] = ((dataBuffer[1] & 0x0f) << 2) | ((dataBuffer[2]) >> 6);
				outputBuffer[3] = dataBuffer[2] & 0x3f;
				for (var j:uint = dataBuffer.length; j < 3; j++)
					outputBuffer[j + 1] = 64;
				for (var k:uint = 0; k < outputBuffer.length; k++)
					output += BASE64_CHARS.charAt(outputBuffer[k]);
				
			}
			return output;
		}
			
		
	}
}