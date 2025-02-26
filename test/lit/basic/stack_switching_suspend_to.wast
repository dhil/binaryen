;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt %s -all -o %t.text.wast -g -S
;; RUN: wasm-as %s -all -g -o %t.wasm
;; RUN: wasm-dis %t.wasm -all -o %t.bin.wast
;; RUN: wasm-as %s -all -o %t.nodebug.wasm
;; RUN: wasm-dis %t.nodebug.wasm -all -o %t.bin.nodebug.wast
;; RUN: cat %t.text.wast | filecheck %s --check-prefix=CHECK-TEXT
;; RUN: cat %t.bin.wast | filecheck %s --check-prefix=CHECK-BIN
;; RUN: cat %t.bin.nodebug.wast | filecheck %s --check-prefix=CHECK-BIN-NODEBUG

(module
 ;; CHECK-TEXT:      (type $ht (handler i32 i32 i64 f32))
 ;; CHECK-BIN:      (type $ht (handler i32 i32 i64 f32))
 (type $ht (handler i32 i32 i64 f32))
 (type $ft (func (param (ref $ht))))
 (type $ct (cont $ft))

 ;; CHECK-TEXT:      (type $1 (func (param i32) (result i64)))

 ;; CHECK-TEXT:      (type $2 (func (param (ref $ht)) (result i64)))

 ;; CHECK-TEXT:      (tag $t (type $1) (param i32) (result i64))
 ;; CHECK-BIN:      (type $1 (func (param i32) (result i64)))

 ;; CHECK-BIN:      (type $2 (func (param (ref $ht)) (result i64)))

 ;; CHECK-BIN:      (tag $t (type $1) (param i32) (result i64))
 (tag $t (param i32) (result i64))

 ;; CHECK-TEXT:      (func $f (type $2) (param $h (ref $ht)) (result i64)
 ;; CHECK-TEXT-NEXT:  (suspend_to $ht $t
 ;; CHECK-TEXT-NEXT:   (i32.const 123)
 ;; CHECK-TEXT-NEXT:   (local.get $h)
 ;; CHECK-TEXT-NEXT:  )
 ;; CHECK-TEXT-NEXT: )
 ;; CHECK-BIN:      (func $f (type $2) (param $h (ref $ht)) (result i64)
 ;; CHECK-BIN-NEXT:  (suspend_to $ht $t
 ;; CHECK-BIN-NEXT:   (i32.const 123)
 ;; CHECK-BIN-NEXT:   (local.get $h)
 ;; CHECK-BIN-NEXT:  )
 ;; CHECK-BIN-NEXT: )
 (func $f (param $h (ref $ht)) (result i64)
   (suspend_to $ht $t (i32.const 123) (local.get $h))
 )
)
;; CHECK-BIN-NODEBUG:      (type $0 (handler i32 i32 i64 f32))

;; CHECK-BIN-NODEBUG:      (type $1 (func (param i32) (result i64)))

;; CHECK-BIN-NODEBUG:      (type $2 (func (param (ref $0)) (result i64)))

;; CHECK-BIN-NODEBUG:      (tag $tag$0 (type $1) (param i32) (result i64))

;; CHECK-BIN-NODEBUG:      (func $0 (type $2) (param $0 (ref $0)) (result i64)
;; CHECK-BIN-NODEBUG-NEXT:  (suspend_to $0 $tag$0
;; CHECK-BIN-NODEBUG-NEXT:   (i32.const 123)
;; CHECK-BIN-NODEBUG-NEXT:   (local.get $0)
;; CHECK-BIN-NODEBUG-NEXT:  )
;; CHECK-BIN-NODEBUG-NEXT: )
