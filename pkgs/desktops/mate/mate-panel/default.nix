{ stdenv, fetchurl, pkgconfig, intltool, itstool, glib, dbus_glib, libwnck3, librsvg, libxml2, gnome3, mate, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-panel-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0cz1pfwvsmrjcd0wa83cid9yjcygla6rhigyr7f75d75kiknlcm7";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    dbus_glib
    libwnck3
    librsvg
    libxml2
    gnome3.gtk
    gnome3.dconf
    mate.libmateweather
    mate.mate-desktop
    mate.mate-menus
    hicolor_icon_theme
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  meta = with stdenv.lib; {
    description = "The MATE panel";
    homepage = https://github.com/mate-desktop/mate-panel;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
