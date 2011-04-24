package {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.system.Security;
	import flash.events.*;
	import flash.geom.*;

	import swftoru.config.*;
	import swftoru.models.*;
	import swftoru.events.*;
	import swftoru.views.*;
	
	[SWF(scriptTimeLimit=60)]  
	/**
	 * ドキュメントクラス。
	 * 表示リストの最上位に位置する。
	 */
	public class SwfToru extends MovieClip{
				
		/*
		 * Instance Varibales
		 */
		public  var swfToruObjectContainer:DisplayObjectContainer;
		private var requestXml:RequestXml;
		private var swfModel:LoadSwfModel;
		private var postData:PostData;
		
		private var onEnterFrameEvent:EventRequestDone;
		private var requestXmlEvent:EventRequestDone;
		
		private var frameCnt:int=0;
		private var bmdArray:Array = new Array();
		
		
		/**
		 * Constructor
		 */
		public function SwfToru(){
			//TODO Security
			flash.system.Security.allowDomain("*");
			init();
		}


		/**
		 * init関数
		 */
		private function init():void{
			if(SwfToruConfig.DEBUG){ trace("Init Start");trace(new Date()); }
			//初期化
			frameCnt = 0;
			
			swfToruObjectContainer  = this.root as DisplayObjectContainer;

			//Xmlの読み込み終了時のイベント登録
			requestXmlEvent = new EventRequestDone(swfToruObjectContainer);
			requestXmlEvent.addEventListener(EventRequestDone.DONE,xmlRequestDone);
			
			//XMLを取得
			requestXml = new swftoru.models.RequestXml(SwfToruConfig.getXmlDataUrl,requestXmlEvent);
			
			if(SwfToruConfig.DEBUG){ trace("Init End");trace(new Date()); }
		}
		
		/**
		 * XML読み込み完了
		 */
		private function xmlRequestDone(event:Event):void{
			if(SwfToruConfig.DEBUG){ trace("xmlRequestDone");trace(requestXml.getRetXml());}
			//リスナーの削除
			requestXmlEvent.removeEventListener(EventRequestDone.DONE,xmlRequestDone);
			
			//xml -> PostData Objectの変換
			var xml:XML = requestXml.getRetXml();
			postData = new PostData();
			postData.setUserId(Number(xml.@user_id));
			postData.setFormat(String(xml.format));
			postData.setQueueId(Number(xml.queueId));
			if( (xml.child('startFrame').length() !=0 ) && (xml.child('endFrame').length() !=0) ){
				postData.setStartFrame(Number(xml.startFrame));
				postData.setEndFrame(Number(xml.endFrame));
			} else {
				postData.setStartFrame(2);
				postData.setEndFrame(2);
			}
			
			
			//Swfの読み込み後、フレームが再生された時のイベント登録
			onEnterFrameEvent = new EventRequestDone(swfToruObjectContainer);
			onEnterFrameEvent.addEventListener(EventRequestDone.DONE, captureSwf);
			
			swfModel = new LoadSwfModel(requestXml.getSwfGetUrl(), swfToruObjectContainer,onEnterFrameEvent );
			
			
		}
		
		private function nextXML(event:Event):void{
			if(SwfToruConfig.DEBUG){ trace("nextXML Start");trace(event); }
			//リスナーの削除
			onEnterFrameEvent.removeEventListener(EventRequestDone.DONE, captureSwf);
			//ロードしたSWFの削除
			swfToruObjectContainer.removeChildAt(0);
			//onEnterFrameListenerの削除
			swfModel.removeOnEnterFrameListener();
			
			//次のXMLへ
			init();
			
		}
		
		/**
		 * Caputure
		 */
		private function captureSwf(event:Event):void{
			if(SwfToruConfig.DEBUG){ trace("captureSwf Start"); }
			
			frameCnt++;

			if(SwfToruConfig.DEBUG){ trace("captureSwf:frameCnt" + frameCnt + ">=" + postData.getStartFrame() );}
			if(SwfToruConfig.DEBUG){ trace("captureSwf:frameCnt" + frameCnt + "<=" + postData.getEndFrame() );}

			
			if( (frameCnt >= postData.getStartFrame() ) && frameCnt <= postData.getEndFrame())  {
				//下記はキャプチャーサイズに合わせて作成ください
				var bmd:BitmapData=new BitmapData(SwfToruConfig.imageSizeX, SwfToruConfig.imageSizeY, true,0xFFFFFF);
				var matrix:Matrix = new Matrix(
					SwfToruConfig.matrixA,
					SwfToruConfig.matrixB,
					SwfToruConfig.matrixC,
					SwfToruConfig.matrixD,
					SwfToruConfig.matrixTx,
					SwfToruConfig.matrixTy
				);

				bmd.draw(swfToruObjectContainer, matrix);
				var retCapImage = new CaptureImage(bmd,(frameCnt - postData.getStartFrame() + 1),postData);
			}
			
			//終了処理
			if(frameCnt > postData.getEndFrame()) {
				nextXML(event);
			}
		}

		
		
	}


}
