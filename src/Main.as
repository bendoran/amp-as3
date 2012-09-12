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
		
		private function ampConnectedHandler( event:AMPEvent ):void {event
			ampClient.ask( 'Sum', {a:10, b:20}, ampClientAnswer, errorHandler );
			ampClient.ask( 'Sum', {a:50, b:10}, ampClientAnswer, errorHandler );
			ampClient.ask( 'Sum', {a:15, b:30}, ampClientAnswer, errorHandler );
			ampClient.ask( 'Sum', {a:10, b:2}, ampClientAnswer, errorHandler );
		}
		
		private function ampClientAnswer( object : Object ) : void{
			trace( "Total:", object.total ); 
		}
		
		private function errorHandler( object : Object ) : void{
			trace( "Error Code:", object._error_code ); 
		}
		
	}
}	