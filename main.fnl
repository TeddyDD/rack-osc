(local socket (require :socket))
(local struct (require :struct))

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
  (gui.update dt)
  (: udp :send (osc.float-msg (rnd 1 127))))

(fn love.mousepressed [x y button]
  (gui.mouse-pressed))

(fn love.mousereleased[x y button]
  (gui.mouse-released))

