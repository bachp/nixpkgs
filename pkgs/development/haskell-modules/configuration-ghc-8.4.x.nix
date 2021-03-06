{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # Use the latest LLVM.
  inherit (pkgs) llvmPackages;

  # Disable GHC 8.4.x core libraries.
  #
  # Verify against:
  # ls /nix/store/wnh3kxra586h9wvxrn62g4lmsri2akds-ghc-8.4.20180115/lib/ghc-8.4.20180115/ -1 | sort | grep -e '-' | grep -Ev '(txt|h|targets)$'
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  bin-package-db = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghci = null;
  ghc-prim = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  stm = null;
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # GHC 8.4.x needs newer versions than LTS-10.x offers by default.
  ## haddock: panic! (the 'impossible' happened)
  ##   (GHC version 8.4.20180122 for x86_64-unknown-linux):
  ## 	extractDecl
  ## Ambiguous decl for Arg in class:
  ##     class Example e where
  ##       type Arg e :: *
  ##       {-# MINIMAL evaluateExample #-}
  ##       evaluateExample ::
  ##         e
  ##         -> Params
  ##            -> ActionWith Arg e -> IO () -> ProgressCallback -> IO Result
  ## Matches:
  ##     []
  ## Call stack:
  ##     CallStack (from HasCallStack):
  ##       callStackDoc, called at compiler/utils/Outputable.hs:1150:37 in ghc:Outputable
  ##       pprPanic, called at utils/haddock/haddock-api/src/Haddock/Interface/Create.hs:1013:16 in main:Haddock.Interface.Create
  ## Please report this as a GHC bug:  http://www.haskell.org/ghc/reportabug
  hspec = dontHaddock (dontCheck super.hspec_2_4_8);        # test suite causes an infinite loop

  ## Setup: Encountered missing dependencies:
  ## QuickCheck >=2.3 && <2.10
  ## builder for ‘/nix/store/d60y5jwn5bpgk2p8ps23c129dcw7whg6-test-framework-0.8.2.0.drv’ failed with exit code 1
  ## error: build of ‘/nix/store/d60y5jwn5bpgk2p8ps23c129dcw7whg6-test-framework-0.8.2.0.drv’ failed
  test-framework = dontCheck self.test-framework_0_8_2_0;

  # Undo the override in `configuration-common.nix`: GHC 8.4 bumps Cabal to 2.1:
  # Distribution/Simple/CCompiler.hs:64:10: error:
  #  • No instance for (Semigroup CDialect)
  #      arising from the superclasses of an instance declaration
  #  • In the instance declaration for ‘Monoid CDialect’
  #     |
  #  64 | instance Monoid CDialect where
  #     |          ^^^^^^^^^^^^^^^
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal; }; #pkgs.haskell.packages.ghc822.jailbreak-cabal;

  ## Shadowed:

  ## Needs bump to a versioned attribute
  ## 
  ##     • Could not deduce (Semigroup (Dict a))
  ##         arising from the superclasses of an instance declaration
  ##       from the context: a
  constraints = super.constraints_0_10;

  ## Needs bump to a versioned attribute
  ## 
  ##     • Could not deduce (Semigroup (IterT m a))
  ##         arising from the superclasses of an instance declaration
  ##       from the context: (Monad m, Monoid a)
  free = super.free_5;

  funcmp = overrideCabal super.funcmp_1_9 (drv: {
    ## Needs bump to a versioned attribute
    ## 
    ## Needed for (<>) in prelude
    ## Setup: Encountered missing dependencies:
    ## base >=3 && <4.11
    jailbreak       = true;
  });

  hspec-core = overrideCabal super.hspec-core_2_4_8 (drv: {
    ## Needs bump to a versioned attribute
    ## 
    ##     • No instance for (Semigroup Summary)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid Summary’
    ## error: while evaluating the attribute ‘buildInputs’ of the derivation ‘hspec-core-2.4.8’ at /home/deepfire/src/nixpkgs/pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## while evaluating the attribute ‘buildInputs’ of the derivation ‘silently-1.2.5’ at /home/deepfire/src/nixpkgs/pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## while evaluating the attribute ‘buildInputs’ of the derivation ‘temporary-1.2.1.1’ at /home/deepfire/src/nixpkgs/pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## while evaluating the attribute ‘buildInputs’ of the derivation ‘base-compat-0.9.3’ at /home/deepfire/src/nixpkgs/pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## while evaluating the attribute ‘propagatedBuildInputs’ of the derivation ‘hspec-2.4.8’ at /home/deepfire/src/nixpkgs/pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## infinite recursion encountered, at undefined position
    doCheck         = false;
  });

  ## Needs bump to a versioned attribute
  ## 
  ## breaks hspec:
  ## Setup: Encountered missing dependencies:
  ## hspec-discover ==2.4.7
  hspec-discover = super.hspec-discover_2_4_8;

  lens = overrideCabal super.lens_4_16 (drv: {
    ## Needs bump to a versioned attribute
    ## 
    ##     • Could not deduce (Apply f)
    ##         arising from the superclasses of an instance declaration
    ##       from the context: (Contravariant f, Applicative f)
    ## Setup: Encountered missing dependencies:
    ## ghc >=7.0 && <8.4
    ## /run/current-system/sw/bin/nix-shell: failed to build all dependencies
    doCheck         = false;
  });

  semigroupoids = overrideCabal super.semigroupoids_5_2_2 (drv: {
    ## Needs bump to a versioned attribute
    ## 
    ##     • Variable not in scope: mappend :: Seq a -> Seq a -> Seq a
    ## Setup: Encountered missing dependencies:
    ## ghc >=7.0 && <8.4
    ## /run/current-system/sw/bin/nix-shell: failed to build all dependencies
    doCheck         = false;
  });

  ## Needs bump to a versioned attribute
  ## 
  ##     • No instance for (Semigroup Builder)
  ##         arising from the superclasses of an instance declaration
  ##     • In the instance declaration for ‘Monoid Builder’
  stringbuilder = super.stringbuilder_0_5_1;

  ## Needs bump to a versioned attribute
  ## 
  ##     Module ‘Data.Semigroup’ does not export ‘Monoid(..)’
  ##    |
  ## 80 | import Data.Semigroup (Semigroup(..), Monoid(..))
  unordered-containers = super.unordered-containers_0_2_9_0;


  ## On Hackage:

  tasty = overrideCabal super.tasty (drv: {
    ## On Hackage, awaiting for import
    ## 
    ##     • No instance for (Semigroup OptionSet)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid OptionSet’
    version         = "1.0.0.1";
    sha256          = "0ggqffw9kbb6nlq1pplk131qzxndqqzqyf4s2p7576nljx11a7qf";
  });


  ## Upstreamed

  haskell-gi = overrideCabal super.haskell-gi (drv: {
    ## Upstreamed, awaiting a Hackage release
    ## 
    ## Setup: Encountered missing dependencies:
    ## haskell-gi-base ==0.20.*
    src = pkgs.fetchFromGitHub {
      owner  = "haskell-gi";
      repo   = "haskell-gi";
      rev    = "30d2e6415c5b57760f8754cd3003eb07483d60e6";
      sha256 = "1l3qm97gcjih695hhj80rbpnd72prnc81lg5y373yj8jk9f6ypbr";
    };
    ## Setup: Encountered missing dependencies:
    ## ghc >=7.0 && <8.4
    ## /run/current-system/sw/bin/nix-shell: failed to build all dependencies
    doCheck         = false;
  });

  haskell-gi-base = overrideCabal super.haskell-gi-base (drv: {
    ## Upstreamed, awaiting a Hackage release
    ## 
    ## Setup: Encountered missing dependencies:
    ## haskell-gi-base ==0.21.*
    ## cannot build derivation ‘/nix/store/b3d6yr1rzk4hpzg87yk4n5i4321i824f-gi-cairo-1.0.14.drv’: 1 dependencies couldn't be built
    src = pkgs.fetchFromGitHub {
      owner  = "haskell-gi";
      repo   = "haskell-gi";
      rev    = "30d2e6415c5b57760f8754cd3003eb07483d60e6";
      sha256 = "1l3qm97gcjih695hhj80rbpnd72prnc81lg5y373yj8jk9f6ypbr";
    };
    prePatch        = "cd base; ";
  });

  haskell-src-exts = overrideCabal super.haskell-src-exts (drv: {
    ## Upstreamed, awaiting a Hackage release
    ## 
    ##     • Could not deduce (Semigroup (ParseResult m))
    ##         arising from the superclasses of an instance declaration
    ##       from the context: Monoid m
    src = pkgs.fetchFromGitHub {
      owner  = "haskell-suite";
      repo   = "haskell-src-exts";
      rev    = "935f6f0915e89c314b686bdbdc6980c72335ba3c";
      sha256 = "1v3c1bd5q07qncqfbikvs8h3r4dr500blm5xv3b4jqqv69f0iam9";
    };
  });

  lambdacube-compiler = overrideCabal super.lambdacube-compiler (drv: {
    ## Upstreamed, awaiting a Hackage release
    ## 
    ## Setup: Encountered missing dependencies:
    ## aeson >=0.9 && <0.12,
    ## base >=4.7 && <4.10,
    ## directory ==1.2.*,
    ## megaparsec ==5.0.*,
    ## vector ==0.11.*
    src = pkgs.fetchFromGitHub {
      owner  = "lambdacube3d";
      repo   = "lambdacube-compiler";
      rev    = "ff6e3b136eede172f20ea8a0f7017ad1ecd029b8";
      sha256 = "0srzrq5s7pdbygn7vdipxl12a3gbyb6bpa7frbh8zwhb9fz0jx5m";
    };
  });

  lambdacube-ir = overrideCabal super.lambdacube-ir (drv: {
    ## Upstreamed, awaiting a Hackage release
    ## 
    ## Setup: Encountered missing dependencies:
    ## aeson >=0.9 && <0.12, base >=4.8 && <4.10, vector ==0.11.*
    src = pkgs.fetchFromGitHub {
      owner  = "lambdacube3d";
      repo   = "lambdacube-ir";
      rev    = "b86318b510ef59606c5b7c882cad33af52ce257c";
      sha256 = "0j4r6b32lcm6jg653xzg9ijxkfjahlb4x026mv5dhs18kvgqhr8x";
    };
    prePatch        = "cd lambdacube-ir.haskell; ";
  });

  simple-reflect = overrideCabal super.simple-reflect (drv: {
    ## Upstreamed, awaiting a Hackage release
    ## 
    ##     • No instance for (Semigroup Expr)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid Expr’
    src = pkgs.fetchFromGitHub {
      owner  = "twanvl";
      repo   = "simple-reflect";
      rev    = "c357e55da9a712dc5dbbfe6e36394e4ada2db310";
      sha256 = "15q41b00l8y51xzhbj5zhddyh3gi7gvml033w8mm2fih458jf6yq";
    };
  });

  singletons = overrideCabal super.singletons (drv: {
    ## Upstreamed, awaiting a Hackage release
    ## 
    ## Setup: Encountered missing dependencies:
    ## th-desugar ==1.7.*
    src = pkgs.fetchFromGitHub {
      owner  = "goldfirere";
      repo   = "singletons";
      rev    = "23aa4bdaf05ce025a2493b35ec3c26cc94e3fdce";
      sha256 = "0hw12v4z8jxmykc3j8z6g27swmfpxv40bgnx7nl0ialpwbz9mz27";
    };
  });

  th-desugar = overrideCabal super.th-desugar (drv: {
    ## Upstreamed, awaiting a Hackage release
    ## 
    ##     • Could not deduce (MonadIO (DsM q))
    ##         arising from the 'deriving' clause of a data type declaration
    ##       from the context: Quasi q
    src = pkgs.fetchFromGitHub {
      owner  = "goldfirere";
      repo   = "th-desugar";
      rev    = "4ca98c6492015e6ad063d3ad1a2ad6c4f0a56837";
      sha256 = "1n3myd3gia9qsgdvrwqa023d3g7wkrhyv0wc8czwzz0lj9xzh7lw";
    };
  });

  websockets = overrideCabal super.websockets (drv: {
    ## Upstreamed, awaiting a Hackage release
    ## 
    ##     • No instance for (Semigroup SizeLimit)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid SizeLimit’
    src = pkgs.fetchFromGitHub {
      owner  = "jaspervdj";
      repo   = "websockets";
      rev    = "11ba6d15cf47bace1936b13a58192e37908b0300";
      sha256 = "1swphhnqvs5kh0wlqpjjgx9q91yxi6lasid8akdxp3gqll5ii2hf";
    };
  });


  ## Unmerged

  blaze-builder = overrideCabal super.blaze-builder (drv: {
    ## Unmerged.  PR: https://github.com/lpsmith/blaze-builder/pull/10
    ## 
    ##     • No instance for (Semigroup Poke)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid Poke’
    src = pkgs.fetchFromGitHub {
      owner  = "bgamari";
      repo   = "blaze-builder";
      rev    = "b7195f160795a081adbb9013810d843f1ba5e062";
      sha256 = "1g351fdpsvn2lbqiy9bg2s0wwrdccb8q1zh7gvpsx5nnj24b1c00";
    };
  });

  bytestring-trie = overrideCabal super.bytestring-trie (drv: {
    ## Unmerged.  PR: https://github.com/wrengr/bytestring-trie/pull/3
    ## 
    ##     • Could not deduce (Semigroup (Trie a))
    ##         arising from the superclasses of an instance declaration
    ##       from the context: Monoid a
    src = pkgs.fetchFromGitHub {
      owner  = "RyanGlScott";
      repo   = "bytestring-trie";
      rev    = "e0ae0cb1ad40dedd560090d69cc36f9760797e29";
      sha256 = "1jkdchvrca7dgpij5k4h1dy4qr1rli3fzbsqajwxmx9865rgiksl";
    };
    ## Setup: Encountered missing dependencies:
    ## HUnit >=1.3.1.1 && <1.7,
    ## QuickCheck >=2.4.1 && <2.11,
    ## lazysmallcheck ==0.6.*,
    ## smallcheck >=1.1.1 && <1.2
    doCheck         = false;
    ## Setup: Encountered missing dependencies:
    ## data-or ==1.0.*
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [ self.data-or ];
  });

  gtk2hs-buildtools = overrideCabal super.gtk2hs-buildtools (drv: {
    ## Unmerged.  PR: https://github.com/gtk2hs/gtk2hs/pull/233
    ## 
    ## Setup: Encountered missing dependencies:
    ## Cabal >=1.24.0.0 && <2.1
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "gtk2hs";
      rev    = "08c68d5afc22dd5761ec2c92ebf49c6d252e545b";
      sha256 = "06prn5wqq8x225n9wlbyk60f50jyjj8fm2hf181dyqjpf8wq75xa";
    };
    prePatch        = "cd tools; ";
  });

  hashtables = overrideCabal super.hashtables (drv: {
    ## Unmerged.  PR: https://github.com/gregorycollins/hashtables/pull/46
    ## 
    ##     • No instance for (Semigroup Slot)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid Slot’
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "hashtables";
      rev    = "b9eb4b10a50bd6250330422afecc065339a32412";
      sha256 = "0l4nplpvnzzf397zyh7j2k6yiqb46k6bdy00m4zzvhlfp7p1xkaw";
    };
  });

  language-c = overrideCabal super.language-c (drv: {
    ## Unmerged.  PR: https://github.com/visq/language-c/pull/45
    ## 
    ##     Ambiguous occurrence ‘<>’
    ##     It could refer to either ‘Prelude.<>’,
    ##                              imported from ‘Prelude’ at src/Language/C/Pretty.hs:15:8-24
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "language-c";
      rev    = "03b120c64c12946d134017f4922b55c6ab4f52f8";
      sha256 = "1mcv46fq37kkd20rhhdbn837han5knjdsgc7ckqp5r2r9m3vy89r";
    };
    ## /bin/sh: cabal: command not found
    doCheck         = false;
  });

  language-c_0_7_0 = overrideCabal super.language-c_0_7_0 (drv: {
    ## Unmerged.  PR: https://github.com/visq/language-c/pull/45
    ## 
    ##     Ambiguous occurrence ‘<>’
    ##     It could refer to either ‘Prelude.<>’,
    ##                              imported from ‘Prelude’ at src/Language/C/Pretty.hs:15:8-24
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "language-c";
      rev    = "03b120c64c12946d134017f4922b55c6ab4f52f8";
      sha256 = "1mcv46fq37kkd20rhhdbn837han5knjdsgc7ckqp5r2r9m3vy89r";
    };
    ## /bin/sh: cabal: command not found
    doCheck         = false;
  });

  monadplus = overrideCabal super.monadplus (drv: {
    ## Unmerged.  PR: https://github.com/hanshoglund/monadplus/pull/3
    ## 
    ##     • No instance for (Semigroup (Partial a b))
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid (Partial a b)’
    src = pkgs.fetchFromGitHub {
      owner  = "asr";
      repo   = "monadplus";
      rev    = "aa09f2473e2c906f2707b8a3fdb0a087405fd6fb";
      sha256 = "0g37s3rih4i3vrn4kjwj12nq5lkpckmjw33xviva9gly2vg6p3xc";
    };
  });

  reflex = overrideCabal super.reflex (drv: {
    ## Unmerged.  PR: https://github.com/reflex-frp/reflex/pull/158
    ## 
    ##     • Could not deduce (Semigroup (Event t a))
    ##         arising from the superclasses of an instance declaration
    ##       from the context: (Semigroup a, Reflex t)
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "reflex";
      rev    = "4fb50139db45a37493b91973eeaad9885b4c63ca";
      sha256 = "0i7pp6cw394m2vbwcqv9z5ngdarp01sabqr1jkkgchxdkkii94nx";
    };
    ## haddock: internal error: internal: extractDecl (ClsInstD)
    ## CallStack (from HasCallStack):
    ##   error, called at utils/haddock/haddock-api/src/Haddock/Interface/Create.hs:1058:16 in main:Haddock.Interface.Create
    doHaddock       = false;
    ## Setup: Encountered missing dependencies:
    ## base >=4.7 && <4.11, bifunctors >=5.2 && <5.5
    jailbreak       = true;
    ## Setup: Encountered missing dependencies:
    ## data-default -any,
    ## lens -any,
    ## monad-control -any,
    ## prim-uniq -any,
    ## reflection -any,
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [ self.data-default self.haskell-src-exts self.lens self.monad-control self.prim-uniq self.reflection self.split self.template-haskell self.unbounded-delays ];
  });

  regex-tdfa = overrideCabal super.regex-tdfa (drv: {
    ## Unmerged.  PR: https://github.com/ChrisKuklewicz/regex-tdfa/pull/13
    ## 
    ##     • No instance for (Semigroup (CharMap a))
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid (CharMap a)’
    src = pkgs.fetchFromGitHub {
      owner  = "bgamari";
      repo   = "regex-tdfa";
      rev    = "34f4593a520176a917b74b8c7fcbbfbd72fb8178";
      sha256 = "1aiklvf08w1hx2jn9n3sm61mfvdx4fkabszkjliapih2yjpmi3hq";
    };
  });

  securemem = overrideCabal super.securemem (drv: {
    ## Unmerged.  PR: https://github.com/vincenthz/hs-securemem/pull/12
    ## 
    ##     • No instance for (Semigroup SecureMem)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid SecureMem’
    src = pkgs.fetchFromGitHub {
      owner  = "shlevy";
      repo   = "hs-securemem";
      rev    = "6168d90b00bfc6a559d3b9160732343644ef60fb";
      sha256 = "06dhx1z44j5gshpdlsb4aryr3g4was3x4c2sgv1px8j57zrvlypx";
    };
  });

  text-format = overrideCabal super.text-format (drv: {
    ## Unmerged.  PR: https://github.com/bos/text-format/pull/21
    ## 
    ##     • No instance for (Semigroup Format)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid Format’
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "text-format";
      rev    = "a1cda87c222d422816f956c7272e752ea12dbe19";
      sha256 = "0lyrx4l57v15rvazrmw0nfka9iyxs4wyaasjj9y1525va9s1z4fr";
    };
  });

  wl-pprint-text = overrideCabal super.wl-pprint-text (drv: {
    ## Unmerged.  PR: https://github.com/ivan-m/wl-pprint-text/pull/17
    ## 
    ##     Ambiguous occurrence ‘<>’
    ##     It could refer to either ‘PP.<>’,
    ##                              imported from ‘Prelude.Compat’ at Text/PrettyPrint/Leijen/Text/Monadic.hs:73:1-36
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "wl-pprint-text";
      rev    = "615b83d1e5be52d1448aa1ab2517b431a617027b";
      sha256 = "1p67v9s878br0r152h4n37smqhkg78v8zxhf4qm6d035s4rzj76i";
    };
  });


  ## Non-code, configuration-only change

  adjunctions = overrideCabal super.adjunctions (drv: {
    ## Setup: Encountered missing dependencies:
    ## free ==4.*
    jailbreak       = true;
  });

  async = overrideCabal super.async (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.3 && <4.11
    jailbreak       = true;
  });

  bifunctors = overrideCabal super.bifunctors (drv: {
    ## Setup: Encountered missing dependencies:
    ## template-haskell >=2.4 && <2.13
    jailbreak       = true;
  });

  bindings-GLFW = overrideCabal super.bindings-GLFW (drv: {
    ## Setup: Encountered missing dependencies:
    ## template-haskell >=2.10 && <2.13
    jailbreak       = true;
  });

  bytes = overrideCabal super.bytes (drv: {
    ## Setup: Encountered missing dependencies:
    ## ghc >=7.0 && <8.4
    ## /run/current-system/sw/bin/nix-shell: failed to build all dependencies
    doCheck         = false;
  });

  cabal-doctest = overrideCabal super.cabal-doctest (drv: {
    ## Setup: Encountered missing dependencies:
    ## Cabal >=1.10 && <2.1, base >=4.3 && <4.11
    jailbreak       = true;
  });

  ChasingBottoms = overrideCabal super.ChasingBottoms (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.2 && <4.11
    jailbreak       = true;
  });

  comonad = overrideCabal super.comonad (drv: {
    ## Setup: Encountered missing dependencies:
    ## ghc >=7.0 && <8.4
    ## /run/current-system/sw/bin/nix-shell: failed to build all dependencies
    doCheck         = false;
  });

  deepseq-generics = overrideCabal super.deepseq-generics (drv: {
    ## https://github.com/haskell-hvr/deepseq-generics/pull/4
    jailbreak       = true;
  });

  distributive = overrideCabal super.distributive (drv: {
    ## Setup: Encountered missing dependencies:
    ## ghc >=7.0 && <8.4
    ## /run/current-system/sw/bin/nix-shell: failed to build all dependencies
    doCheck         = false;
  });

  exception-transformers = overrideCabal super.exception-transformers (drv: {
    ## Setup: Encountered missing dependencies:
    ## HUnit >=1.2 && <1.6
    jailbreak       = true;
  });

  hashable = overrideCabal super.hashable (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.4 && <4.11
    jailbreak       = true;
  });

  hashable-time = overrideCabal super.hashable-time (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.7 && <4.11
    jailbreak       = true;
  });

  haskell-src-meta = overrideCabal super.haskell-src-meta (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.6 && <4.11, template-haskell >=2.8 && <2.13
    jailbreak       = true;
  });

  integer-logarithms = overrideCabal super.integer-logarithms (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.3 && <4.11
    jailbreak       = true;
  });

  kan-extensions = overrideCabal super.kan-extensions (drv: {
    ## Setup: Encountered missing dependencies:
    ## free ==4.*
    jailbreak       = true;
  });

  keys = overrideCabal super.keys (drv: {
    ## Setup: Encountered missing dependencies:
    ## free ==4.*
    jailbreak       = true;
  });

  lambdacube-gl = overrideCabal super.lambdacube-gl (drv: {
    ## Setup: Encountered missing dependencies:
    ## vector ==0.11.*
    jailbreak       = true;
  });

  lifted-async = overrideCabal super.lifted-async (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    jailbreak       = true;
  });

  linear = overrideCabal super.linear (drv: {
    ## Setup: Encountered missing dependencies:
    ## ghc >=7.0 && <8.4
    ## /run/current-system/sw/bin/nix-shell: failed to build all dependencies
    doCheck         = false;
  });

  newtype-generics = overrideCabal super.newtype-generics (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.6 && <4.11
    jailbreak       = true;
  });

  quickcheck-instances = overrideCabal super.quickcheck-instances (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    jailbreak       = true;
  });

  rapid = overrideCabal super.rapid (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.8 && <4.11
    jailbreak       = true;
  });

  tasty-expected-failure = overrideCabal super.tasty-expected-failure (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    jailbreak       = true;
  });

  tasty-hedgehog = overrideCabal super.tasty-hedgehog (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.8 && <4.11, tasty ==0.11.*
    jailbreak       = true;
  });

  text-lens = overrideCabal super.text-lens (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.9.0.0 && <4.10,
    ## extra >=1.4.10 && <1.5,
    ## hspec >=2.2.4 && <2.3,
    ## lens ==4.14.*
    jailbreak       = true;
  });

  th-abstraction = overrideCabal super.th-abstraction (drv: {
    ## Setup: Encountered missing dependencies:
    ## template-haskell >=2.5 && <2.13
    jailbreak       = true;
  });

  these = overrideCabal super.these (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    jailbreak       = true;
  });

  trifecta = overrideCabal super.trifecta (drv: {
    ## Setup: Encountered missing dependencies:
    ## ghc >=7.0 && <8.4
    ## /run/current-system/sw/bin/nix-shell: failed to build all dependencies
    doCheck         = false;
  });

  unliftio-core = overrideCabal super.unliftio-core (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    jailbreak       = true;
  });

  vector-algorithms = overrideCabal super.vector-algorithms (drv: {
    ##     • Ambiguous type variable ‘mv0’
    doCheck         = false;
  });

  wavefront = overrideCabal super.wavefront (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.8 && <4.11
    jailbreak       = true;
  });
}
