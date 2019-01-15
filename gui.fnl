(require "gooi")
(local layout (require :layout))

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
  (let [sizes (layout.get "menuButtons")
        controls 
          [(doto (gooi.newButton {:text "Exit"})
             (: :onRelease (fn exit-handler [] (love.event.quit))))
           (gooi.newButton {:text "Layout"})
           (gooi.newButton {:text "Conn"})]]
    ; (local dbg (require "dbg")) (dbg)
    (each [i c (ipairs controls)]
      (let [r (. sizes i)]
        (doto c
          (: :setBounds r.x r.y r.w r.h))))
                          
    (ComponentWrapper.new controls)))

(fn make-sliders [side]
  (var sliders [])
  (let [(width heigth) (window.getMode)]
    (for [i 1 4]
      (let [r (. (layout.get (.. side "Sliders")) i)]
        (tset sliders i
              (doto (gooi.newSlider
                       {:value 0.5
                        :x r.x
                        :y r.y
                        :w r.w
                        :h r.h})
                (: :vertical))))))
  (ComponentWrapper.new sliders))


(fn init []
  (let [w 800 h 600]
    (love.window.setMode w h
       {:resizable true
        :minwidth w
        :minheight h})
    (tset state :menu (make-menu))
    (tset state :l-sliders (make-sliders "left"))
    (tset state :r-sliders (make-sliders "right"))))
      ; (tset state :r-sliders (make-sliders "right"))))
      ; (make-sliders "top")))

{:draw gooi.draw
 :update gooi.update
 :mouse-pressed gooi.pressed
 :mouse-released gooi.released
 :mouse-moved gooi.moved
 :init init}

