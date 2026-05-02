(module
	(import "wasi_snapshot_preview1" "fd_write" (func $fd_write (param i32 i32 i32 i32) (result i32)))
	(memory 1)	;; allocate a page (64kb linear memory)
;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	(export "memory" (memory 0))
;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	
;;required otherwise you will see:
;;Error: failed to run main module `hello.wat`

;;Caused by:
;;   0: failed to invoke command default
;;   1: error while executing at wasm backtrace:
;;   0:     0x6b - <unknown>!main
;;   2: missing required memory export

	(data (i32.const 0) "Hello World\n") ;; 12 bytes total OFFSET 0
	(func $main (export "_start")

;;because string takes 12 bytes, so START OFFSET SHOULD BE 12
		(i32.store (i32.const 12) (i32.const 0)) 
;;it means: allocate store a value 0(WHICH IS THE OFFSET OF STRING) at offset 12
		(i32.store (i32.const 16) (i32.const 12))
;;it means: allocate store a value 12(WHICH IS THE LENGTH OF STRING) at offset 16

;;push the args into stack , then call fd_write

;;we push
;;file descriptor
;;offset of the string
;;length of the string
;;OFFSET WHERE TO STORE the bytes written in total
		i32.const 1 	;; STDOUT file descriptor
		i32.const 12	;; pointer which points to the offset of STRING,that is: 0
		i32.const 1 	;; one string
		i32.const 20	;; 12(STRING) + 4(POINTER) + 4(STRING LENGTH)
		call $fd_write
		drop ;;drop the return val of fd_write because main function don't return HERE
	)

)
