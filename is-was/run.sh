#!/bin/zsh
while [[ "$#" -gt 0 ]]; do
    case $1 in
	deploy|D)    $DEPLOY=1 ;;
	wasi|w)      $WASI=1 ;;
	wasmweb|W)   $WASMWEB=1 ;;
	run|r)       $RUN=1 ;;
	build|b)     $BUILD=1 ;;
	c)           $C=1 ;;
	cpp)         $CPP=1 ;;
	rust|r)      $RUST=1 ;;
	install|i)   $INSTALL=1 ;;
	test|t)      $TEST=1 ;;
	debug|d)     $DEBUG=1 ;;
	help|h)      $HELP=1 ;;
	zig|z)       $ZIG=1 ;;
	*)           echo "Unknown parameter passed: $1"; exit 1 ;;
	esac 
    shift
done

if [[ $WASI -eq 1 && $RUST -eq 1 && $BUILD -eq 1 ]]; then
    echo "Okay, runningg Wasi build from Rust"
    cargo wasi build --release
    cargo wasi run

elif [[ $WASI && $RUST && $RUN ]]; then
    echo "Okay, runningg Wasi from Rust"
    cargo wasi run

elif [[ $WASI && $ZIG && $RUN ]]; then
    echo "Okay, runningg Wasi from Zig"
    zig run src/main.zig

elif [[ $WASI && $ZIG && $BUILD ]]; then
    echo "Okay, runningg building Wasi from Zig"
    zig build src/main.zig

elif [[ $WASI && $C && ($BUILD || $RUN)]];  then
    echo "Okay, runningg building & running Wasi from C"
    clang ./main.c -o ./main.wasm
    ./main.wasm

elif [[ $WASI && $CPP && ($BUILD || $RUN) ]]; then
    echo "Okay, runningg building & running Wasi from C++"
    clang ./main.cpp -o mainp.waspm
    ./mainp.wasm

elif [[ $HELP ]]; then
    echo "usage for x.sh:"
    echo ""
    echo "actions"
    echo ""
    echo "b | build    ->   builds"
    echo "r | run      ->   runs"
    echo "i | install  ->   install"
    echo "p | publish  ->   publish to wapm"
    echo ""
    echo "targets"
    echo ""
    echo "z  | zig      ->   zig"
    echo "c  | C        ->   c"
    echo "R  | rust     ->   rust"
    echo ""

else
    echo "Don't really recognize that yet"
fi
