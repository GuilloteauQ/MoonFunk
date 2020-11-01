with import <nixpkgs> {};
with luaPackages;

let
  libs = [
	lua5_3
	lua53Packages.busted
	lua53Packages.luacheck
	lua53Packages.ldoc
  ];
in
stdenv.mkDerivation rec {
  name = "lua-env";
  buildInputs = libs;

   # export LUA_PATH="${lib.concatStringsSep ";" (map getLuaPath libs)};$(pwd)/src/moon_funk.lua"
   # export LUA_PATH="$(pwd)/src/moon_funk.lua"
   # export LUA_CPATH="${lib.concatStringsSep ";" (map getLuaCPath libs)};$(pwd)/src/moon_funk.lua"
   # export LUA_CPATH="$(pwd)/src/moon_funk.lua"
   # export LUA_CPATH="${lib.concatStringsSep ";" (map getLuaCPath libs)};$(pwd)/src/moon_funk.lua"
  shellHook = ''
   export LUA_PATH="${lib.concatStringsSep ";" (map getLuaPath libs)};$(pwd)/src/?.lua"
  '';
}
