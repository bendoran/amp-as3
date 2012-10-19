package{
	import co.uk.bdoran.AMP.AMP;
	import co.uk.bdoran.AMP.AMPEvent;
	import co.uk.bdoran.AMP.AmpCommand;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SumTest extends Sprite{
		
		private var amp:AMP;
		
		public function SumTest(){
			amp = new AMP( "127.0.0.1", 6000 );
			amp.addEventListener( AMPEvent.AMP_CONNECTED, ampConnectedHandler )
			amp.addEventListener( AMPEvent.AMP_SOCKET_ERROR, ampSocketErrorHandler );
			amp.connect();
		}
		
		private function ampConnectedHandler( event:AMPEvent ):void {
			amp.callRemote( Sum, {a:10, b:20}, ampClientAnswer, errorHandler );
			amp.callRemote( Sum, {a:50, b:10}, ampClientAnswer, errorHandler );
			amp.callRemote( Sum, {a:15, b:30}, ampClientAnswer, errorHandler );
			amp.callRemote( Sum, {a:10, b:2}, ampClientAnswer, errorHandler );
		}
		
		protected function ampSocketErrorHandler( event:AMPEvent ):void{
			trace( "Error connecting to socket" );
		}
		
		private function ampClientAnswer( object : Object ) : void{
			trace( "Total:", object.total ); 
		}
		
		private function errorHandler( object : Object ) : void{
			trace( "Error Code:", object._error_code ); 
		}
	}
}

import co.uk.bdoran.AMP.AmpCommand;

class Sum extends AmpCommand{
	public function Sum(){
		this.args = { a : AMP_INTEGER, b : AMP_INTEGER };
		this.response = { total : AMP_INTEGER };
	}
}