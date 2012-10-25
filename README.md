#AMP AS3

##Simple Example

Create a command

```actionscript
import co.uk.bdoran.AMP.AmpCommand;

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

Call the remote server

```actionscript
amp.callRemote( Hello, { message : MESSAGE } );
```

Respond to the remote server

```actionscript
	amp.setResponder( Hello, helloHandler );				
```
