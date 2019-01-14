(local g (require "love.graphics"))
(local win (require "love.window"))

(var w 0)
(var h 0)

(fn update []
  (set (w h) (win.getMode)))

(fn full-screen-rect []
  (values 0 0 (win.fromPixels w) (win.fromPixels h)))

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

(fn draw []
  (g.setLineWidth 3)
  (main-screen)
  (rest {:split 40 :vertical false} (full-screen-rect))
  (menu 40)
  (let [(_ _ fw fh) (full-screen-rect)]
    (stack 0 40 fw (- fh 40)  {:splits 2 :vertical true})))

{:update update
 :draw draw}
