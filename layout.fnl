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

; Rect: {:x :y :w :h}

; -> Rect
(fn screenRect []
  {:x 0 :y 0 :w (win.fromPixels w) :h (win.fromPixels h)})

; -> Rect, Rect
(lambda bar [options parent]
  (let [vertical (or (. options :vertical) false)
        split (. options :split)
        first (if vertical
                  {:x parent.x :y parent.y :w parent.w :h split}
                  {:x parent.x :y parent.y :h parent.h :w split})
        second (if vertical
                   {:x parent.x :y (+ parent.y split) :w parent.w :h (- parent.h split)}
                   {:y parent.y :x (+ parent.x split) :h parent.h :w (- parent.w split)})]
    (values first second)))

; [Rect]
(lambda stack [options parent]
  (let [splits options.splits
        vertical (or (. options :vertical) false)
        axis (if vertical parent.y parent.x)
        split (/ (if vertical parent.h parent.w) splits)]
    (var nx axis)
    (var result [])
    (for [i 1 splits]
      (tset result i
        (if vertical
            {:x parent.x :y nx :w parent.w :h split}
            {:x nx :y parent.y :w split :h  parent.h}))
      (set nx (+ nx split)))
    result))

(var layout {})

(fn recalculate-layout []
  (let [screen (screenRect)
        menuOpts {:vertical true :split 45}
        lrOptions {:vertical false :splits 2}
        sliderOptions {:vertical false :splits 4}
        (menu workspace) (bar menuOpts screen)
        [left right] (stack lrOptions workspace)
        leftSliders (stack sliderOptions left)
        rightSliders (stack sliderOptions right)]
    (set layout
      {:screen screen
       :menu menu
       :workspace workspace
       :left left
       :right right
       :leftSliders leftSliders
       :rightSliders rightSliders})))

(fn update []
  (let [(newW newH) (win.getMode)]
    (set w newW)
    (set h newH)
    (when (or (~= w newW) (not (~= h newH)))
          (recalculate-layout))))


(fn draw []
  (g.setLineWidth 3)
  (debug layout.screen)
  (debug layout.menu)
  (debug layout.left)
  (debug layout.right)
  (for [i 1 4]
    (debug (. layout :leftSliders i))
    (debug (. layout :rightSliders i))))

{:update update
 :draw draw}
