package{
	import co.uk.bdoran.AMP.AMP;
	import co.uk.bdoran.AMP.AMPEvent;
	import co.uk.bdoran.AMP.AmpCommand;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class AmpTest extends Sprite{
		
		private var amp:AMP;
		
		public function AmpTest(){
			amp = new AMP( "127.0.0.1", 6000 );
			amp.addEventListener( AMPEvent.AMP_CONNECTED, ampConnectedHandler ) 
		}
		
		private function ampConnectedHandler( event:AMPEvent ):void {
			amp.callRemote( Sum, {a:10, b:20}, ampClientAnswer, errorHandler );
			amp.callRemote( Sum, {a:50, b:10}, ampClientAnswer, errorHandler );
			amp.callRemote( Sum, {a:15, b:30}, ampClientAnswer, errorHandler );
			amp.callRemote( Sum, {a:10, b:2}, ampClientAnswer, errorHandler );
		}
		
		private function ampClientAnswer( object : Object ) : void{
			trace( "Total:", object.total ); 
		}
		
		private function errorHandler( object : Object ) : void{
			trace( "Error Code:", object._error_code ); 
		}
	}
	
}	