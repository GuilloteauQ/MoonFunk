with import <nixpkgs> {};
stdenv.mkDerivation {
	name = "shell";
	buildInputs = [
	  lua5_3
	];
}
