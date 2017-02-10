{ stdenv,  fetchurl, fetchpatch, ensureNewerSourcesHook, cmake, makeWrapper, pkgconfig
, libtool, which, git
, boost, python2Packages, libxml2, zlib, snappy, rocksdb, curl, libatomic_ops

# Optional Dependencies
, openldap ? null, fuse ? null
, libxfs ? null, zfs ? null
, leveldb ? null, keyutils ? null, accelio ? null

# Rados GW dependencies
, fcgi ? null, expat ? null


, dpdk ? null

# XIO dependencies
, librdmacm ? null, libibverbs ? null


#lttng-ust, liburcu, yasm ? null,
# babeltrace ? null

# Mallocs
, jemalloc ? null, gperftools ? null

# Crypto Dependencies
, cryptopp ? null, openssl ? null
, nss ? null, nspr ? null

# Linux Only Dependencies
, linuxHeaders, libuuid, udev, libaio, utillinux

}:

# We must have one crypto library
assert cryptopp != null || (nss != null && nspr != null);

with stdenv;
with stdenv.lib;
let
  inherit (python2Packages) python cython;

  opt = cond:
    if cond == null then null else if cond != false then "ON" else "OFF";

  shouldUsePkg = pkg_: let pkg = (builtins.tryEval pkg_).value;
    in if lib.any (x: x == system) (pkg.meta.platforms or [])
      then pkg else null;

  optOpenldap = shouldUsePkg openldap;
  optLeveldb = shouldUsePkg leveldb;
  optFcgi = shouldUsePkg fcgi;
  optExpat = shouldUsePkg expat;
  optFuse = shouldUsePkg fuse;
  optKeyutils = shouldUsePkg keyutils;
  optAccelio = shouldUsePkg accelio;
  optLibibverbs = shouldUsePkg libibverbs;
  optLibrdmacm = shouldUsePkg librdmacm;

  optJemalloc = shouldUsePkg jemalloc;
  optGperftools = shouldUsePkg gperftools;

  optCryptopp = shouldUsePkg cryptopp;
  optOpenssl = shouldUsePkg openssl;
  optNss = shouldUsePkg nss;
  optNspr = shouldUsePkg nspr;

  optLibaio = shouldUsePkg libaio;
  optLibxfs = shouldUsePkg libxfs;
  optZfs = shouldUsePkg zfs;

  hasRadosgw = optFcgi != null && optExpat != null;

  hasXio = (stdenv.isLinux || stdenv.isFreeBSD) &&
    optAccelio != null && optLibibverbs != null && optLibrdmacm != null;

  hasDpdk = optLibibverbs != null;

  hasKRDB = stdenv.isLinux;

  # Malloc implementation (can be jemalloc, tcmalloc or null)
  malloc = if optJemalloc != null then optJemalloc else optGperftools;

  # We prefer nss over cryptopp
  cryptoStr = if optNss != null && optNspr != null then "nss" else
    if optCryptopp != null then "cryptopp" else "none";
  cryptoLibsMap = {
    nss = [ optNss optNspr ];
    cryptopp = [ optCryptopp optOpenssl ];
    none = [ ];
  };

  wrapArgs = "--set PYTHONPATH \"$(toPythonPath $out)\""
    + " --prefix PYTHONPATH : \"$(toPythonPath ${python2Packages.flask}):$(toPythonPath ${python2Packages.requests}:$(toPythonPath ${python2Packages.werkzeug})\""
    + " --set PATH \"$out/bin:${utillinux}/bin\"";

  version = "11.2.0";
in
stdenv.mkDerivation {

  name="ceph-${version}";

  src = fetchurl {
    url = "http://download.ceph.com/tarballs/ceph_${version}.orig.tar.gz";
    sha256 = "1wyagw3kqiy8hq5h1rjk4k07lagh7n7fzrb210avgbal2mh1cz5c";
  };

  patches = [
    (fetchpatch { # find keyutils
      url = "https://github.com/ceph/ceph/commit/c79bf93d026b9813a791831d2eb10532d80e87f3.patch";
      sha256 = "1gxg0xcr1xb22xpldfy8r0a2fzhjbb2hc4vpsa4gb4x5195z0fzw";
    })
  ];

  nativeBuildInputs = [
    cmake makeWrapper pkgconfig libtool which git
    (ensureNewerSourcesHook { year = "1980"; })
    python2Packages.setuptools python2Packages.argparse
    ];

  buildInputs = cryptoLibsMap.${cryptoStr} ++ [
    boost python cython libxml2 snappy libatomic_ops malloc python2Packages.flask zlib curl rocksdb
    optLibxfs optZfs optLeveldb optFuse optOpenldap optKeyutils optLibaio
    python2Packages.sphinx # Used for docs
    python2Packages.six
  ] ++ optionals stdenv.isLinux [
    linuxHeaders libuuid udev
  ] ++ optionals hasRadosgw [
    optFcgi optExpat
  ] ++ optionals hasXio [
    optAccelio optLibibverbs optLibrdmacm
  ] ++ optionals hasDpdk [
    optLibibverbs
  ];

  cmakeFlags = [
    "-DENABLE_SHARED=ON"
    "-DWITH_RDMA=${opt optLibrdmacm}"
    "-DWITH_OPENLDAP=${opt optOpenldap}"
    "-DWITH_FUSE=${opt optFuse}"
    "-DWITH_XFS=${opt optLibxfs}"
    "-DWITH_SPDK=OFF"
    "-DWITH_LIBCEPHFS=ON"
    "-DWITH_KVS=ON"
    "-DWITH_RBD=ON"
    "-DWITH_KRBD=${opt hasKRDB}"
    "-DWITH_EMBEDDED=OFF"
    "-DWITH_LEVELDB=${opt optLeveldb}"
    "-DWITH_NSS=${opt (cryptoStr == "nss")}"
    "-DWITH_SSL=ON"
    "-DWITH_XIO=OFF" #${opt hasXio}"
    "-DWITH_DPDK=OFF" #${opt hasDpdk}"
    "-DWITH_RADOSGW=${opt hasRadosgw}"
    "-DWITH_RADOSGW_FCGI_FRONTEND=${opt optFcgi}" # TODO hasRadosgw
    "-DWITH_RADOSGW_ASIO_FRONTEND=${opt hasRadosgw}"
    "-DWITH_CEPHFS=ON"
    "-DWITH_MGR=OFF" # TODO: ON
    "-DWITH_THREAD_SAFE_RES_QUERY=OFF"
    "-DWITH_REENTRANT_STRSIGNAL=OFF"
    "-DWITH_LTTNG=OFF"
    "-DHAVE_BABELTRACE=OFF"
    "-DDEBUG_GATHER=OFF"
    "-DHAVE_LIBZFS=OFF" #TODO: ${opt optZfs}"
    "-DWITH_TESTS=OFF"
    "-DWITH_FIO=OFF"
    "-DWITH_ASAN=OFF"
    "-DWITH_ASAN_LEAK=OFF"
    "-WITH_TSAN=OFF"
    "-DWITH_UBSAN=OFF"
    "-DWITH_SYSTEM_ROCKSDB=ON"
    "-DWITH_SYSTEM_BOOST=ON"
    "-DWITH_SELINUX=OFF" # TODO implement
    "-DWITH_SYSTEMD=OFF" # We use our own service files
  ];

  outputs = [ "out" "lib" ];

  postInstall = ''
    # Wrap all of the python scripts
    wrapProgram $out/bin/ceph ${wrapArgs}
    wrapProgram $out/bin/ceph-brag ${wrapArgs}
    wrapProgram $out/bin/ceph-rest-api ${wrapArgs}
    wrapProgram $out/sbin/ceph-create-keys ${wrapArgs}

    # Bring in lib as a native build input
    mkdir -p $out/nix-support
    echo "$lib" > $out/nix-support/propagated-native-build-inputs
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://ceph.com/;
    description = "Distributed storage system";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ak wkennington ];
    platforms = platforms.unix;
  };
}
