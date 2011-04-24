package swftoru.models{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	import flash.events.*;
	import flash.display.DisplayObjectContainer;
	import flash.system.fscommand;
	import flash.utils.*;
	
	import swftoru.config.*;
	import swftoru.events.*;
	import swftoru.utils.*;

	/**
	 * ImageDataをPostする。
	 */
	public class PostImageData{

		/**
		 * Instance Varibales
		 */
		private var postLoader:URLLoader;
		

		/**
		 * Constructor
		 */
		public function PostImageData(reqUrl:String, postArray:Object){
			if(SwfToruConfig.DEBUG){trace("PostImageData Start");}

			init(reqUrl,postArray);
		}
		
		private function init(reqUrl:String, postArray:Object){
		
			var urlReq:URLRequest;
			var vars:URLVariables;
			
			//Loaderの初期設定
			postLoader = new URLLoader();
			postLoader.dataFormat = URLLoaderDataFormat.TEXT;
			//リスナーの登録
			postLoader.addEventListener(Event.COMPLETE       , postLoadComplete);
			postLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorOccur);
			postLoader.addEventListener(Event.UNLOAD         , unLoadOccur);
	
			urlReq = new URLRequest(reqUrl);
			urlReq.method = URLRequestMethod.POST;
			System.useCodePage = false;


			//Post Dataをセット
			vars = new URLVariables();
			for( var tmp:String in postArray ) {
				vars[tmp] = postArray[tmp];
			}
			urlReq.data = vars;
			
			//Load
			postLoader.load(urlReq);
			
		}
		
			
		//読み込み完了
		private function postLoadComplete(event:Event):void{
			
			try{
				if(SwfToruConfig.DEBUG){trace("postLoadComplete");}
				
				//リスナーの削除
				postLoader.removeEventListener(Event.COMPLETE, postLoadComplete);
				postLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorOccur);
				postLoader.removeEventListener(Event.UNLOAD, unLoadOccur);
				postLoader.data = null;
				postLoader = null;
				

			}catch(err:TypeError){				
				trace(new Error(err.errorID));
				fscommand( "quit" );
			}
			
		}

		private function ioErrorOccur(event:Event):void{
			if(SwfToruConfig.DEBUG){trace("PostImageData ioErrorOccur");}
		}

		private function unLoadOccur(event:Event):void{
			trace("PostImageData unLoad");
		}


	}

}
