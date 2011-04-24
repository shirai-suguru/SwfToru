package swftoru.models{
	
	public class PostData {
		
		private var userId:int;
		private var queueId:int;
		private var frame:int;
		private var startFrame:int;
		private var endFrame:int;
		private var format:String;
		private var binData:String;
		
		public function PostData():void{
		}
		
		public function getUserId():int {
			return userId;
		}
		
		public function getQueueId():int {
			return queueId;
		}
		
		public function getStartFrame():int {
			return startFrame;
		}
		
		public function getEndFrame():int{
			return endFrame;
		}
		
		public function getFormat():String{
			return format;
		}
		
		public function getBinData():String{
			return binData;
		}
		
		public function setUserId(t_userId:int):void{
			userId = t_userId;
		}
		
		public function setQueueId(t_queueId:int):void{
			queueId = t_queueId;
		}
		
		public function setStartFrame(t_startFrame:int):void{
			startFrame = t_startFrame;
		}
		
		public function setEndFrame(t_endFrame:int):void{
			endFrame = t_endFrame;
		}
		
		public function setFormat(t_format:String):void{
			format = t_format;
		}
		
		public function setBinData(t_binData:String):void{
			binData = t_binData;
		}
		
	}
}