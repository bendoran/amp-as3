from twisted.protocols import amp

class Sum(amp.Command):
    arguments = [('a', amp.Integer()),
                 ('b', amp.Integer())]
    response = [('total', amp.Integer())]


class Divide(amp.Command):
    arguments = [('numerator', amp.Integer()),
                 ('denominator', amp.Integer())]
    response = [('result', amp.Float())]
    errors = {ZeroDivisionError: 'ZERO_DIVISION'}


class Math(amp.AMP):
    def sum(self, a, b):
        total = a + b
        print 'Did a sum: %d + %d = %d' % (a, b, total)
        return {'total': total}
    Sum.responder(sum)

    def divide(self, numerator, denominator):
        result = float(numerator) / denominator
        print 'Divided: %d / %d = %f' % (numerator, denominator, result)
        return {'result': result}
    Divide.responder(divide)
    
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
    pf.protocol = Math
    reactor.listenTCP(6000, pf)
    print 'started'
    reactor.run()

if __name__ == '__main__':
    main()
