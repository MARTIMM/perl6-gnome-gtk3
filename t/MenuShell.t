use v6;
#use lib '../gnome-gobject/lib';
use NativeCall;
use Test;

use Gnome::Gtk3::MenuButton;
use Gnome::Gtk3::MenuShell;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::MenuButton $mb;
my Gnome::Gtk3::MenuShell $ms;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $mb .= new;
  $ms .= new(:native-object($mb));

  isa-ok $ms, Gnome::Gtk3::MenuShell, ".new(:native-object)";
}

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
