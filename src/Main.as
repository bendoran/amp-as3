package{
	import co.uk.bdoran.AMP.AMPClient;
	import co.uk.bdoran.AMP.AMPEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main extends Sprite{
		
		private var ampClient:AMPClient;
		
		public function Main(){
			ampClient = new AMPClient( "127.0.0.1", 6000 );
			ampClient.addEventListener( AMPEvent.AMP_CONNECTED, ampConnectedHandler ) 
		}
		
		protected function ampConnectedHandler( event:AMPEvent ):void {event
			ampClient.ask('Sum',{a:10,b:20});
			ampClient.ask('Sum',{a:30,b:70});
			ampClient.ask('Sum',{a:15,b:30});
			ampClient.ask('Sum',{a:22,b:80});
		}
		
	}
}	