(require "gooi")
; (local dbg (require "dbg"))
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

(fn size-from-pixels []
  (let [(width heigth) (window.getMode)]
    (values (window.toPixels width)
            (window.toPixels heigth))))

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

(fn make-sliders [side]
  (var sliders [])
  (let [(width heigth) (size-from-pixels)
        margin 10
        origin (if (= side "left") 0 (+ (/ width 2) margin))
        y 50
        w (- (/ width 2 5) (/ margin 2 5))
        h (- heigth y margin)]
    (for [i 1 4]
      (tset sliders i 
            (doto (gooi.newSlider
                     {:value 0.5
                      :x (+ origin (* (- i 1) (+ w margin)))
                      :y y 
                      :h h 
                      :w w})
              (: :vertical)))))
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
    ; (make-sliders "top")))

{:draw gooi.draw
 :update gooi.update
 :mouse-pressed gooi.pressed
 :mouse-released gooi.released
 :init init}

