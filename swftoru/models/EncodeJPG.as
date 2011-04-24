package swftoru.models{
	import com.adobe.images.*;
	import flash.display.BitmapData;
	import flash.utils.*;

	public class EncodeJPG{
		private var compressRatio:int = 90;
		public function EncodeJPG():void{
		}
		
		public function encode(bmd:BitmapData):ByteArray {
			return new JPGEncoder(compressRatio).encode(bmd);;
		}
	}
}