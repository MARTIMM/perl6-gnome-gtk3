#TL:1:Gnome::Gtk3::ListStore:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ListStore

A list-like data structure that can be used with the B<Gnome::Gtk3::TreeView>

=head1 Description

The B<Gnome::Gtk3::ListStore> object is a list model for use with a B<Gnome::Gtk3::TreeView> widget.  It implements the B<Gnome::Gtk3::TreeModel> interface, and consequentialy, can use all of the methods available there.  It also implements the B<Gnome::Gtk3::TreeSortable> interface so it can be sorted by the view. Finally, it also implements the tree [drag and drop](https://developer.gnome.org/gtk3/3.24/gtk3-GtkTreeView-drag-and-drop.html) interfaces.

The B<Gnome::Gtk3::ListStore> can accept most GObject types as a column type, though it can’t accept all custom types.  Internally, it will keep a copy of data passed in (such as a string or a boxed pointer).  Columns that accept B<GObjects> are handled a little differently.  The B<Gnome::Gtk3::ListStore> will keep a reference to the object instead of copying the value.  As a result, if the object is modified, it is up to the application writer to call C<gtk_tree_model_row_changed()> to emit the  I<row-changed> signal.  This most commonly affects lists with B<Gnome::Gdk3::Pixbufs> stored.

An example for creating a simple list store:

  enum ColumnNames { < COLUMN_STRING COLUMN_INT COLUMN_BOOLEAN > };

  my Gnome::Gtk3::TreePath $path;
  my Gnome::Gtk3::TreeIter $iter;
  my Gnome::Gtk3::ListStore $list-store .= new(
    :field-types( G_TYPE_STRING, G_TYPE_INT, G_TYPE_BOOLEAN)
  );

  # Create 10 entries in the ListStore
  for ^10 -> $i {

    # Get data from somewhere
    my Str $some-data = get-some-data($i);

    # Add a new row to the model
    $iter = $list-store.gtk-list-store-append;
    $list-store.gtk-list-store-set(
      $iter, COLUMN_STRING,   some_data,
             COLUMN_INT,      i,
             COLUMN_BOOLEAN,  0
    );
  }

  # Modify a particular row, here it is the boolean value on the 5th row.
  $path .= new(:string("4"));
  $iter = $list-store.get-iter($path);
  $path.clear-tree-path;
  $list-store.gtk-list-store-set( $iter, COLUMN_BOOLEAN, 1);

=head2 Atomic Operations

It is important to note that only the method C<gtk_list_store_insert_with_values()>

=comment methods C<gtk_list_store_insert_with_values()> and C<gtk_list_store_insert_with_valuesv()> are

is atomic, in the sense that the row is being appended to the store and the values filled in, in a single operation with regard to B<Gnome::Gtk3::TreeModel> signaling. In contrast, using e.g. C<gtk_list_store_append()> and then C<gtk_list_store_set()> will first create a row, which triggers the  I<row-inserted> signal on B<Gnome::Gtk3::ListStore>. The row, however, is still empty, and any signal handler connecting to  I<row-inserted> on this particular store should be prepared for the situation that the row might be empty. This is especially important if you are wrapping the B<Gnome::Gtk3::ListStore> inside a B<Gnome::Gtk3::TreeModelFilter> and are using a B<Gnome::Gtk3::TreeModelFilterVisibleFunc>. Using any of the non-atomic operations to append rows to the B<Gnome::Gtk3::ListStore> will cause the B<Gnome::Gtk3::TreeModelFilterVisibleFunc> to be visited with an empty row first; the function must be prepared for that.


=head2 B<Gnome::Gtk3::ListStore> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::ListStore> implementation of the B<Gnome::Gtk3::Buildable> interface allows to specify the model columns with a <columns> element that may contain multiple <column> elements, each specifying one model column. The “type” attribute specifies the data type for the column.

Additionally, it is possible to specify content for the list store in the UI definition, with the <data> element. It can contain multiple <row> elements, each specifying the content for one row of the list model. Inside a <row>, the <col> elements specify the content for individual cells.

Note that it is probably more common to define your models in the code, and one might consider it a layering violation to specify the content of a list store in a UI definition, data, not presentation, and common wisdom is to separate the two, as far as possible.

An example of a UI Definition fragment for a list store:

  <object class="GtkListStore">
    <columns>
      <column type="gchararray"/>
      <column type="gchararray"/>
      <column type="gint"/>
    </columns>
    <data>
      <row>
        <col id="0">John</col>
        <col id="1">Doe</col>
        <col id="2">25</col>
      </row>
      <row>
        <col id="0">Johan</col>
        <col id="1">Dahlin</col>
        <col id="2">50</col>
      </row>
    </data>
  </object>

As the Raku user can see above, the types are specific to the C implementation while below in the method descriptions type codes are used from B<Gnome::GObject::Type> like G_TYPE_INT. So the above could be better generated by the Glade program.

=head2 Implemented Interfaces

Gnome::Gtk3::ListStore implements
=item [Gnome::Gtk3::Buildable](Buildable.html)
=item [Gnome::Gtk3::TreeModel](TreeModel.html)
=item Gnome::Gtk3::TreeDragSource
=item Gnome::Gtk3::TreeDragDest
=item Gnome::Gtk3::TreeSortable

=head2 See Also

B<Gnome::Gtk3::TreeModel>, B<Gnome::Gtk3::TreeStore>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ListStore;
  also is Gnome::GObject::Object;
  also does Gnome::Gtk3::Buildable;
  also does Gnome::Gtk3::TreeModel;
=comment  also does Gnome::Gtk3::TreeDragSource;
=comment  also does Gnome::Gtk3::TreeDragDest;
=comment  also does Gnome::Gtk3::TreeSortable;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Object;
use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::TreeIter;

use Gnome::Gtk3::Buildable;
use Gnome::Gtk3::TreeModel;
#use Gnome::Gtk3::TreeDragSource;
#use Gnome::Gtk3::TreeDragDest;
#use Gnome::Gtk3::TreeSortable;


#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ListStore:auth<github:MARTIMM>;
also is Gnome::GObject::Object;
also does Gnome::Gtk3::Buildable;
also does Gnome::Gtk3::TreeModel;
#also does Gnome::Gtk3::TreeDragSource;
#also does Gnome::Gtk3::TreeDragDest;
#also does Gnome::Gtk3::TreeSortable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new ListStore object with the given field types.

  multi method new ( Bool :@field-types! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:field-types):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  unless $signals-added {
    # no signals of its own
    $signals-added = True;

    # signals from interfaces
    self._add_tree_model_signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::ListStore';

  # process all named arguments
  if ? %options<field-types> {
    self.set-native-object(gtk_list_store_new(|%options<field-types>));
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
    #TODO get types from columns
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkListStore');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_list_store_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); };
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s = self._buildable_interface($native-sub) unless ?$s;
  $s = self._tree_model_interface($native-sub) unless ?$s;
#  $s = self._tree_drag_store_interface($native-sub) unless ?$s;
#  $s = self._tree_drag_dest_interface($native-sub) unless ?$s;
#  $s = self._tree_sortable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkListStore') if ?$s;
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_list_store_new:new(:field-types)
=begin pod
=head2 [gtk_] list_store_new

Creates a new list store with columns each of the types passed in. Note that only types derived from standard GObject fundamental types are supported.

=comment As an example, C<$ls.gtk_list_store_new( 3, G_TYPE_INT, G_TYPE_STRING, GDK_TYPE_PIXBUF);> will create a new B<Gnome::Gtk3::ListStore> with three columns, of type int, string and B<Gnome::Gdk3::Pixbuf> respectively.

As an example, C<$ls.gtk_list_store_new( G_TYPE_INT, G_TYPE_STRING, G_TYPE_STRING);> will create a new B<Gnome::Gtk3::ListStore> with three columns, of type int, and two of type string respectively.

Returns: a new B<Gnome::Gtk3::ListStore>

  method gtk_list_store_new ( Int $column-type, ... --> N-GObject )

=item Int $column-type; all B<GType> types for the columns, from first to last

=end pod

sub gtk_list_store_new ( *@column-types --> N-GObject ) {

  # arg list starts with n_columns
  my @parameter-list = (
    Parameter.new(type => int32)
  );

  # then n column-types
  for @column-types -> Int $i {
    # all types are int
    @parameter-list.push(Parameter.new(type => uint64));
  }

  # create signature
  my Signature $signature .= new(
    :params(|@parameter-list),
    :returns(N-GObject)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_list_store_new', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f( @column-types.elems, |@column-types)
}

#`{{
#-------------------------------------------------------------------------------
#TM:FF:gtk_list_store_newv:
=begin pod
=head2 [gtk_] list_store_newv

Non-vararg creation function.  Used primarily by language bindings.

Returns: a new B<Gnome::Gtk3::ListStore>

  method gtk_list_store_newv ( *@$types --> N-GObject )

=item Int $n_columns; number of columns in the list store
=item int32 $types; (array length=n_columns): an array of B<GType> types for the columns, from first to last

=end pod

sub gtk_list_store_newv ( *@types --> N-GObject ) {
note "T: ", @types;

  return N-GObject unless ?@types;

  my Int $i = 0;
  my $ntypes = CArray[int32].new(|@types);
  my int32 $nt = $ntypes.elems;
note "nt, $nt: ", $ntypes[0 .. *-1].join(', ');
#N-GObject
  _gtk_list_store_newv( $nt, $ntypes)
}

sub _gtk_list_store_newv ( int32 $n_columns, CArray[int32] $types )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_list_store_newv')
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:FF:gtk_list_store_set_column_types:
=begin pod
=head2 [[gtk_] list_store_] set_column_types

This function is meant primarily for B<GObjects> that inherit from B<Gnome::Gtk3::ListStore>,
and should only be used when constructing a new B<Gnome::Gtk3::ListStore>.  It will not
function after a row has been added, or a method on the B<Gnome::Gtk3::TreeModel>
interface is called.

  method gtk_list_store_set_column_types ( Int $n_columns, int32 $types )

=item Int $n_columns; Number of columns for the list store
=item int32 $types; (array length=n_columns): An array length n of B<GTypes>

=end pod

sub gtk_list_store_set_column_types ( N-GObject $list_store, int32 $n_columns, int32 $types )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_list_store_set_value:
=begin pod
=head2 [[gtk_] list_store_] set_value

Sets the data in the cell specified by I<$iter> and I<$column>. The type of I<$value> must be convertible to the type of the column.

  method gtk_list_store_set_value (
    Gnome::Gtk3::TreeIter $iter, Int $column, Any $value
  )

=item Gnome::Gtk3::TreeIter $iter; A valid B<Gnome::Gtk3::TreeIter> for the row being modified
=item Int $column; column number to modify
=item Any $value; new value for the cell

=end pod

sub gtk_list_store_set_value (
  N-GObject $list_store, N-GtkTreeIter $iter, Int $column, Any $value
) {

  my Gnome::GObject::Type $t .= new;
  my @parameter-list = (
    Parameter.new(type => N-GObject),
    Parameter.new(type => N-GtkTreeIter),
    Parameter.new(type => int32),
    Parameter.new(type => N-GValue)
  );

  my Gnome::GObject::Value $v;
  my $type = gtk_tree_model_get_column_type( $list_store, $column);
  given $type {
    when G_TYPE_OBJECT {
      $v .= new( :$type, :value($value.get-native-object));
    }

    when G_TYPE_BOXED {
      $v .=  new( :$type, :value($value.get-native-boxed));
    }

#    when G_TYPE_POINTER { $p .= new(type => ); }
#    when G_TYPE_PARAM { $p .= new(type => ); }
#    when G_TYPE_VARIANT {$p .= new(type => ); }

    default {
      $v .= new( :$type, :$value);
    }
  }

  # create signature
  my Signature $signature .= new(
    :params(|@parameter-list),
    :returns(int32)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_list_store_set_value', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f( $list_store, $iter, $column, $v.get-native-object);
}

#-------------------------------------------------------------------------------
#TM:0:gtk_list_store_set:
=begin pod
=head2 [gtk_] list_store_set

Sets the value of one or more cells in the row referenced by the iterator. The variable argument list should contain integer column numbers, each column number followed by the value to be set. For example, to set column 0 with type C<G_TYPE_STRING> to “Foo”, you would write C<$ls.gtk_list_store_set( $iter, 0, "Foo")>.

The value will be referenced by the store if it is a C<G_TYPE_OBJECT>, and it will be copied if it is a C<G_TYPE_STRING> or C<G_TYPE_BOXED>.

  method gtk_list_store_set ( Gnome::Gtk3::TreeIter $iter, $col, $val, ... )

=item Gnome::Gtk3::TreeIter $iter; A valid row iterator for the row being modified
=item $col, $val; pairs of column number and value

=end pod

sub gtk_list_store_set (
  N-GObject $list_store, N-GtkTreeIter $iter, *@column-value-list
) {

  die X::Gnome.new(:message('Odd number of items in list: colno, val, ...'))
    unless @column-value-list %% 2;

  my @parameter-list = (
    Parameter.new(type => N-GObject),         # $list_store
    Parameter.new(type => N-GtkTreeIter),     # returned iterator
  );

  my Gnome::GObject::Type $t .= new;
  my @column-values = ();
  my Gnome::GObject::Value $v;
  for @column-value-list -> $c, $value {
    my $type = gtk_tree_model_get_column_type( $list_store, $c);

    @column-values.push: $c;
    given $type {
      when G_TYPE_OBJECT { @column-values.push: $value.get-native-object; }
      when G_TYPE_BOXED { @column-values.push: $value.get-native-object; }

  #    when G_TYPE_POINTER { $p .= new(type => ); }
  #    when G_TYPE_PARAM { $p .= new(type => ); }
  #    when G_TYPE_VARIANT {$p .= new(type => ); }

      default {
        @column-values.push: $value;
      }
    }

    @parameter-list.push: Parameter.new(type => int32);
    @parameter-list.push: $t.get-parameter( $type, :otype($value));
  }

  # to finish the list with -1
  @parameter-list.push: Parameter.new(type => int32);

  # create signature
  my Signature $signature .= new(
    :params( |@parameter-list),
    :returns(int32)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_list_store_set', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f( $list_store, $iter, |@column-values, -1)
}

#`{{
#-------------------------------------------------------------------------------
#TM:FF:gtk_list_store_set_valuesv:
=begin pod
=head2 [[gtk_] list_store_] set_valuesv

A variant of C<gtk_list_store_set_valist()> which
takes the columns and values as two arrays, instead of
varargs. This function is mainly intended for
language-bindings and in case the number of columns to
change is not known until run-time.

Since: 2.12

  method gtk_list_store_set_valuesv ( N-GtkTreeIter $iter, Int $columns, N-GObject $values, Int $n_values )

=item N-GtkTreeIter $iter; A valid B<Gnome::Gtk3::TreeIter> for the row being modified
=item Int $columns; (array length=n_values): an array of column numbers
=item N-GObject $values; (array length=n_values): an array of GValues
=item Int $n_values; the length of the I<columns> and I<values> arrays

=end pod

sub gtk_list_store_set_valuesv ( N-GObject $list_store, N-GtkTreeIter $iter, int32 $columns, N-GObject $values, int32 $n_values )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:FF:gtk_list_store_set_valist:
=begin pod
=head2 [[gtk_] list_store_] set_valist

See C<gtk_list_store_set()>; this version takes a va_list for use by language
bindings.


  method gtk_list_store_set_valist ( N-GtkTreeIter $iter, va_list $var_args )

=item N-GtkTreeIter $iter; A valid B<Gnome::Gtk3::TreeIter> for the row being modified
=item va_list $var_args; va_list of column/value pairs

=end pod

sub gtk_list_store_set_valist ( N-GObject $list_store, N-GtkTreeIter $iter, va_list $var_args )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_list_store_remove:
=begin pod
=head2 [gtk_] list_store_remove

Removes the given row from the list store.  After being removed, the returned iterator is set to be the next valid row, or invalidated if it pointed to the last row in the list_store.

  method gtk_list_store_remove (
    Gnome::Gtk3::TreeIter $iter
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $iter; The iterator pointing to the row which must be removed

=end pod

sub gtk_list_store_remove (
  N-GObject $list_store, N-GtkTreeIter $iter
  --> Gnome::Gtk3::TreeIter
) {
  if _gtk_list_store_remove( $list_store, $iter) {
    Gnome::Gtk3::TreeIter.new(:native-object($iter));
  }

  else {
    Gnome::Gtk3::TreeIter.new(:native-object(N-GtkTreeIter));
  }
}

sub _gtk_list_store_remove ( N-GObject $list_store, N-GtkTreeIter $iter is rw )
  returns int32
  is native(&gtk-lib)
  is symbol('gtk_list_store_remove')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_list_store_insert:
=begin pod
=head2 [gtk_] list_store_insert

Creates a new row at I<$position>. The returned iterator will be changed to point to this new row.  If I<$position> is -1 or is larger than the number of rows on the list, then the new row will be appended to the list. The row will be empty after this function is called.  To fill in values, you need to call C<gtk_list_store_set()> or C<gtk_list_store_set_value()>.

  method gtk_list_store_insert ( Int $position --> Gnome::Gtk3::TreeIter )

=item Int $position; position to insert the new row, or -1 for last

=end pod

sub gtk_list_store_insert (
  N-GObject $list_store, Int $position
  --> Gnome::Gtk3::TreeIter
) {
  my N-GtkTreeIter $iter .= new;
  _gtk_list_store_insert( $list_store, $iter, $position);
  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_list_store_insert (
  N-GObject $list_store, N-GtkTreeIter $iter is rw, int32 $position )
  is native(&gtk-lib)
  is symbol('gtk_list_store_insert')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_list_store_insert_before:
=begin pod
=head2 [[gtk_] list_store_] insert_before

Inserts a new row before I<$sibling>. If I<$sibling> is C<Any>, then the row will be appended to the end of the list. The returned iterator will point to this new row. The row will be empty after this function is called. To fill in values, you need to call C<gtk_list_store_set()> or C<gtk_list_store_set_value()>.

  method gtk_list_store_insert_before (
    Gnome::Gtk3::TreeIter $sibling
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $sibling; A valid iterator or C<Any>

=end pod

# $sibling is untyped to be able to receive Any
sub gtk_list_store_insert_before (
  N-GObject $list_store, $sibling
  --> Gnome::Gtk3::TreeIter
) {
  my N-GtkTreeIter $iter .= new;
  my N-GtkTreeIter $n-sibling = $sibling // N-GtkTreeIter.new;
  _gtk_list_store_insert_before( $list_store, $iter, $sibling);

  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_list_store_insert_before (
  N-GObject $list_store, N-GtkTreeIter $iter is rw, N-GtkTreeIter $sibling
) is native(&gtk-lib)
  is symbol('gtk_list_store_insert_before')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_list_store_insert_after:
=begin pod
=head2 [[gtk_] list_store_] insert_after

Inserts a new row after I<$sibling>. If I<$sibling> is C<Any>, then the row will be prepended to the beginning of the list. The returned iterator will point to this new row. The row will be empty after this function is called. To fill in values, you need to call C<gtk_list_store_set()> or C<gtk_list_store_set_value()>.

  method gtk_list_store_insert_after (
    Gnome::Gtk3::TreeIter $sibling
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $sibling; A valid iterator, or C<Any>

=end pod

# $sibling is untyped to be able to receive Any
sub gtk_list_store_insert_after (
  N-GObject $list_store, $sibling
  --> Gnome::Gtk3::TreeIter
) {
  my N-GtkTreeIter $iter .= new;
  my N-GtkTreeIter $n-sibling = $sibling // N-GtkTreeIter.new;
  _gtk_list_store_insert_after( $list_store, $iter, $sibling);

  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_list_store_insert_after (
  N-GObject $list_store, N-GtkTreeIter $iter, N-GtkTreeIter $sibling
) is native(&gtk-lib)
  is symbol('gtk_list_store_insert_after')
  { * }

#-------------------------------------------------------------------------------
#TM:1::gtk_list_store_insert_with_values
=begin pod
=head2 [[gtk_] list_store_] insert_with_values

Creates a new row at I<position>. I<iter> will be changed to point to this new row. If I<position> is -1, or larger than the number of rows in the list, then the new row will be appended to the list. The row will be filled with the values given to this function.

Calling C<$ls.gtk_list_store_insert_with_values(...)> has the same effect as calling;

  $iter = $ls.gtk-list-store-insert($position);
  $ls.gtk-list-store-set( $iter, ...);

with the difference that the former will only emit a I<row-inserted> signal, while the latter will emit I<row-inserted>, I<row-changed> and, if the list store is sorted, I<rows-reordered>. Since emitting the I<rows-reordered> signal repeatedly can affect the performance of the program, C<gtk_list_store_insert_with_values()> should generally be preferred when inserting rows in a sorted list store.

Since: 2.6

  method gtk_list_store_insert_with_values (
    Int $position, Int $column, $value, ...
    --> Gnome::Gtk3::TreeIter
  )

=item Int $position; row position to insert the new row, or -1 to append after existing rows
=item Int $column, $value, ...; the rest are pairs of column number and value

=end pod

sub gtk_list_store_insert_with_values (
  N-GObject $list_store, int32 $position, *@column-value-list
  --> Gnome::Gtk3::TreeIter
) {

  die X::Gnome.new(:message('Odd number of items in list: colno, val, ...'))
    unless @column-value-list %% 2;

  my @parameter-list = (
    Parameter.new(type => N-GObject),         # $list_store
    Parameter.new(type => N-GtkTreeIter),     # returned iterator
    Parameter.new(type => int32),             # $position
  );

  my Gnome::GObject::Value $v;
  my Gnome::GObject::Type $t .= new;
  my @column-values = ();
  my Int $n-columns = gtk_tree_model_get_n_columns($list_store);

  for @column-value-list -> $c, $value {
    die X::Gnome.new(:message(
      "Column nbr out of range: [0 .. {$n-columns - 1}]")
    ) unless $c < $n-columns;

    # column number
    @column-values.push: $c;

    # column value
    my $type = gtk_tree_model_get_column_type( $list_store, $c);
    given $type {
      when G_TYPE_OBJECT { @column-values.push: $value.get-native-object; }
      when G_TYPE_BOXED { @column-values.push: $value.get-native-object; }

  #    when G_TYPE_POINTER { $p .= new(type => ); }
  #    when G_TYPE_PARAM { $p .= new(type => ); }
  #    when G_TYPE_VARIANT {$p .= new(type => ); }

      default {
        @column-values.push: $value;
      }
    }

    @parameter-list.push: Parameter.new(type => int32);
    @parameter-list.push: $t.get-parameter( $type, :otype($value));
  }

  # to finish the list with -1
  @parameter-list.push: Parameter.new(type => int32);

  # create signature
  my Signature $signature .= new(
    :params( |@parameter-list),
    :returns(int32)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_list_store_insert_with_values', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  my N-GtkTreeIter $ni .= new;
  $f( $list_store, $ni, $position, |@column-values, -1);

  Gnome::Gtk3::TreeIter.new(:native-object($ni))
}

#`{{
#-------------------------------------------------------------------------------
# TM:FF:gtk_list_store_insert_with_valuesv:
=begin pod
=head2 [[gtk_] list_store_] insert_with_valuesv

A variant of C<gtk_list_store_insert_with_values()> which
takes the columns and values as two arrays, instead of
varargs. This function is mainly intended for
language-bindings.

Since: 2.6

  method gtk_list_store_insert_with_valuesv ( N-GtkTreeIter $iter, Int $position, Int $columns, N-GObject $values, Int $n_values )

=item N-GtkTreeIter $iter; (out) (allow-none): An unset B<Gnome::Gtk3::TreeIter> to set to the new row, or C<Any>.
=item Int $position; position to insert the new row, or -1 for last
=item Int $columns; (array length=n_values): an array of column numbers
=item N-GObject $values; (array length=n_values): an array of GValues
=item Int $n_values; the length of the I<columns> and I<values> arrays

=end pod

sub gtk_list_store_insert_with_valuesv ( N-GObject $list_store, N-GtkTreeIter $iter, int32 $position, int32 $columns, N-GObject $values, int32 $n_values )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_list_store_prepend:
=begin pod
=head2 [gtk_] list_store_prepend

Prepends a new row to the list store. The returned iterator will be changed to point to this new row. The row will be empty after this function is called. To fill in values, you need to call C<gtk_list_store_set()> or C<gtk_list_store_set_value()>.

  method gtk_list_store_prepend ( --> Gnome::Gtk3::TreeIter )

=end pod

sub gtk_list_store_prepend ( N-GObject $list_store --> Gnome::Gtk3::TreeIter ) {

  my N-GtkTreeIter $iter .= new;
  _gtk_list_store_prepend( $list_store, $iter);

  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_list_store_prepend ( N-GObject $list_store, N-GtkTreeIter $iter is rw )
  is native(&gtk-lib)
  is symbol('gtk_list_store_prepend')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_list_store_append:
=begin pod
=head2 [gtk_] list_store_append

Appends a new row to the list_store. The returned iterator will be changed to point to this new row. The row will be empty after this function is called.  To fill in values, you need to call C<gtk_list_store_set()> or C<gtk_list_store_set_value()>.

  method gtk_list_store_append ( --> Gnome::Gtk3::TreeIter )

Returns a B<Gnome::Gtk3::TreeIter> pointing to the new row.

=end pod

sub gtk_list_store_append ( N-GObject $list_store --> Gnome::Gtk3::TreeIter ) {

  my N-GtkTreeIter $iter .= new;
  _gtk_list_store_append( $list_store, $iter);

  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_list_store_append ( N-GObject $list_store, N-GtkTreeIter $iter is rw )
  is native(&gtk-lib)
  is symbol('gtk_list_store_append')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_list_store_clear:
=begin pod
=head2 [gtk_] list_store_clear

Removes all rows from the list store.

  method gtk_list_store_clear ( )


=end pod

sub gtk_list_store_clear ( N-GObject $list_store )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_store_iter_is_valid:
=begin pod
=head2 [[gtk_] list_store_] iter_is_valid

WARNING: This function is slow. Only use it for debugging and/or testing purposes.

Checks if the given iter is a valid iter for this list store.

Returns: C<1> if the iter is valid, C<0> if the iter is invalid.

Since: 2.2

  method gtk_list_store_iter_is_valid ( N-GtkTreeIter $iter --> Int  )

=item N-GtkTreeIter $iter; A B<Gnome::Gtk3::TreeIter>.

=end pod

sub gtk_list_store_iter_is_valid ( N-GObject $list_store, N-GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_store_reorder:
=begin pod
=head2 [gtk_] list_store_reorder

Reorders I<store> to follow the order indicated by I<new_order>. Note that
this function only works with unsorted stores.

Since: 2.2

  method gtk_list_store_reorder ( Int $new_order )

=item Int $new_order; (array zero-terminated=1): an array of integers mapping the new position of each child to its old position before the re-ordering, i.e. I<new_order>`[newpos] = oldpos`. It must have exactly as many items as the list store’s length.

=end pod

sub gtk_list_store_reorder ( N-GObject $store, int32 $new_order )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_store_swap:
=begin pod
=head2 [gtk_] list_store_swap

Swaps I<a> and I<b> in I<store>. Note that this function only works with
unsorted stores.

Since: 2.2

  method gtk_list_store_swap ( N-GtkTreeIter $a, N-GtkTreeIter $b )

=item N-GtkTreeIter $a; A B<Gnome::Gtk3::TreeIter>.
=item N-GtkTreeIter $b; Another B<Gnome::Gtk3::TreeIter>.

=end pod

sub gtk_list_store_swap ( N-GObject $store, N-GtkTreeIter $a, N-GtkTreeIter $b )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_store_move_after:
=begin pod
=head2 [[gtk_] list_store_] move_after

Moves I<iter> in I<store> to the position after I<position>. Note that this
function only works with unsorted stores. If I<position> is C<Any>, I<iter>
will be moved to the start of the list.

Since: 2.2

  method gtk_list_store_move_after ( N-GtkTreeIter $iter, N-GtkTreeIter $position )

=item N-GtkTreeIter $iter; A B<Gnome::Gtk3::TreeIter>.
=item N-GtkTreeIter $position; (allow-none): A B<Gnome::Gtk3::TreeIter> or C<Any>.

=end pod

sub gtk_list_store_move_after ( N-GObject $store, N-GtkTreeIter $iter, N-GtkTreeIter $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_store_move_before:
=begin pod
=head2 [[gtk_] list_store_] move_before

Moves I<iter> in I<store> to the position before I<position>. Note that this
function only works with unsorted stores. If I<position> is C<Any>, I<iter>
will be moved to the end of the list.

Since: 2.2

  method gtk_list_store_move_before ( N-GtkTreeIter $iter, N-GtkTreeIter $position )

=item N-GtkTreeIter $iter; A B<Gnome::Gtk3::TreeIter>.
=item N-GtkTreeIter $position; (allow-none): A B<Gnome::Gtk3::TreeIter>, or C<Any>.

=end pod

sub gtk_list_store_move_before ( N-GObject $store, N-GtkTreeIter $iter, N-GtkTreeIter $position )
  is native(&gtk-lib)
  { * }
