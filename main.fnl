(local socket (require :socket))
(local struct (require :struct))

(local osc (require :osc))
(local gui (require :gui))

(local layout (require :layout))
(layout.recalculate-layout)

(local rnd love.math.random)

(local ip "127.0.0.1")
(local port 7001)

(fn love.load []
  
  (layout.update)
  (gui.init)

  (global udp (socket.udp))
  (: udp :settimeout 0)
  (: udp :setpeername ip port))

(fn love.draw []
  (gui.draw)
  (layout.draw)
  (love.graphics.print (tostring (love.window.getDPIScale) 10 10)))

(fn love.update [dt]
  (gui.update dt)
  (layout.update)
  (: udp :send (osc.float-msg (rnd 1 127))))

(fn love.mousepressed [x y button]
  (gui.mouse-pressed))

(fn love.mousereleased [x y button]
  (gui.mouse-released))

(fn love.touchpressed [id x y]
  (gui.mouse-pressed id x y))

(fn love.touchreleased [id x y]
  (gui.mouse-released id x y))

(fn love.touchmoved [id x y]
  (gui.mouse-moved id x y))
