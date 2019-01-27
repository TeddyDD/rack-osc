(local socket (require :socket))
(local struct (require :struct))

(local osc (require :osc))
(local gui (require :gui))

(local layout (require :layout))
(layout.recalculate-layout)

(local rnd love.math.random)

(local state
  {:ip "127.0.0.1"
   :port 7001
   :channels []})

(fn love.load []
  (layout.update)
  (gui.init)

  (global udp (socket.udp))
  (: udp :settimeout 0)
  (: udp :setpeername state.ip state.port))

(fn love.draw []
  (gui.draw)
  (love.graphics.print (tostring (love.window.getDPIScale) 10 10)))

(fn love.update [dt]
  (gui.update dt)
  (layout.update))

(fn lerp [a b t]
  (+ (* (- 1 t) a) (* t b)))

(fn love.handlers.valueChanged [channel value]
  (: udp :send (osc.float-msg (lerp 0 127 value) channel)))
(fn love.keypressed [key]
  (when (= key "escape")
    (love.event.quit)))

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
