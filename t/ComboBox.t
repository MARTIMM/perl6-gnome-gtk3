use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ComboBox;

#use Gnome::N::X;
#Gnome::N::debug(:on);


my Gnome::Gtk3::ComboBox $cb .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $cb, Gnome::Gtk3::ComboBox;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $cb.get-has-entry, 0, 'No entries';
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  is $cb.get-active, -1, 'Nothing selected';
}


#`{{

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
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
