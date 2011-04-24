package swftoru.views {
	import com.adobe.images.*;
	import flash.display.BitmapData;
	import flash.utils.*;

	import swftoru.config.*;
	import swftoru.models.*;
	import swftoru.utils.*;
	
	public class CaptureImage {
		
		//getDefinitionByNamep
		private var pngencode:EncodePNG;
		private var jpgencode:EncodeJPG;
		
		public function CaptureImage(bmd:BitmapData,frameCnt:int,getPostData:PostData):void{
			init(bmd,frameCnt,getPostData);
		}
		
		private function init(bmd:BitmapData,frameCnt:int,getPostData:PostData):void{
			if(SwfToruConfig.DEBUG){ trace("CaptureImage Start"); }
			
			var resultImage:ByteArray;
			
			try{
				if(SwfToruConfig.DEBUG){ trace("CaptureImage try"); }
				var ClassReference:Class = getDefinitionByName('swftoru.models.Encode' + getPostData.getFormat() ) as Class;
				if(SwfToruConfig.DEBUG){ trace(ClassReference); }
				var encodeClass:Object   = new ClassReference();
				resultImage              = encodeClass.encode(bmd);
			} catch(e:ReferenceError) {
				if(SwfToruConfig.DEBUG){ trace("CaptureImage catch"); }
                trace(e);
				var ClassReferenceDefault:Class = getDefinitionByName('swftoru.models.EncodePNG') as Class;
				var encodeClassDefault:Object   = new ClassReferenceDefault();
				resultImage                     = encodeClassDefault.encode(bmd);
            }

			
			var postData:Object = new Object();
			
			postData['user_id']   = getPostData.getUserId();
			postData['queue_id']  = getPostData.getQueueId();
			postData['frame']     = frameCnt;
			postData['bincode']   = swftoru.utils.BaseUtility.base64encode(resultImage);
			var retPostImage = new PostImageData(SwfToruConfig.putImageDataUrl,postData);

			if(SwfToruConfig.DEBUG){ trace("CaptureImage frame:" + frameCnt ); }
		}
	}
}