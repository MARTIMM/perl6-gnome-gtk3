use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::ColorChooser;
use Gnome::Gtk3::ColorChooserDialog;
use Gnome::Gtk3::ColorButton;
use Gnome::Gtk3::Enums;


use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ColorChooserDialog $ccd;
#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  $ccd .= new(:title('my color chooser dialog'));
  isa-ok $ccd, Gnome::Gtk3::ColorChooserDialog, '.new(:title)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Interface ColorChooser', {

  $ccd .= new(:title('my color chooser dialog'));
  isa-ok $ccd, Gnome::Gtk3::ColorChooserDialog;
  my Gnome::Gdk3::RGBA $r = $ccd.get-rgba;
  is $r.to-string, 'rgb(255,255,255)', '.get-rgba()';

  $r.gdk-rgba-parse('rgba(0,255,0,0.5)');
  $ccd.set-rgba($r);

  ok $ccd.get-use-alpha, '.get-use-alpha()';
  $ccd.set-use-alpha(False);
  nok $ccd.get-use-alpha, '.set-use-alpha()';

  my Array[N-GdkRGBA] $palette1 .= new(
    N-GdkRGBA.new( :red(.0e0), :green(.0e0), :blue(.0e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.1e0), :green(.1e0), :blue(.1e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.2e0), :green(.2e0), :blue(.2e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.3e0), :green(.3e0), :blue(.3e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.4e0), :green(.4e0), :blue(.4e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.6e0), :green(.6e0), :blue(.6e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.7e0), :green(.7e0), :blue(.7e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.8e0), :green(.8e0), :blue(.8e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.9e0), :green(.9e0), :blue(.9e0), :alpha(.5e0)),
  );

  $ccd.add-palette( GTK_ORIENTATION_HORIZONTAL, 5, 9, $palette1);
  ok 1, '.add-palette(Array[N-GdkRGBA]) didn\'t choke';

  # colors can be Str, Int, Num or Rat as long as it is within 0 ,, 1.
  my Array $palette2 = [
    0, 0, 0, 1,             # color1: red, green, blue, opacity
    .1e0, 0, 0, 1,          # color2: ...
    '0.2', 0, 0, 1,
    0.3, 0, 0, 1,
  ];

  $ccd.add-palette( GTK_ORIENTATION_HORIZONTAL, 2, 4, $palette2);
  ok 1, '.add-palette(Array[Num]) didn\'t choke';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::ColorChooser', {
  class MyClass is Gnome::Gtk3::ColorChooser {
    method new ( |c ) {
      self.bless( :GtkColorChooser, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::ColorChooser, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}
}}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::ColorChooser $cc .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $ccd.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    if $approx {
      is-approx $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }

    # dependency on local settings might result in different values
    elsif $is-local {
      if $gv-value ~~ /$value/ {
        like $gv-value, /$value/, "property $prop, value: " ~ $gv-value;
      }

      else {
        ok 1, "property $prop, value: " ~ $gv-value;
      }
    }

    else {
      is $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }
    $gv.clear-object;
  }

  test-property( G_TYPE_BOOLEAN, 'use-alpha', 'get-boolean', 0);

  # example calls
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
}}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;
  $ccd .= new(:title('my color chooser dialog'));

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method clr-act (
      N-GdkRGBA $color,
      Gnome::Gtk3::ColorChooser :$_widget, gulong :$_handler-id
    ) {

      isa-ok $_widget, Gnome::Gtk3::ColorChooser;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::ColorChooserDialog :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $ccd.emit-by-name(
        'color-activated',
        $widget.get-rgba.get-native-object-no-reffing,
      #  :return-type(int32),
        :parameters([N-GdkRGBA,])
      );
      is $!signal-processed, True, '\'color-activated\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$!signal-processed = False;
      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'...\' signal processed';

      #while $main.gtk-events-pending() { $main.iteration-do(False); }
      #sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

  #my Gnome::Gtk3::ColorChooser $cc .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $ccd.register-signal( $sh, 'clr-act', 'color-activated');

  my Promise $p = $ccd.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    :start-time(now + 0.5)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}


#-------------------------------------------------------------------------------
done-testing;
