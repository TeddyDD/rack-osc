(local socket (require :socket))
(local struct (require :struct))

(local osc (require :osc))

(local rnd love.math.random)

(local ip "127.0.0.1")
(local port 7001)

(fn love.load []
  (global udp (socket.udp))
  (: udp :settimeout 0)
  (: udp :setpeername ip port))
  ; (let
  ;   [(ok err) (: udp :send (msg))]
  ;   (print (.. "status" (tostring ok)))))

(fn love.draw []
  (love.graphics.print "Hello Wordl", 400, 300))

(fn love.update [dt]
  (: udp :send (osc.float-msg (rnd 1 127))))

