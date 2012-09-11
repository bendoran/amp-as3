package co.uk.bdoran.AMP {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class AMPClient extends EventDispatcher{
		
		private var server : String;
		private var port : int;
		private var socket : Socket;
		private var questionCounter : int = 0;
		
		public function AMPClient( server : String, port : int ) {
			this.server = server;
			this.port = port;
			this.connect();
		}
		
		public function connect( ) : void{
			this.socket = new Socket( );
			this.socket.connect(  this.server, this.port  );
			this.socket.addEventListener( Event.CONNECT, socketConnectHandler  );
			this.socket.addEventListener( Event.CLOSE, socketCloseHandler );
			this.socket.addEventListener( IOErrorEvent.IO_ERROR, socketErrorHandler );
			this.socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, socketSecurityErrorHandler);
			this.socket.addEventListener( ProgressEvent.SOCKET_DATA, socketDataHandler );
		}
		
		public function ask( command : String, args : Object ) : void{
			this.questionCounter++;
			
			var data : String = "";
			var argsArray : Array = this.objectToArray( args );

			argsArray.unshift( { key : "_command", value : command } );
			argsArray.unshift( { key : "_ask", value : questionCounter } );
			
			for each(  var object : Object in argsArray ){
				data += object.key.length;
				data += object.key;
				data += object.value.toString().length;
				data += object.value;
			}
			
			var utfBytes : ByteArray = new ByteArray();
			utfBytes.writeUTFBytes( data );
			utfBytes.position = 0;
			
			while ( utfBytes.bytesAvailable ) {
				this.socket.writeByte( utfBytes.readByte() );
			}
			this.socket.writeShort( 0x00 );
		}
		
		private function objectToArray( args : Object ) : Array{
			var returnArray : Array = [];
			for( var key : String in args ){
				returnArray.push( { key : key, value : args[ key ] } );
			}
			return returnArray;
		}
		
		private function socketConnectHandler(event : Event) : void {
			trace("Socket Open");
			this.dispatchEvent( new AMPEvent( AMPEvent.AMP_CONNECTED, this ) );
		}

		private function socketCloseHandler(event : Event) : void {
			trace("Socket Close: " + event);
			socket.close();
		}

		private function socketErrorHandler(event : IOErrorEvent) : void {
			trace("IOErrorEvent Error: " + event);
		}
		
		
		protected function socketSecurityErrorHandler(event:SecurityErrorEvent):void{
			trace("SecurityErrorEvent Error: " + event);
		}

		private function socketDataHandler (event : ProgressEvent) : void {
			if ( socket.bytesAvailable > 0 ){
				trace("IN: " + socket.readUTFBytes( socket.bytesAvailable ) );
			}
		}
	}
}
