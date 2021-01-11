use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::LevelBar;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
  my Gnome::Gtk3::LevelBar $level-bar .= new;
  $level-bar.set-orientation(GTK_ORIENTATION_VERTICAL);
  is GtkOrientation($level-bar.get-orientation), GTK_ORIENTATION_VERTICAL,
     '.set-orientation() / .get-orientation()';
}

#-------------------------------------------------------------------------------

#`{{

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
