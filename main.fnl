(local socket (require :socket))
(local struct (require :struct))

(local suit (require :suit))

(local osc (require :osc))
(local gui (require :gui))

(local rnd love.math.random)

(local ip "127.0.0.1")
(local port 7001)

(fn love.load []
  (gui.init)

  (global udp (socket.udp))
  (: udp :settimeout 0)
  (: udp :setpeername ip port))

(fn love.draw []
  (gui.draw))

(fn love.update [dt]
  (gui.update)
  (: udp :send (osc.float-msg (rnd 1 127))))
