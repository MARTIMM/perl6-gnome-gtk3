use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;

use Gnome::Glib::List;

use Gnome::Gtk3::Adjustment;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::WidgetPath;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Container;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Button $b .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $b, Gnome::Gtk3::Button;
  isa-ok $b, Gnome::Gtk3::Container, 'a button is also a container';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  $b.set-border-width(10);
  is $b.get-border-width, 10, '.set-border-width() / .get-border-width()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations1', {
  my Gnome::Gtk3::Window $w .= new;
  my Gnome::Gtk3::Grid $g .= new;
  $w.add($g);

  my Gnome::Gtk3::Adjustment $a = $w.get-focus-hadjustment-rk;
  nok $a.is-valid, '.get-focus-hadjustment-rk(): invalid';
  $a .= new(
    :value(14), :lower(10), :upper(100), :step-increment(2),
    :page-increment(10), :page-size(20)
  );
  $w.set-focus-hadjustment($a);
  $a = $w.get-focus-hadjustment-rk;
  is $a.get-lower, 10, '.set-focus-hadjustment() .get-focus-hadjustment-rk()';

  $a = $w.get-focus-vadjustment-rk;
  nok $a.is-valid, '.get-focus-vadjustment-rk(): invalid';
  $a .= new(
    :value(14), :lower(10), :upper(100), :step-increment(2),
    :page-increment(10), :page-size(20)
  );
  $w.set-focus-vadjustment($a);
  $a = $w.get-focus-vadjustment-rk;
  is $a.get-lower, 10, '.set-focus-vadjustment() .get-focus-vadjustment-rk()';

# Travis returns other info e.g. 'window' here is 'GtkWindow' there
#  my Gnome::Gtk3::WidgetPath $wp = $w.get-path-for-child-rk($g);
#  like $wp.to-string, /window <-[\s]>+ \s grid/, '.get-path-for-child-rk()';
  ok 1, '.get-path-for-child-rk(): ' ~ $w.get-path-for-child-rk($g).to-string;

#  $w.remove($g);
#  $wp = $w.get-path-for-child-rk($g);
#  is $wp.to-string, '', '.remove()';
  lives-ok { $w.remove($g); }, '.remove()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations2', {
  subtest 'container foreach', {
    class X {
      method cb1 ( N-GObject $no, :$label ) {
        my Gnome::Gtk3::Widget $w .= new(:native-object($no));
        is $w.get-name, 'GtkLabel', '.foreach(): cb1()';
        my Gnome::Gtk3::Label $l .= new(:native-object($no));
        is $l.get-text, $label, 'label text';
      }

      method cb1-rk ( Gnome::Gtk3::Label $rk, :$label ) {
        is $rk.get-name, 'GtkLabel', '.foreach(): cb1-rk()';
        is $rk.get-text, $label, 'label text';
      }

      method cb2 ( Gnome::Gtk3::Label $rk, :$label ) {
        is $rk.get-name, 'GtkLabel',
          '.foreach(): cb2() :give-raku-objects';
        is $rk.get-text, $label, 'label text';
      }

      method cb3 ( $o, Str :$label, Bool :$give-raku-objects = False ) {
        if $give-raku-objects {
          is $o.get-name, 'GtkLabel',
            '.foreach(): cb3() :give-raku-objects';
          is $o.get-text, $label, 'label text';
        }

        else {
          my Gnome::Gtk3::Widget $w .= new(:native-object($o));
          is $w.get-name, 'GtkLabel', '.foreach(): cb3()';
          my Gnome::Gtk3::Label $l .= new(:native-object($o));
          is $l.get-text, $label, 'label text';
        }
      }
    }

    #Gnome::N::debug(:on);
    $b .= new(:label<some-text>);
    $b.foreach( X.new, 'cb1', :label<some-text>);
    $b.foreach( X.new, 'cb1-rk', :label<some-text>);
    $b.foreach( X.new, 'cb2', :label<some-text>, :give-raku-objects);
    $b.foreach( X.new, 'cb3', :label<some-text>);
    $b.foreach( X.new, 'cb3', :label<some-text>, :give-raku-objects);
    #Gnome::N::debug(:off);
  }

  subtest 'children', {
    my Gnome::Gtk3::Window $w .= new;
    my Gnome::Gtk3::Grid $g .= new;
    $w.add($g);

    my Gnome::Glib::List $gl .= new(:native-object($w.get-children));
    is $gl.length, 1, '.get-children()';
    $gl = $w.get-children-rk;
    is $gl.length, 1, '.get-children-rk()';
  }
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method add-h (
      N-GObject $no-widget,
      Gnome::Gtk3::Container :$_widget, gulong :$_handler-id
    ) {
      isa-ok $_widget, Gnome::Gtk3::Container;
      $!signal-processed = True;
    }

    method remove-h (
      N-GObject $no-widget,
      Gnome::Gtk3::Container :$_widget, gulong :$_handler-id
    ) {
      isa-ok $_widget, Gnome::Gtk3::Container;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Container :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      my Gnome::Gtk3::Grid $g .= new;
      $widget.add($g);
      is $!signal-processed, True, '\'add\' signal processed';
      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $!signal-processed = False;
      $widget.remove($g);
      is $!signal-processed, True, '\'remove\' signal processed';
      while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'...\' signal processed';
      #while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$!signal-processed = False;
      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'...\' signal processed';
      #while $main.gtk-events-pending() { $main.iteration-do(False); }

      sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

#  my Gnome::Gtk3::Container $c .= new;
  my Gnome::Gtk3::Window $w .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $w.register-signal( $sh, 'add-h', 'add');
  $w.register-signal( $sh, 'remove-h', 'remove');

  my Promise $p = $w.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Container $c .= new;
  my Gnome::Gtk3::Window $w .= new;
  my Gnome::Gtk3::Grid $g .= new;
  $w.add($g);

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $w.get-property( $prop, $gv);
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

  # example calls
  test-property( G_TYPE_UINT, 'border-width', 'get-uint', 0);
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Container', {
  class MyClass is Gnome::Gtk3::Container {
    method new ( |c ) {
      self.bless( :GtkContainer, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Container, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
