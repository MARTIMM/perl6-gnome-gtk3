use v6;
#use NativeCall;
use lib '../gnome-gobject/lib';
#use lib '../gnome-glib/lib';
#use lib '../gnome-native/lib';
use Test;

use Gnome::N::NativeLib;
use Gnome::N::N-GObject;

use Gnome::Glib::Error;
use Gnome::Glib::Quark;

#use Gnome::GObject::Object;
#use Gnome::GObject::Type;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Builder;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Window;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Glib::Quark $quark .= new;
my Gnome::Glib::Error $e;

my Str $ui-file = 't/data/ui.glade';

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  my Gnome::Gtk3::Builder $builder;
  $builder .= new;
  isa-ok $builder, Gnome::Gtk3::Builder, '.new';
}

#-------------------------------------------------------------------------------
subtest 'Add ui from file to builder', {
  my Gnome::Gtk3::Builder $builder .= new;

  $e = $builder.add-from-file($ui-file);
  nok $e.is-valid, ".add-from-file()";

  my Str $text = $ui-file.IO.slurp;
  $e = $builder.add-from-string($text);
  nok $e.is-valid, ".add-from-string()";

  my N-GObject $b = $builder.new-from-string( $text, $text.chars);
  ok $b.defined, '.new-from-string()';

  $b = $builder.new-from-file($ui-file);
  ok $b.defined, '.new-from-file()';
}

#-------------------------------------------------------------------------------
subtest 'Test builder errors', {
  my Gnome::Gtk3::Builder $builder .= new;

  # Get the text glade text again and corrupt it by removing an element
  my Str $text = $ui-file.IO.slurp;
  $text ~~ s/ '<interface>' //;

  subtest "errorcode return from gtk_builder_add_from_file", {
    $e = $builder.add-from-file('x.glade');
    ok $e.is-valid, "error from .add-from-file()";
    ok $e.domain > 0, "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'g-file-error-quark', 'error domain ok';
    is $e.code, 4, 'error code for this error is 4 and is from file IO';
#    is $e.message,
#       'Failed to open file “x.glade”: No such file or directory',
#       $e.message;
  }

  subtest "errorcode return from gtk_builder_add_from_string", {
    my Gnome::Glib::Quark $quark .= new;

    $e = $builder.add-from-string($text);
    ok $e.is-valid, "error from .add-from-string()";
    is $e.domain, $builder.error-quark(), "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'gtk-builder-error-quark',
       "error domain: $quark.to-string($e.domain())";
    is $e.code, GTK_BUILDER_ERROR_UNHANDLED_TAG.value,
       'error code for this error is GTK_BUILDER_ERROR_UNHANDLED_TAG';
#    is $e.message, '<input>:4:40 Unhandled tag: <requires>', $e.message;
  }
}

#-------------------------------------------------------------------------------
subtest 'Test items from ui', {
  my Gnome::Gtk3::Builder $builder .= new;
  $e = $builder.add-from-file($ui-file);
  nok $e.is-valid, ".add-from-file()";

  isa-ok $builder.get-object('my-button-1'), N-GObject, '.get-object()';

  my Gnome::Gtk3::Button $b .= new(:build-id<my-button-1>);
  is $b.get-label, 'button text', '.get-label()';
  is $b.gtk-widget-get-name, 'button-name-1', '.gtk-widget-get-name()';
  is $b.get-border-width, 0, '.get-border-width()';

  #$b.gtk-widget-show;
}

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Main $m .= new;

class X {
  method window-quit ( :$o1, :$o2 --> Int ) {
    is $o1, 'o1', 'option 1 found';
    $m.gtk-main-quit;
    1
  }
}

class Z {
  method button-click ( :$o3, :$o4 --> Int ) {
    is $o3, 'o3', 'option 3 found';
    1
  }
}

class Y {
  method send-signals ( :$widget, :$window, :$button --> Str ) {

    $button.emit-by-name('clicked');
    $window.emit-by-name('destroy');

    return 'done'
  }
}

subtest 'Find signals in ui', {
  my Gnome::Gtk3::Builder $builder .= new;
  $e = $builder.add-from-file('t/data/builder-window-signal.ui');
  nok $e.is-valid, "builder-window-signal.ui added";

  my Gnome::Gtk3::Window $w .= new(:build-id<top>);

  my X $x .= new;
  my Z $z .= new;
  my Hash $handlers = %(
    :window-quit( $x, :o1<o1>, :o2<o2>),
    :button-click( $z, :o3<o3>, :o4<o4>)
  );
#Gnome::N::debug(:on);
  $builder.connect-signals-full($handlers);
#Gnome::N::debug(:off);
  my Promise $p = $builder.start-thread(
    Y.new, 'send-signals', :window($w),
    :button(Gnome::Gtk3::Button.new(:build-id<help>))
  );

  $w.show-all;
  $m.gtk-main;

  is $p.result, 'done', 'exit thread ok';
}

#-------------------------------------------------------------------------------
done-testing;
