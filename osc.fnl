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

; Create float message
(fn float-msg [num channel]
  (let [addr (.. "/trowacv/ch/" (tostring channel))
        tag ",f"
        arg num]
    (struct.pack
      (pack-float-pattern addr tag arg)
      addr
      (padding-zeros addr)
      tag
      (padding-zeros tag)
      arg)))

{:float-msg float-msg}
