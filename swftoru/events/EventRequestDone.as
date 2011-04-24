package swftoru.events{
	import flash.events.*;
	import flash.display.*;
	
	public class EventRequestDone extends EventDispatcher {
		public static const DONE:String   = "requestDone";
		
		/**
		 * Contructor
		 */
		public function EventRequestDone(object) {
			init();
		}
		
		private function init():void {
		}
		
		public function requestDone():void{
			eventDispatch();
		}
		
		private function eventDispatch():void {
			dispatchEvent(new Event(DONE));
		}
	}
}


