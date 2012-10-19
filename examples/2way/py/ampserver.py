from twisted.protocols import amp

class Hello( amp.Command ):
    requiresAnswer = False
    arguments = [('message', amp.String())]
    response = [('success', amp.Boolean())]

class HelloBack(amp.Command):
    requiresAnswer = False
    arguments = [('message', amp.String())]
    response = [('success', amp.Float())]


class TwoWay(amp.AMP):
    
    def hello(self, message ):
        self.callRemote( HelloBack, message="You said: %s" % message )
        return {'success': True}
    Hello.responder(hello)

    def dataReceived(self, data):
        print data;
        return amp.AMP.dataReceived(self, data)
    
    def failAllOutgoing(self, reason):
        print reason
        amp.AMP.failAllOutgoing(self, reason)

def main():
    from twisted.internet import reactor
    from twisted.internet.protocol import Factory
    pf = Factory()
    pf.protocol = TwoWay
    reactor.listenTCP(6000, pf)
    print 'started'
    reactor.run()

if __name__ == '__main__':
    main()
