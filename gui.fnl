(local suit (require :suit))
; (local dbg (require "dbg"))
(local window love.window)

(local l
 (let [(width heigth) (window.getMode)
       menu 40
       padding 10
       usable (- heigth menu (* 3 padding))]
  {:menu-heigth menu
   :width width
   :heigth heigth
   :usable-heigth usable
   :padding padding}))

(fn get-usable-heigth []
  (- l.heigth l.menu-heigth (* 3 l.padding)))

(local state
  {:mode "osccv" ; ... gridseq, voltseq
   :sliders {}})

(fn empty-sliders [state]
  (for [i 1 8]
    (tset state.sliders i {:min 1 :max 127 :value (/ 127 2)})))

(fn menu []
  (if (. (suit.Button "Exit" l.padding l.padding 100 l.menu-heigth) :hit)
      (love.event.quit)))

(fn sliders []
  (var x l.padding)
  (for [i 1 4]
    (suit.Slider (. state.sliders i) 
                 {:vertical true} 
                 x (+ l.menu-heigth (* 2 l.padding)) 
                 20 
                 (get-usable-heigth))
    (set x (+ x 20 l.padding))))

(fn init []
  (let [w 800 h 600]
    (love.window.setMode w h
      {:resizable true}))
  (empty-sliders state))

(fn update []
  (let [(width heigth) (window.getMode)]
    (tset l :width width)
    (tset l :heigth heigth))
  (menu)
  (sliders))

{:draw suit.draw
 :update update
 :init init}

