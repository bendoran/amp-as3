package co.uk.bdoran.AMP {
	import flash.events.Event;

	public class AMPEvent extends Event{
		
		public static const AMP_CONNECTED : String = "ampConnected";
		public static const AMP_DISCONNECTED : String = "ampDisconnected";
		public static const AMP_SOCKET_ERROR : String = "ampSocketError";
		public static const AMP_SECURITY_SOCKET_ERROR : String = "ampSecuritySocketError";
		
		public var ampClient:AMP;
		
		public function AMPEvent( eventType : String, ampClient : AMP, bubbles : Boolean = false, cancelable : Boolean = false ){
			this.ampClient = ampClient;
			super( eventType, bubbles, cancelable );
		}
		
	}
}
