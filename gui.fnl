(require "gooi")
(local dbg (require "dbg"))
(local window love.window)

(let [style {:font (love.graphics.newFont "/font/Inter-UI-Regular.ttf" 12)}]
  (gooi.setStyle style))

(local state
  {:mode "osccv" ; ... gridseq, voltseq
   :menu {}})

; I got issues with panels so I wrote this simple wrapper to show and hide
; controls

(local ComponentWrapper {})
(tset ComponentWrapper "__index" ComponentWrapper)

(lambda ComponentWrapper.new [controls]
  (let [self (setmetatable {} ComponentWrapper)]
    (tset self :controls controls)
    self))

(lambda ComponentWrapper.set_visible [self visible]
  (each [_ c (ipairs (. self :controls))]
    (doto c
      (: :setVisible visible)
      (: :setEnabled visible))))

(fn make-menu []
  (let [x 10
        w 100
        y 5
        controls 
          [(doto (gooi.newButton {:text "Exit"})
             (: :onRelease (fn exit-handler [] (love.event.quit))))
           (gooi.newButton {:text "Layout"})
           (gooi.newButton {:text "Conn"})]]
    (each [i c (ipairs controls)]
      (doto c
        (: :setBounds   (* (+ w x)  (- i 1))
                        y w 40)))
    (ComponentWrapper.new controls)))

(fn make-slider []
  (doto (gooi.newSlider
           {:value 0.5
            :h 400 :w 50})
    (: :vertical)))

; side - "top" "bottom"
(fn make-sliders [side]
  (make-slider)
  (make-slider)
  (make-slider)
  (make-slider))

(fn init []
  (let [w 800 h 600]
    (love.window.setMode w h
       {:resizable true
        :minwidth w
        :minheight h})
    (tset state :menu (make-menu))))
    ; (make-sliders "top")))

{:draw gooi.draw
 :update gooi.update
 :mouse-pressed gooi.pressed
 :mouse-released gooi.released
 :init init}

