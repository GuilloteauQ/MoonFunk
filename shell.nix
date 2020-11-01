with import <nixpkgs> {};
stdenv.mkDerivation {
	name = "shell";
	buildInputs = [
	  lua5_3
      lua53Packages.busted
      lua53Packages.luacheck
	];
}
