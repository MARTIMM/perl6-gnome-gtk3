use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Stack;
use Gnome::Gtk3::StackSidebar;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Stack $s;
my Gnome::Gtk3::StackSidebar $ss;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $ss .= new;
  isa-ok $ss, Gnome::Gtk3::StackSidebar, '.new()';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $s .= new;
  $s.set-name('stacktest');
  $ss.set-stack($s);

  $s .= new(:native-object($ss.get-stack));
  is $s.get-name, 'stacktest', '.set-stack() / .get-stack()';
}

#`{{
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
