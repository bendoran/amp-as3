#AMP AS3

AMP AS3 is a pure ActionScript 3 implementation of AMP (Asynchronous Messaging Protocol) a lightweight typed messaging protocol for asynchronouse 2 way communication between server and client.

More info on AMP can be found at: 

[http://amp-protocol.net/](http://amp-protocol.net/)

##Simple Example

Create a command

```actionscript
class Hello extends AmpCommand{
	public function Hello(){
		this.args = { message : AMP_STRING };
		this.response = { success : AMP_BOOLEAN };
	}
}
```

Create the AMP server and add a connected handler, for the socket.

```actionscript
amp = new AMP( "127.0.0.1", 6000 );
amp.addEventListener( AMPEvent.AMP_CONNECTED, ampConnectedHandler );
amp.connect();
```

Call the remote server with the Command

```actionscript
amp.callRemote( Hello, { message : "Hello World" } );
```

Respond to the remote server calling the command

```actionscript
amp.setResponder( Hello, helloHandler );		

function helloHandler( object : Object ){
	trace("Message Recieved:", object.message );
}		
```

##Future Changes

 * Strict object typing and AMP compliant error messaging
 * Implement AMP 'Box Object'
 * Pure AS3 server implementation (create server open socket etc)
