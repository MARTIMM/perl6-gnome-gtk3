use v6;
use NativeCall;
use Test;

#use Gnome::Cairo;
#use Gnome::Cairo::Enums;
use Gnome::Cairo::Types;
use Gnome::Cairo::ImageSurface;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Image;
#use Gnome::Gtk3::EventBox;
use Gnome::Gtk3::Window;

use Gnome::Gdk3::Pixbuf;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Image $i;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $i .= new;
  isa-ok $i, Gnome::Gtk3::Image, ".new";
  is $i.get-storage-type, GTK_IMAGE_EMPTY, '.get-storage-type() empty';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  $i .= new(:file<t/data/Add.png>);
  isa-ok $i, Gnome::Gtk3::Image, ".new(:filename)";
  is $i.get-storage-type, GTK_IMAGE_PIXBUF, '.get-storage-type() pixbuf';

  $i .= new(:file<desktop>);
  is $i.get-storage-type, GTK_IMAGE_ICON_NAME, '.get-storage-type() icon name';

  $i .= new(:file<t/data/Alexis-Kaufman.gif>);
  is $i.get-storage-type, GTK_IMAGE_ANIMATION, '.get-storage-type() animation';

  $i .= new( :icon-name<media-seek-forward>, :size(GTK_ICON_SIZE_DIALOG));
  is $i.get-storage-type, GTK_IMAGE_ICON_NAME, '.new( :icon, :size)';

  $i .= new;
  $i.set-from-file('/data/Add.png');
  is $i.get-storage-type, GTK_IMAGE_ICON_NAME, '.set-from-file() icon name';

  $i .= new;
  $i.set-from-icon-name( 'help-contents', GTK_ICON_SIZE_DIALOG);
  is $i.get-storage-type, GTK_IMAGE_ICON_NAME, '.set-from-icon-name() icon name';


  my Gnome::Cairo::ImageSurface $is .= new(:png<t/data/Add.png>);
  $i .= new(:surface($is));
  is $i.get-storage-type, GTK_IMAGE_SURFACE, '.new(:surface)';

  $i .= new;
  $i.set-from-surface($is);
  is $i.get-storage-type, GTK_IMAGE_SURFACE, '.set-from-surface() surface';

#  $i.clear;
#  is GtkImageType($i.get-storage-type), GTK_IMAGE_EMPTY, '.clear()';

  $i .= new(:file<t/data/Add.png>);
  my Gnome::Gdk3::Pixbuf $pb .= new(:native-object($i.get-pixbuf));
  is $pb.get-width, 16, '.get-pixbuf()';
  my Gnome::Gtk3::Image $i2 .= new(:pixbuf($pb));
  is $i2.get-storage-type, GTK_IMAGE_PIXBUF, '.new(:pixbuf)';
  $i2.clear;
  is $i2.get-storage-type, GTK_IMAGE_EMPTY, '.clear()';

  $i .= new;
  $i.set-from-pixbuf($pb);
  is $i.get-storage-type, GTK_IMAGE_PIXBUF, '.set-from-pixbuf() pixbuf';



  my Gnome::Gtk3::Window $window .= new;
  $window.add($i);
  $i .= new( :icon-name<help-about>, :size(GTK_ICON_SIZE_DIALOG));
  is $i.get-pixel-size, -1, '.get-pixel-size(): default -1';
  $i.set-pixel-size(1);
  is $i.get-pixel-size, 1, '.set-pixel-size() / .get-pixel-size()';

  my List $info = $i.get-icon-name;
  is-deeply $info, ( 'help-about', GTK_ICON_SIZE_INVALID),
            '.get-icon-name()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Image', {
  class MyClass is Gnome::Gtk3::Image {
    method new ( |c ) {
      self.bless( :GtkImage, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Image, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Image $i .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $i.get-property( $prop, $gv);
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
  $i .= new(:file<t/data/Add.png>);
  test-property( G_TYPE_STRING, 'file', 'get-string', 't/data/Add.png');
  $i .= new( :icon-name<help-about>, :size(GTK_ICON_SIZE_DIALOG));
  test-property( G_TYPE_STRING, 'icon-name', 'get-string', 'help-about');
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Image', {
  class MyClass is Gnome::Gtk3::Image {
    method new ( |c ) {
      self.bless( :GtkImage, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Image, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Image $i .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $i.get-property( $prop, $gv);
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
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method ... (
      'any-args',
      Gnome::Gtk3::Image :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Image;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Image :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $widget.emit-by-name(
        'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      );
      is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$!signal-processed = False;
      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }
      sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

  my Gnome::Gtk3::Image $i .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $i.register-signal( $sh, 'method', 'signal');

  my Promise $p = $i.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
