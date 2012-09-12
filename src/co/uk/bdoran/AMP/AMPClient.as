package co.uk.bdoran.AMP {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.Dictionary;

	public class AMPClient extends EventDispatcher{
		
		private var server : String;
		private var port : int;
		private var socket : Socket;
		private var questionCounter : int = 0;

		private var currentMessage : String;
		
		private var questionCallbacks : Dictionary;
		private var errorCallbacks : Dictionary;
		
		public function AMPClient( server : String, port : int ) {
			this.questionCallbacks = new Dictionary();
			this.errorCallbacks = new Dictionary();
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
		
		public function ask( command : String, args : Object, callBack : Function = null, errorBack : Function = null ) : void{
			
			var data : String = "";
			var argsArray : Array = this.objectToArray( args );

			argsArray.push( { key : "_command", value : command } );
			
			if( callBack != null ){
				this.questionCounter++;
				this.questionCallbacks[ this.questionCounter ] = callBack;
				this.errorCallbacks[ this.questionCounter ] = errorBack;
				argsArray.push( { key : "_ask", value : questionCounter } );
			}
			
			for each(  var object : Object in argsArray ){
				socket.writeUTF( object.key );
				socket.writeUTF( object.value );
			}
			socket.writeByte(0x00);
			socket.writeByte(0x00);
			socket.flush();
		}
		
		public function call( command : String, args : Object ) : void{
			this.ask( command, args, null );
		}
		
		private function objectToArray( args : Object ) : Array{
			var returnArray : Array = [];
			for( var key : String in args ){
				returnArray.push( { key : key, value : args[ key ] } );
			}
			return returnArray;
		}
		
		private function socketConnectHandler(event : Event) : void {
			this.dispatchEvent( new AMPEvent( AMPEvent.AMP_CONNECTED, this ) );
		}

		private function socketCloseHandler(event : Event) : void {
			this.dispatchEvent( new AMPEvent( AMPEvent.AMP_DISCONNECTED, this ) );
			socket.close();
		}

		private function socketErrorHandler(event : IOErrorEvent) : void {
			this.dispatchEvent( new AMPEvent( AMPEvent.AMP_SOCKET_ERROR, this ) );
		}
		
		
		protected function socketSecurityErrorHandler(event:SecurityErrorEvent):void{
			this.dispatchEvent( new AMPEvent( AMPEvent.AMP_SECURITY_SOCKET_ERROR, this ) );
		}

		private function socketDataHandler(event : ProgressEvent) : void {
			var responseItems : Dictionary = new Dictionary();
			var key : String = null;
			
			while ( socket.bytesAvailable > 0 ){
				var message : String = socket.readUTF();
				if( message == "" ){
					processAnswer( responseItems );
					responseItems = new Dictionary();
				}
				if( !key ){
					key = message;
				}else{
					responseItems[key] = message;
					key = null;
				}
			}
		}
		
		private function processAnswer( responseItems : Dictionary ) : void{

			if( responseItems["_answer"] ){
				var questionID : String = responseItems["_answer"];
				delete( responseItems["_answer"] );
				if( questionCallbacks[ questionID ] ){
					var args : Object = new Object();
					for( var aKey : String in responseItems ){
						args[ aKey ] = responseItems[ aKey ];					
					}
					var callBack : Function = questionCallbacks[ questionID ] as Function; 
					callBack.call( this, args );
					delete( questionCallbacks[ questionID ] );
				}
				if( errorCallbacks[ questionID ] ){
					delete( errorCallbacks[ questionID ] );
				}
			}
			
			if( responseItems["_error"] ){
				var errorID : String = responseItems["_error"];
				delete( responseItems["_error"] );
				if( errorCallbacks[ errorID ] ){
					var errorArgs : Object = new Object();
					for( var eKey : String in responseItems ){
						errorArgs[ eKey ] = responseItems[ eKey ];					
					}
					var errorBack : Function = errorCallbacks[ errorID ] as Function; 
					errorBack.call( this, errorArgs );
					delete( errorCallbacks[ errorID ] );
				}
				if( questionCallbacks[ errorID ] ){
					delete( questionCallbacks[ errorID ] );
				}
			}
		}
	}	
}
