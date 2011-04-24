package swftoru.models{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.display.*;

	import swftoru.config.*;
	import swftoru.events.*;

	public class LoadSwfModel {
	
		private var xmlAttrArray:Array;
		private var swfLoader:Loader;
		private var swfObjectCountainer:DisplayObjectContainer;
		private var eventDone:EventRequestDone;
		
		private var avm1m:AVM1Movie;
	
		public function LoadSwfModel(swfGetUrl:String ,swfToruObjectContainer:DisplayObjectContainer ,onEnterFrameEvent:EventRequestDone){
			swfObjectCountainer = swfToruObjectContainer;
			eventDone = onEnterFrameEvent;
			init(swfGetUrl);
		}
		
		public function getXmlAttrArray():Array {
			return xmlAttrArray;
		}
		
		private function init(swfGetUrl:String):void {
			if(SwfToruConfig.DEBUG){ trace("LoadSwfView Start");trace(swfGetUrl); }
		
			var swfRequest:URLRequest = new URLRequest(swfGetUrl);
			
			swfLoader = new Loader(); 
			
			//リスナーの登録
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoadComplete);
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorOccur);
			swfLoader.contentLoaderInfo.addEventListener(Event.UNLOAD, unLoadOccur);
			
			//Request
			swfLoader.load(swfRequest);
		}
		
		private function swfLoadComplete(event:Event):void{
			if(SwfToruConfig.DEBUG){ trace("swfLoadComplete"); }
			swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoadComplete);
			swfLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorOccur);
			swfLoader.contentLoaderInfo.removeEventListener(Event.UNLOAD, unLoadOccur);

			//コンテナーにロードしたSWFを一番下に追加
			swfObjectCountainer.addChildAt(swfLoader,0);
			
			avm1m = swfLoader.content as AVM1Movie;
			avm1m.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
		}
		
		private function onEnterFrame(event:Event):void{
			if(SwfToruConfig.DEBUG){ trace("onEnterFrame"); }
			
			eventDone.requestDone();
		}
		
		private function ioErrorOccur(event:Event):void{
			trace('IO error Occur in LoadSwfModel');
		}

		private function unLoadOccur(event:Event):void{
			if(SwfToruConfig.DEBUG){ trace("unLoadOccur in LoadSwfModel"); }
		}
		
		public function removeOnEnterFrameListener():void{
			avm1m.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
	}
}