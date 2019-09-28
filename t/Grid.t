use v6;
use NativeCall;
use Test;

use Gnome::Glib::List;
use Gnome::Gtk3::Container;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Grid $g;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $g .= new(:empty);
  isa-ok $g, Gnome::Gtk3::Grid, ".new(:empty)";
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Gtk3::Button $button .= new(:label('press here'));
  $g.gtk-grid-attach( $button, 0, 0, 1, 1);

  my Gnome::Gtk3::Label $label .= new(:text('note'));
  $g.attach-next-to( $label, $button, GTK_POS_RIGHT, 1, 1);

  my Gnome::Gtk3::Label $label-widget .= new(:widget($g.get-child-at( 1, 0)));
  is $label-widget.get-text, 'note', '.gtk-grid-attach() / .attach-next-to()';

  # insert a column. label moves a place to the right
  $g.insert-next-to( $button, GTK_POS_RIGHT);
  $label-widget .= new(:widget($g.get-child-at( 2, 0)));
  is $label-widget.get-text, 'note', '.insert-next-to()';

  $g.set-row-spacing(2);
  is $g.get-row-spacing, 2, '.set-row-spacing() / .get-row-spacing()';

  $g.set-column-spacing(3);
  is $g.get-column-spacing, 3, '.set-column-spacing() / .get-column-spacing()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit from Container', {

  my Gnome::Glib::List $gl .= new(:glist($g.get-children));
  is $gl.g-list-length, 2, '.get-children()';

#note $gl.nth-data(1);
  my Gnome::Gtk3::Label $label-widget .= new(:widget($gl.nth-data-gobject(0)));
  is $label-widget.get-text, 'note', 'text from label';

  $gl.g-list-free;
  $gl = Gnome::Glib::List;
}

#`{{
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