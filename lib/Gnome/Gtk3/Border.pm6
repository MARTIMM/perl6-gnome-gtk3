#TL:1:Gnome::Gtk3::Border:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Border

=comment ![](images/)

=head1 Description

A struct that specifies a border around a rectangular area
that can be of different width on each side.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Border;
  also is Gnome::GObject::Boxed;

=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Border:auth<github:MARTIMM>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types

=head2 class N-GtkBorder

A struct that specifies a border around a rectangular area
that can be of different width on each side.

=item Int $.left: The width of the left border
=item Int $.right: The width of the right border
=item Int $.top: The width of the top border
=item Int $.bottom: The width of the bottom border

=end pod

#TT:1:N-GtkBorder:
class N-GtkBorder is export is repr('CStruct') {
  has int16 $.left is rw;
  has int16 $.right is rw;
  has int16 $.top is rw;
  has int16 $.bottom is rw;
}

#-------------------------------------------------------------------------------
#has Bool $.border-is-valid = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new plain object.

  multi method new ( )


=head3 :left, :right, :top, :bottom
Create an object and initialize to given values.

  multi method new ( Int :$left!, Int :$right!, Int :$top!, Int :$bottom! )


=head3 :native-object

Create a Border object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GtkBorder :$native-object! )

=begin comment
=head3 :build-id

Create a Border object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end comment

=end pod

#TM:1:new():
#TM:1:new(:border):
#TM:1:new(:left, :right, :top, :bottom):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  if self.^name eq 'Gnome::Gtk3::Border' {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    elsif %options<left>:exists or %options<right>:exists or %options<top>:exists or %options<bottom>:exists {
      my N-GtkBorder $b = _gtk_border_new();
      $b.left = %options<left>;
      $b.right = %options<right>;
      $b.top = %options<top>;
      $b.bottom = %options<bottom>;
      self.set-native-object($b);
    }

    elsif %options.keys.elems {
      die X::Gnome.new(
        :message('Unsupported options for ' ~ self.^name ~
                 ': ' ~ %options.keys.join(', ')
                )
      );
    }

    else {
      self.set-native-object(_gtk_border_new());
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkBorder');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_border_$native-sub"); };
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkBorder');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:left:
=begin pod
=head2 left

Modify left width of border if value is given. Returns left value after modification if any, otherwise the currently set value.

  method left ( Int $value? --> Int )

=end pod

method left ( Int $value? --> Int ) {
  die X::Gnome.new(:message('Cannot set left width, Border is not valid'))
      unless self.is-valid;
  self.get-native-object.left = $value if $value.defined;
  self.get-native-object.left
}

#-------------------------------------------------------------------------------
#TM:1:right:
=begin pod
=head2 right

Modify right width of border if value is given. Returns right value after modification if any, otherwise the currently set value.

  method right ( Int $value? --> Int )

=end pod

method right ( Int $value? --> Int ) {
  die X::Gnome.new(:message('Cannot set right width, Border is not valid'))
      unless self.is-valid;
  self.get-native-object.right = $value if $value.defined;
  self.get-native-object.right
}

#-------------------------------------------------------------------------------
#TM:1:top:
=begin pod
=head2 top

Modify top width of border if value is given. Returns top value after modification if any, otherwise the currently set value.

  method top ( Int $value? --> Int )

=end pod

method top ( Int $value? --> Int ) {
  die X::Gnome.new(:message('Cannot set top width, Border is not valid'))
      unless self.is-valid;
  self.get-native-object.top = $value if $value.defined;
  self.get-native-object.top
}

#-------------------------------------------------------------------------------
#TM:1:bottom:
=begin pod
=head2 bottom

Modify bottom width of border if value is given. Returns bottom value after modification if any, otherwise the currently set value.

  method bottom ( Int $value? --> Int )

=end pod

method bottom ( Int $value? --> Int ) {
  die X::Gnome.new(:message('Cannot set bottom width, Border is not valid'))
      unless self.is-valid;
  self.get-native-object.bottom = $value if $value.defined;
  self.get-native-object.bottom
}

#-------------------------------------------------------------------------------
# ? no ref/unref for a variant type
method native-object-ref ( $n-native-object --> Any ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
#  _g_object_free($n-native-object)
  _gtk_border_free($n-native-object)
}

#-------------------------------------------------------------------------------
#TM:2:gtk_border_new:
#`{{
=begin pod
=head2 [gtk_] border_new

Allocates a new C<Gnome::Gtk3::Border>-struct and initializes its elements to zero.

Returns: a newly allocated C<N-GtkBorder>-struct. Free with C<clear-border()>

Since: 2.14

  method gtk_border_new ( --> N-GtkBorder )

=end pod
}}
sub _gtk_border_new ( )
  returns N-GtkBorder
  is native(&gtk-lib)
  is symbol('gtk_border_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_border_copy:
=begin pod
=head2 [gtk_] border_copy

Copies a C<N-GtkBorder> struct.

Returns: a copy of the native object I<N-GtkBorder>.

  method gtk_border_copy ( --> N-GtkBorder  )

=end pod

sub gtk_border_copy ( N-GtkBorder $border )
  returns N-GtkBorder
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#`{{ No document, user must use clear-border()

=begin pod
=head2 [gtk_] border_free

Frees a C<N-GtkBorder> struct.

  method gtk_border_free ( )

=end pod
}}

sub _gtk_border_free ( N-GtkBorder $border )
  is native(&gtk-lib)
  is symbol('gtk_border_free')
  { * }
