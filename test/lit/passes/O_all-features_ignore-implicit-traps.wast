;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_test.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt -O --all-features --ignore-implicit-traps -S -o - | filecheck %s

;; Test that we can run GC types through the optimizer
(module
  ;; CHECK:      (type $ref?|$struct.A|_=>_none (func (param (ref null $struct.A))))

  ;; CHECK:      (type $struct.A (struct (field i32)))
  (type $struct.A (struct i32))

  (func "foo" (param $x (ref null $struct.A))
    ;; get a struct reference
    (drop
      (local.get $x)
    )
    ;; get a struct field value
    ;; (note that since this is a nullable reference, it may trap, but we
    ;; are ignoring implicit traps, so it has no side effects)
    (drop
      (struct.get $struct.A 0 (local.get $x))
    )
  )
)
;; CHECK:      (export "foo" (func $0))

;; CHECK:      (func $0 (; has Stack IR ;) (param $0 (ref null $struct.A))
;; CHECK-NEXT:  (nop)
;; CHECK-NEXT: )