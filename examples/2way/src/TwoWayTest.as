package
{
	import co.uk.bdoran.AMP.AMP;
	import co.uk.bdoran.AMP.AMPEvent;
	import co.uk.bdoran.AMP.AmpCommand;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TwoWayTest extends Sprite
	{
		private var amp : AMP;
		
		private static const MESSAGE : String = "Hello Server";
		
		public function TwoWayTest(){
			amp = new AMP( "127.0.0.1", 6000 );
			amp.addEventListener( AMPEvent.AMP_CONNECTED, ampConnectedHandler );
			amp.connect();
		}
		
		protected function ampConnectedHandler(event:AMPEvent):void{
			//Set the Responder for the remote call
			amp.setResponder( HelloBack, helloBackHandler );
			
			//Call the server
			trace( "Calling Server with Message:", MESSAGE );
			amp.callRemote( Hello, { message : MESSAGE } );
		}
		
		private function helloBackHandler( object : Object ) : void{
			trace( "Recieved HelloBack Call from Server:", object.message );
		}
	}
	
}

import co.uk.bdoran.AMP.AmpCommand;

class Hello extends AmpCommand{
	public function Hello(){
		this.args = { message : AMP_STRING };
		this.response = { success : AMP_BOOLEAN };
	}
}

class HelloBack extends AmpCommand{
	public function HelloBack(){
		this.args = { message : AMP_STRING };
		this.response = { success : AMP_BOOLEAN };
	}
}