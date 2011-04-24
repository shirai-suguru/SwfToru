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
	 * 指定されたXMLを取得する。
	 */
	public class RequestXml{

		/**
		 * Instance Varibales
		 */
		private var xmlLoader:URLLoader;
		private var strReqUrl:String;
		private var retryMsec:int       = 1000;
		private var retXml:XML;
		private var eventDone:EventRequestDone;
		
//		private var v_key:String;
//		private var v_thisUrl:String;
//		private var v_thisCode:Boolean;

		/**
		 * Constructor
		 */
		public function RequestXml(reqUrl:String,requestEvent:EventRequestDone){
			if(SwfToruConfig.DEBUG){trace("RequestXml Start");trace(new Date());}

			strReqUrl = reqUrl;
			eventDone = requestEvent;
			init(reqUrl);

			if(SwfToruConfig.DEBUG){trace("RequestXml End");trace(new Date());}
		}
		
		private function init(reqUrl:String){
		
			var urlReq:URLRequest;
			var urlArray:Array;
			var queryArray:Array;
			
			//Loaderの初期設定
			xmlLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			//リスナーの登録
			xmlLoader.addEventListener(Event.COMPLETE       , xmlLoadComplete);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorOccur);
			xmlLoader.addEventListener(Event.UNLOAD         , unLoadOccur);
			
			urlArray = reqUrl.split('?');
			
			if(SwfToruConfig.DEBUG){trace("RequestXml urlArray");trace(urlArray);}
			//
			urlReq = new URLRequest(urlArray[0]);
			urlReq.method = URLRequestMethod.POST;
			System.useCodePage = false;
			
			//QueryStringがある場合
			if(urlArray.length > 1 ){
				urlReq.data = getUrlVariables( urlArray[1].split('&') );
			}
			//Load
			xmlLoader.load(urlReq);
			
		}
		
		private function getUrlVariables(queryArray:Array):URLVariables {
			var urlVariable = new URLVariables();
			
			if(SwfToruConfig.DEBUG){trace("RequestXml queryArray");trace(queryArray);}

			for(var i:int=0; i<queryArray.length; i++) {
				var queryData:Array = queryArray[i].split('=');
				urlVariable[queryData[0]] = queryData[1];
			}
			return urlVariable;
		}

			

		//読み込み完了
		private function xmlLoadComplete(event:Event):void{
			
			try{
				retXml = new XML(xmlLoader.data);

				if(SwfToruConfig.DEBUG){trace("xmlLoadComplete");trace(retXml);}
				
				//リスナーの削除
				xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete);
				xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorOccur);
				xmlLoader.removeEventListener(Event.UNLOAD, unLoadOccur);
				xmlLoader.data = null;
				xmlLoader = null;
				
				//ロード完了の通知
				eventDone.requestDone();

			}catch(err:TypeError){				
				trace(new Error(err.errorID));
				fscommand( "quit" );
			}
			
		}

		private function ioErrorOccur(event:Event):void{
			//404が返ってくるとここに入る
			if(SwfToruConfig.DEBUG){trace("ioErrorOccur");}

			//再実行
			BaseUtility.wait(retryMsec);
			init(strReqUrl);
		}

		private function unLoadOccur(event:Event):void{
			trace("RequestXml unLoad");
		}


		public function getRetXml():XML {
			return retXml;
		}

		public function getSwfGetUrl():String {
			return String(retXml.url);
		}

	}

}
