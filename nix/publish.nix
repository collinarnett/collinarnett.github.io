{
  stdenv,
  emacs,
  haskellPackages,
  src,
}:
stdenv.mkDerivation {
  name = "publish-org-roam-site";
  inherit src;

  nativeBuildInputs = [
    emacs
    (haskellPackages.ghcWithPackages (
      hs: with hs; [
        singletons
        singletons-th
      ]
    ))
  ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    ${emacs}/bin/emacs --batch --script ./publish.el
  '';

  installPhase = ''
    cp -r site/ $out
  '';
}
