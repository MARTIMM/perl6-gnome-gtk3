use v6;

use Gnome::Gtk3::Main;

#-------------------------------------------------------------------------------
unit class ExDND::AppHandlers;

#-------------------------------------------------------------------------------
method run ( ) {
  Gnome::Gtk3::Main.new.main;
}

#-------------------------------------------------------------------------------
method quit ( ) {
  Gnome::Gtk3::Main.new.main-quit;
}
