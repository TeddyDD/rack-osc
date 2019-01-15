(local g (require "love.graphics"))
(local win (require "love.window"))
; (local dbg (require "dbg"))

(var w 0)
(var h 0)

(fn debug [rect]
  (let [rnd love.math.random
        r (rnd) g (rnd) b (rnd)]
    (local gr (require "love.graphics"))
    (gr.setColor r g b)
    (gr.rectangle "line" rect.x rect.y rect.w rect.h)))

(fn screenRect []
  {:x 0 :y 0 :w (win.fromPixels w) :h (win.fromPixels h)})

(lambda firstRest [options parent]
  (let [vertical (or (. options :vertical) false)
        split (. options :split)
        first (if vertical
                  {:x parent.x :y parent.y :w parent.w :h split}
                  {:x parent.x :y parent.y :h parent.h :w split})
        second (if vertical
                   {:x parent.x :y (+ parent.y split) :w parent.w :h (- parent.h split)}
                   {:y parent.y :x (+ parent.x split) :h parent.h :w (- parent.w split)})]
    (values first reset)))

(fn main-screen []
  (g.setLineWidth 4)
  (g.setColor 1 0 1)
  (g.rectangle "line" (full-screen-rect)))

; TODO convert to first / rest
(fn menu [heigth]
  (let [(x y w h) (full-screen-rect)]
    (g.setColor 0.3 0.1 1)
    (g.rectangle "line" x y w heigth)
    (values x y w heigth)))

(fn rest [options x y w h]
  (let [vertical (or (. options :vertical) false)
        split (. options :split)
        first (if vertical
                  {:w w :h split}
                  {:h h :w split})
        second (if vertical
                   {:x x :y (+ y split) :w w :h (- h split)}
                   {:y y :x (+ x split) :h h :w (- w split)})]
    (g.setColor 0 0 1)
    (g.rectangle "line" x y first.w first.h)
    (g.setColor 1 0 0)
    (g.rectangle "line" second.x second.y second.w second.h)))


(fn stack [x y w h options]
  (let [splits options.splits
        vertical (or (. options :vertical) false)
        axis (if vertical y x)
        split (/ (if vertical h w) splits)]
    (var nx axis)
    (for [i 1 splits]
      (g.setColor 0.1 (* 0.1 i) 0.1)
      (if vertical
          (g.rectangle "line" x nx w split)
          (g.rectangle "line" nx y split h))
      (set nx (+ nx split)))))

(var layout {})

(fn recalculate-layout []
  (let [screen (screenRect)
        menuOpts {:vertical true :split 45}
        (menu workspace) (firstRest menuOpts screen)]
    (set layout
      {:screen screen
       :menu menu
       :workspace workspace})))

(fn update []
  (let [(newW newH) (win.getMode)]
    (set w newW)
    (set h newH)
    (when (or (~= w newW) (not (~= h newH)))
          (recalculate-layout))))


(fn draw []
  (g.setLineWidth 3)
  (debug layout.screen)
  (debug layout.menu))
  ; (main-screen)
  ; (rest {:split 40 :vertical false} (full-screen-rect))
  ; (menu 40)
  ; (let [(_ _ fw fh) (full-screen-rect)]
    ; (stack 0 40 fw (- fh 40)  {:splits 2 :vertical true})))

{:update update
 :draw draw}
