(require "gooi")

(local layout (require :layout))
(local trowa (require :trowa))

(local window love.window)

(let [style {:font (love.graphics.newFont "/font/Inter-UI-Regular.ttf" 12)}]
  (gooi.setStyle style))

(local state
  {:mode "osccv" ; ... gridseq, voltseq
   :menu {}
   :values [0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5]})

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

(lambda ComponentWrapper.set_bounds [self sizes]
  (each [i c (ipairs (. self :controls))]
    (let [{:x :y :w :h} (. sizes i)]
      (: c :setBounds x y w h))))

(fn make-menu []
  (let [sizes (layout.get "menuButtons")
        controls
          [(doto (gooi.newButton {:text "Exit"})
             (: :onRelease (fn exit-handler [] (love.event.quit))))
           (gooi.newButton {:text "Layout"})
           (gooi.newButton {:text "Conn"})]]
    (each [i c (ipairs controls)]
      (let [r (. sizes i)]
        (doto c
          (: :setBounds r.x r.y r.w r.h))))

    (ComponentWrapper.new controls)))

(fn make-sliders [side]
  (var sliders {})
  (for [i 1 4]
    (let [r (. (layout.get (.. side "Sliders")) i)
          colorOff (if (= side "left") 0 4)]
      (tset sliders i
        (doto (gooi.newSlider
                 {:value 0.5
                  :x r.x
                  :y r.y
                  :w r.w
                  :h r.h})
          (: :vertical)
          (: :bg (. trowa :colors (+ colorOff i)))))))
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

(fn update [dt]
  (gooi.update dt)
  (for [i 1 4]
    (let [j (+ i 4)
          oldL (. state :values i)
          oldR (. state :values j)
          newL (: (. state :l-sliders :controls i) :getValue)
          newR (: (. state :r-sliders :controls i) :getValue)]
      (when (~= oldL newL)
          (tset state :values i newL)
          (love.event.push "valueChanged" i newL))
      (when (~= oldR newR)
          (tset state :values j newR)
          (love.event.push "valueChanged" j newR)))))

{:draw gooi.draw
 :update update
 :mouse-pressed gooi.pressed
 :mouse-released gooi.released
 :mouse-moved gooi.moved
 :init init}
