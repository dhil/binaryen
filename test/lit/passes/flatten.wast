;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s -all --flatten -S -o - | filecheck %s

(module
 ;; CHECK:      (type $simplefunc (func))
 (type $simplefunc (func))
 ;; CHECK:      (func $0 (param $0 (ref $simplefunc)) (result (ref $simplefunc))
 ;; CHECK-NEXT:  (local $1 (ref $simplefunc))
 ;; CHECK-NEXT:  (local.set $1
 ;; CHECK-NEXT:   (local.get $0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (return
 ;; CHECK-NEXT:   (local.get $1)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $0 (param $0 (ref $simplefunc)) (result (ref $simplefunc))
  ;; a local.get of a non-nullable param is ok, and does not need to be
  ;; modified
  (local.get $0)
 )
)
