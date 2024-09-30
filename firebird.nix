{ buildPecl, lib, fetchFromGitHub, zlib, pkg-config, firebird, firebird_3 }:

buildPecl rec {
  pname = "firebird";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "FirebirdSQL";
    repo = "php-firebird";
    rev = "v${version}";
    sha256 = "sha256-qfxUUvfQXlRe2iHL1VfpQ5Jt+9LBdEoTJpbUy3/xfRI=";
  };

  configureFlags = [
    "--with-zlib-dir=${zlib.dev}"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zlib
    firebird
    firebird_3
  ];

  postInstall = ''
    mv $out/lib/php/extensions/interbase.so $out/lib/php/extensions/firebird.so
  '';

  meta = with lib; {
    description = "Firebird PHP driver, also known as interbase";
    license = licenses.php301;
    homepage = "https://github.com/FirebirdSQL/php-firebird";
    maintainers = teams.php.members;
  };
}
