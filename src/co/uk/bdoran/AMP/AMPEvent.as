package co.uk.bdoran.AMP {
	import flash.events.Event;

	public class AMPEvent extends Event{
		
		public static const AMP_CONNECTED : String = "ampConnected";
		
		public var ampClient:AMPClient;
		
		public function AMPEvent( eventType : String, ampClient : AMPClient, bubbles : Boolean = false, cancelable : Boolean = false ){
			this.ampClient = ampClient;
			super( eventType, bubbles, cancelable );
		}
		
	}
}
