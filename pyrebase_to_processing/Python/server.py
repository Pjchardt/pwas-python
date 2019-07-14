# Echo server program
import time
import socket
import select
import threading

class Server():
    TCP_IP = '127.0.0.1'
    TCP_PORT = 5005
    has_new_data = False
    data = "should be an url"
    do_running = True

    def do_sockets(self):
        while self.do_running:
            unconnected_list = [self.s]
            connected_list = []
            while self.do_running:
                unConnected, connected, errored = select.select(unconnected_list, connected_list, [])
                for s in unConnected:
                    if s is self.s:
                        client_socket, address = self.s.accept()
                        connected_list.append(client_socket)
                        print ("Connection from", address)
                    else:
                        data = s.recv(1024)
                        if data:
                            print (data)
                for s in connected_list:
                    if self.has_new_data:
                        print("sending data to processing")
                        s.send(str.encode(self.data))
                        self.has_new_data = False

    def __init__(self):
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.setblocking(0)
        self.s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.s.bind((self.TCP_IP, self.TCP_PORT))
        self.s.listen(1)
        print('Starting server')

        self.thread = threading.Thread(target = self.do_sockets)
        #self.thread.deamon = True # use this if your application does not close.
        self.thread.start()
        print('waiting for sockets')

    def new_data(self, data):
        self.data = data
        print("server got new data", self.data)
        self.has_new_data = True

    def stop_server(self):
        self.do_running = False
        #socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect( (self.TCP_IP, self.TCP_PORT))
        try:
            self.s.shutdown(socket.SHUT_RDWR)
            self.s.close()
        except:
            print("failed ot shutdown socket :(")
