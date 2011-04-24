package swftoru.models{
	import com.adobe.images.*;
	import flash.display.BitmapData;
	import flash.utils.*;

	public class EncodePNG{
		public function EncodePNG():void{
		}
		
		public function encode(bmd:BitmapData):ByteArray {
			return PNGEncoder.encode(bmd);
		}
	}
}