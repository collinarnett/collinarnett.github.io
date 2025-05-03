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
    cat > $out/index.html << EOF
    <!DOCTYPE html>
    <html>
    <head>
    <meta http-equiv="refresh" content="0; url=sitemap.html">
    <title>Redirecting...</title>
    </head>
    <body>
    <p>If you are not redirected automatically, follow this <a href="path/to/your/file.html">link</a>.</p>
    </body>
    </html>
    EOF
  '';
}
