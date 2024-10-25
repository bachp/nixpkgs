{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, rocksdb
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-backend-rocksdb";
  version = "0.6.0-beta.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = pname;
    rev = version;
    sha256 = "sha256-FB0ITi3ndA/6WP077qsB+Gca21rxdzKDZlaRkDMfpB4=";
  };

  cargoSha256 = "sha256-USCWlhLxs4mIH64O9+vX3WI50Srthz+uFvLe72MgdRQ=";

  # needed for librocksdb-sys
  nativeBuildInputs = [ llvmPackages.clang ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # link rocksdb dynamically
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  meta = with lib; {
    description = "Backend and Storages for zenoh using RocksDB";
    homepage = "https://zenoh.io/";
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ bachp ];
  };
}
