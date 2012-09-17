package co.uk.bdoran.AMP {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.Dictionary;

	public class AMP extends EventDispatcher{
		
		private var server : String;
		private var port : int;
		private var socket : Socket;
		private var questionCounter : int = 0;

		private var currentMessage : String;
		
		private var questionCallbacks : Dictionary;
		private var errorCallbacks : Dictionary;
		
		private var commandResponders : Dictionary;
		
		public function AMP( server : String, port : int ) {
			this.questionCallbacks = new Dictionary();
			this.errorCallbacks = new Dictionary();
			this.commandResponders = new Dictionary();
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
		
		public function callRemote( commandClass : Class, args : Object, callBack : Function = null, errorBack : Function = null ) : void{
			
			var command : AmpCommand = new commandClass();
			
			//TODO - Check parameter mapping and map the params properly
			
			var data : String = "";
			var argsArray : Array = this.objectToArray( args );

			argsArray.push( { key : "_command", value : command.getCommandName() } );
			
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
		
		public function setResponder( commandClass : Class, responder : Function ) : void {
			var command : AmpCommand = new commandClass();
			commandResponders[ command.getCommandName() ] = { command : commandClass, responder : responder }; 
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
		
		private function socketSecurityErrorHandler(event:SecurityErrorEvent):void{
			this.dispatchEvent( new AMPEvent( AMPEvent.AMP_SECURITY_SOCKET_ERROR, this ) );
		}

		private function socketDataHandler(event : ProgressEvent) : void {
			var responseItems : Dictionary = new Dictionary();
			var key : String = null;
			
			while ( socket.bytesAvailable > 0 ){
				var message : String = socket.readUTF();
				if( message == "" ){
					processBox( responseItems );
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
		
		private function processBox( responseItems : Dictionary ) : void{
			
			for( var key : String in responseItems ){
				trace( "Key:", key, "Value:", responseItems[key] );					
			}

			if( responseItems["_answer"] ){
				processAnswer( responseItems );
			}
			
			if( responseItems["_command"] ){
				processCommand( responseItems );
			}
			
			if( responseItems["_error"] ){
				processError( responseItems );
			}
		}
		
		private function processAnswer( responseItems : Dictionary ) : void {
			var questionID : String = responseItems["_answer"];
			delete( responseItems["_answer"] );
			if( questionCallbacks[ questionID ] ){
				//TODO - Map params to names based on command
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
		
		private function processError( responseItems : Dictionary ) : void{
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
		
		private function processCommand( responseItems : Dictionary ) : void{
			var commandName : String = responseItems["_command"];
			delete( responseItems["_command"] );

			var args : Object = new Object();
			for( var aKey : String in responseItems ){
				args[ aKey ] = responseItems[ aKey ];					
			}
			for( var command : String in this.commandResponders ){
				if( command == commandName ){
					var responder : Function = commandResponders[ command ].responder as Function;
					responder.call( this, args );
				}
			}
		}
	}	
}
