#TL:1:Gnome::Gtk3::Buildable:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Buildable

Interface for objects that can be built by B<Gnome::Gtk3::Builder>

=head1 Description

B<Gnome::Gtk3::Buildable> allows objects to extend and customize their deserialization from B<Gnome::Gtk3::Builder> UI descriptions. The interface includes methods for setting names and properties of objects, parsing custom tags and constructing child objects.

The B<Gnome::Gtk3::Buildable> interface is implemented by all widgets and many of the non-widget objects that are provided by GTK+. The main user of this interface is B<Gnome::Gtk3::Builder>. There should be very little need for applications to call any of these functions directly.
=comment An object only needs to implement this interface if it needs to extend the B<Gnome::Gtk3::Builder> format or run any extra routines at deserialization time.


=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

#-------------------------------------------------------------------------------
unit role Gnome::Gtk3::Buildable:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#-------------------------------------------------------------------------------
#TM:1:new():interfacing
# interfaces are not instantiated
#submethod BUILD ( *%options ) { }

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
# Hook for modules using this interface. Same principle as _fallback but
# does not need callsame. Also this method must be usable without
# an instanciated object.
method _buildable_interface ( Str $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_buildable_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::("$native-sub"); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s
}


#-------------------------------------------------------------------------------
#TM:1:buildable-get-name:
=begin pod
=head2 buildable-get-name

Gets the name of the I<buildable> object.

B<Gnome::Gtk3::Builder> sets the name based on the B<Gnome::Gtk3::Builder> UI definition used to construct the I<buildable>.

Returns: the name set with C<buildable-set-name()>

  method buildable-get-name ( --> Str )

=end pod

method buildable-get-name ( --> Str ) {

  gtk_buildable_get_name(
    self._f('GtkBuildable'),
  );
}

sub gtk_buildable_get_name ( N-GObject $buildable --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:buildable-set-name:
=begin pod
=head2 buildable-set-name

Sets the name of the I<buildable> object.

  method buildable-set-name ( Str $name )

=item Str $name; name to set

=end pod

method buildable-set-name ( Str $name ) {

  gtk_buildable_set_name(
    self._f('GtkBuildable'), $name
  );
}

sub gtk_buildable_set_name ( N-GObject $buildable, gchar-ptr $name  )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:add-child:
=begin pod
=head2 add-child

Adds a child to I<buildable>. I<type> is an optional string describing how the child should be added.

  method add-child ( N-GObject $builder, N-GObject $child, Str $type )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item N-GObject $child; child to add
=item Str $type; kind of child or C<undefined>

=end pod

method add-child ( $builder, $child, Str $type ) {
  my $nob = $builder;
  $nob .= get-native-object-no-reffing unless $nob ~~ N-GObject;
  my $noc = $child;
  $noc .= get-native-object-no-reffing unless $noc ~~ N-GObject;

  gtk_buildable_add_child( self._f('GtkBuildable'), $nob, $noc, $type);
}

sub gtk_buildable_add_child ( N-GObject $buildable, N-GObject $builder, N-GObject $child, gchar-ptr $type  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:construct-child:
=begin pod
=head2 construct-child

Constructs a child of I<buildable> with the name I<name>.

B<Gnome::Gtk3::Builder> calls this function if a “constructor” has been
specified in the UI definition.

Returns: the constructed child

  method construct-child ( N-GObject $builder, Str $name --> N-GObject )

=item N-GObject $builder; B<Gnome::Gtk3::Builder> used to construct this object
=item Str $name; name of child to construct

=end pod

method construct-child ( $builder, Str $name --> N-GObject ) {
  my $no = $builder;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_buildable_construct_child(
    self._f('GtkBuildable'), $no, $name
  );
}

sub gtk_buildable_construct_child ( N-GObject $buildable, N-GObject $builder, gchar-ptr $name --> N-GObject )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
# TM:0:custom-finished:
=begin pod
=head2 custom-finished

This is similar to C<parser-finished()> but is
called once for each custom tag handled by the I<buildable>.

  method custom-finished ( N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item N-GObject $child; (allow-none): child object or C<undefined> for non-child tags
=item Str $tagname; the name of the tag
=item Pointer $data; user data created in custom-tag-start

=end pod

method custom-finished ( $builder, $child, Str $tagname, Pointer $data ) {
  my $nob = $builder;
  $nob .= get-native-object-no-reffing unless $nob ~~ N-GObject;
  my $noc = $child;
  $noc .= get-native-object-no-reffing unless $noc ~~ N-GObject;

  gtk_buildable_custom_finished(
    self._f('GtkBuildable'), $nob, $noc, $tagname, $data
  );
}

sub gtk_buildable_custom_finished ( N-GObject $buildable, N-GObject $builder, N-GObject $child, gchar-ptr $tagname, gpointer $data  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:custom-tag-end:
=begin pod
=head2 custom-tag-end

This is called at the end of each custom element handled by
the buildable.

  method custom-tag-end (
    N-GObject $builder, N-GObject $child,
    Str $tagname, Pointer $data
  )

=item N-GObject $builder; B<Gnome::Gtk3::Builder> used to construct this object
=item N-GObject $child; (allow-none): child object or C<undefined> for non-child tags
=item Str $tagname; name of tag
=item Pointer $data; (type gpointer): user data that will be passed in to parser functions

=end pod

method custom-tag-end ( $builder, $child, Str $tagname, Pointer $data ) {
  my $nob = $builder;
  $nob .= get-native-object-no-reffing unless $nob ~~ N-GObject;
  my $noc = $child;
  $noc .= get-native-object-no-reffing unless $noc ~~ N-GObject;

  gtk_buildable_custom_tag_end(
    self._f('GtkBuildable'), $nob, $noc, $tagname, $data
  );
}

sub gtk_buildable_custom_tag_end ( N-GObject $buildable, N-GObject $builder, N-GObject $child, gchar-ptr $tagname, gpointer $data  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:custom-tag-start:
=begin pod
=head2 custom-tag-start

This is called for each unknown element under <child>.

Returns: C<True> if a object has a custom implementation, C<False>
if it doesn't.

  method custom-tag-start ( N-GObject $builder, N-GObject $child, Str $tagname, GMarkupParser $parser, Pointer $data --> Int )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder> used to construct this object
=item N-GObject $child; (allow-none): child object or C<undefined> for non-child tags
=item Str $tagname; name of tag
=item GMarkupParser $parser; (out): a B<GMarkupParser> to fill in
=item Pointer $data; (out): return location for user data that will be passed in  to parser functions

=end pod

method custom-tag-start ( $builder, $child, Str $tagname, GMarkupParser $parser, Pointer $data --> Int ) {
  my $no = …;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_buildable_custom_tag_start(
    self._f('GtkBuildable'), $builder, $child, $tagname, $parser, $data
  );
}

sub gtk_buildable_custom_tag_start ( N-GObject $buildable, N-GObject $builder, N-GObject $child, gchar-ptr $tagname, GMarkupParser $parser, gpointer $data --> gboolean )
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
# TM:0:get-internal-child:
=begin pod
=head2 get-internal-child


Get the internal child called I<childname> of the I<buildable> object.

Returns: (transfer none): the internal child of the buildable object



  method get-internal-child ( N-GObject $builder, Str $childname --> N-GObject )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item Str $childname; name of child

=end pod

method get-internal-child ( $builder, Str $childname --> N-GObject ) {
  my $no = $builder;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_buildable_get_internal_child(
    self._f('GtkBuildable'), $no, $childname
  );
}

sub gtk_buildable_get_internal_child ( N-GObject $buildable, N-GObject $builder, gchar-ptr $childname --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:parser-finished:
=begin pod
=head2 parser-finished


Called when the builder finishes the parsing of a
[B<Gnome::Gtk3::Builder> UI definition][BUILDER-UI].
Note that this will be called once for each time
C<gtk-builder-add-from-file()> or C<gtk-builder-add-from-string()>
is called on a builder.

  method parser-finished ( N-GObject $builder )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>

=end pod

method parser-finished ( $builder ) {
  my $no = $builder;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_buildable_parser_finished(
    self._f('GtkBuildable'), $no
  );
}

sub gtk_buildable_parser_finished ( N-GObject $buildable, N-GObject $builder  )
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
# TM:0:set-buildable-property:
=begin pod
=head2 set-buildable-property

Sets the property name I<name> to I<value> on the I<buildable> object.

  method set-buildable-property (
    N-GObject $builder, Str $name, N-GObject $value
  )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item Str $name; name of property
=item N-GObject $value; value of property

=end pod

method set-buildable-property ( $builder, Str $name, $value ) {
  my $no = $builder;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_buildable_set_buildable_property(
    self._f('GtkBuildable'), $no, $name, $value
  );
}

sub gtk_buildable_set_buildable_property ( N-GObject $buildable, N-GObject $builder, gchar-ptr $name, N-GObject $value  )
  is native(&gtk-lib)
  { * }
}}





















=finish
#-------------------------------------------------------------------------------
#TM:1:gtk_buildable_set_name:
=begin pod
=head2 [[gtk_] buildable_set_name

Sets the name of the I<buildable> object.

Since: 2.12

  method gtk_buildable_set_name ( Str $name )

=item Str $name; name to set

=end pod

method buildable-set-name ( Str $name ) {
  my N-GObject $buildable = self.get-native-object-no-reffing;
  gtk_buildable_set_name( $buildable, $name);
}

sub gtk_buildable_set_name ( N-GObject $buildable, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_buildable_get_name:
=begin pod
=head2 [[gtk_] buildable_get_name

Gets the name of the I<buildable> object.

B<Gnome::Gtk3::Builder> sets the name based on the
[B<Gnome::Gtk3::Builder> UI definition][BUILDER-UI]
used to construct the I<buildable>.

Returns: the name set with C<gtk_buildable_set_name()>

Since: 2.12

  method gtk_buildable_get_name ( --> Str  )


=end pod

sub gtk_buildable_get_name ( N-GObject $buildable )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_add_child:
=begin pod
=head2 [[gtk_] buildable_] add_child

Adds a child to I<buildable>. I<type> is an optional string
describing how the child should be added.

Since: 2.12

  method gtk_buildable_add_child ( N-GObject $builder, N-GObject $child, Str $type )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item N-GObject $child; child to add
=item Str $type; (allow-none): kind of child or C<Any>

=end pod

sub gtk_buildable_add_child ( N-GObject $buildable, N-GObject $builder, N-GObject $child, Str $type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_set_buildable_property:
=begin pod
=head2 [[gtk_] buildable_] set_buildable_property

Sets the property name I<name> to I<value> on the I<buildable> object.

Since: 2.12

  method gtk_buildable_set_buildable_property ( N-GObject $builder, Str $name, N-GObject $value )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item Str $name; name of property
=item N-GObject $value; value of property

=end pod

sub gtk_buildable_set_buildable_property ( N-GObject $buildable, N-GObject $builder, Str $name, N-GObject $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_construct_child:
=begin pod
=head2 [[gtk_] buildable_] construct_child

Constructs a child of I<buildable> with the name I<name>.

B<Gnome::Gtk3::Builder> calls this function if a “constructor” has been
specified in the UI definition.

Returns: (transfer full): the constructed child

Since: 2.12

  method gtk_buildable_construct_child ( N-GObject $builder, Str $name --> N-GObject  )

=item N-GObject $builder; B<Gnome::Gtk3::Builder> used to construct this object
=item Str $name; name of child to construct

=end pod

sub gtk_buildable_construct_child ( N-GObject $buildable, N-GObject $builder, Str $name )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_custom_tag_start:
=begin pod
=head2 [[gtk_] buildable_] custom_tag_start

This is called for each unknown element under <child>.

Returns: C<1> if a object has a custom implementation, C<0>
if it doesn't.

Since: 2.12

  method gtk_buildable_custom_tag_start ( N-GObject $builder, N-GObject $child, Str $tagname, GMarkupParser $parser, Pointer $data --> Int  )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder> used to construct this object
=item N-GObject $child; (allow-none): child object or C<Any> for non-child tags
=item Str $tagname; name of tag
=item GMarkupParser $parser; (out): a B<GMarkupParser> to fill in
=item Pointer $data; (out): return location for user data that will be passed in  to parser functions

=end pod

sub gtk_buildable_custom_tag_start ( N-GObject $buildable, N-GObject $builder, N-GObject $child, Str $tagname, GMarkupParser $parser, Pointer $data )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_custom_tag_end:
=begin pod
=head2 [[gtk_] buildable_] custom_tag_end

This is called at the end of each custom element handled by
the buildable.

Since: 2.12

  method gtk_buildable_custom_tag_end ( N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )

=item N-GObject $builder; B<Gnome::Gtk3::Builder> used to construct this object
=item N-GObject $child; (allow-none): child object or C<Any> for non-child tags
=item Str $tagname; name of tag
=item Pointer $data; (type gpointer): user data that will be passed in to parser functions

=end pod

sub gtk_buildable_custom_tag_end ( N-GObject $buildable, N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_custom_finished:
=begin pod
=head2 [[gtk_] buildable_] custom_finished

This is similar to C<gtk_buildable_parser_finished()> but is
called once for each custom tag handled by the I<buildable>.

Since: 2.12

  method gtk_buildable_custom_finished ( N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item N-GObject $child; (allow-none): child object or C<Any> for non-child tags
=item Str $tagname; the name of the tag
=item Pointer $data; user data created in custom_tag_start

=end pod

sub gtk_buildable_custom_finished ( N-GObject $buildable, N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_parser_finished:
=begin pod
=head2 [[gtk_] buildable_] parser_finished

Called when the builder finishes the parsing of a
[B<Gnome::Gtk3::Builder> UI definition][BUILDER-UI].
Note that this will be called once for each time
C<gtk_builder_add_from_file()> or C<gtk_builder_add_from_string()>
is called on a builder.

Since: 2.12

  method gtk_buildable_parser_finished ( N-GObject $builder )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>

=end pod

sub gtk_buildable_parser_finished ( N-GObject $buildable, N-GObject $builder )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_get_internal_child:
=begin pod
=head2 [[gtk_] buildable_] get_internal_child

Get the internal child called I<childname> of the I<buildable> object.

Returns: (transfer none): the internal child of the buildable object

Since: 2.12

  method gtk_buildable_get_internal_child ( N-GObject $builder, Str $childname --> N-GObject  )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item Str $childname; name of child

=end pod

sub gtk_buildable_get_internal_child ( N-GObject $buildable, N-GObject $builder, Str $childname )
  returns N-GObject
  is native(&gtk-lib)
  { * }
