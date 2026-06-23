rm -rf mygame/native/
mkdir -p mygame/native/emscripten-wasm

./dragonruby-bind square.c --output=square-bindings.c

# 3.1.3 is last known version of emscripten ive seen for DR prior to upgrade to 5.0.4
./emsdk/emsdk install 3.1.3
./emsdk/emsdk activate 3.1.3

# Activate PATH and other environment variables in the current terminal
source ./emsdk/emsdk_env.sh

emcc square-bindings.c \
     -O2 \
     -fPIC \
     -s SIDE_MODULE=1 \
     -pthread \
     -DMRB_INT64 \
     -isystem ./include/mruby/include/ \
     -isystem ./include/ \
     -o mygame/native/emscripten-wasm/square.wasm

./dragonruby-publish --package mygame --platforms=html5
