package com.davikingcode.nativeExtensions.zbar {

	import flash.events.Event;

	public class ZBarEvent extends Event {

		static public const SCAN:String = "SCAN";

		private var _data:String;

		public function ZBarEvent(type:String, data:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super( type, bubbles, cancelable );

			_data = data;
		}

		public function get data():String {
			return _data;
		}
	}
}
