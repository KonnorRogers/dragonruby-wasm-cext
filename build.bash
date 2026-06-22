rm -rf mygame/native/
mkdir -p mygame/native/emscripten-wasm

./dragonruby-bind square.c --output=square-bindings.c

# Make the "latest" SDK "active" for the current user. (writes .emscripten file)
./emsdk/emsdk install 5.0.4
./emsdk/emsdk activate 5.0.4

# ./emsdk/emsdk install 3.1.3
# ./emsdk/emsdk activate 3.1.3

# Activate PATH and other environment variables in the current terminal
source ./emsdk/emsdk_env.sh

emcc square-bindings.c \
  -O1 \
  -fPIC \
  -s SIDE_MODULE=1 \
  -pthread \
  -s WASM_BIGINT \
  -isystem "./include/mruby/include/" \
  -isystem "./include/" \
  -o mygame/native/emscripten-wasm/square.wasm
