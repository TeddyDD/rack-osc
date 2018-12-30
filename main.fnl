(local socket (require :socket))
(local struct (require :struct))
(local rnd love.math.random)

(local ip "127.0.0.1")
(local port 7001)

(fn padding-length [str]
  (let [real-len (+ 1 (# str)) ; len + zero byte
        rest (% real-len 4)] ; how much bytes to pad
     (if (= rest 0)
         rest
         (- 4 rest))))

(fn padding-pattern [str]
  (let [len (padding-length str)]
    (.. "c" (tostring len))))

(fn padding-zeros [str]
  (string.rep "\0" (padding-length str)))

(fn pack-float-pattern [addr tag arg]
  (.. ">s"
      (padding-pattern addr)
      "s"
      (padding-pattern tag)
      "f"))
  


(fn float-msg [num]
  (let [addr "/trowacv/ch/1"
        tag ",f"
        arg num]
    (struct.pack
      (pack-float-pattern addr tag arg)
      addr
      (padding-zeros addr)
      tag
      (padding-zeros tag)
      arg)))

(fn love.load []
  (global udp (socket.udp))
  (: udp :settimeout 0)
  (: udp :setpeername ip port))
  ; (let
  ;   [(ok err) (: udp :send (msg))]
  ;   (print (.. "status" (tostring ok)))))

(fn love.draw []
  (love.graphics.print "Hello Wordl", 400, 300))

(fn love.update [dt]
  (: udp :send (float-msg (rnd 1 127))))
