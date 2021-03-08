#!/usr/bin/env raku

use v6.d;
#use lib '/home/marcel/Languages/Raku/Projects/gnome-gobject/lib';
#use lib '../gnome-native/lib';
#use lib '../gnome-glib/lib';
use lib '/home/marcel/Languages/Raku/Projects/gnome-gio/lib';
#use lib 'lib';

use NativeCall;

use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::N-GVariant;
use Gnome::Glib::N-GVariantDict;
use Gnome::Glib::N-GVariantType;
use Gnome::Glib::Variant;
use Gnome::Glib::VariantType;
use Gnome::Glib::VariantDict;

#use Gnome::GObject::Value;
#use Gnome::GObject::Type;

use Gnome::Gio::Enums;
#use Gnome::Gio::MenuModel;
use Gnome::Gio::Resource;
#use Gnome::Gio::SimpleAction;
use Gnome::Gio::ApplicationCommandLine;

use Gnome::Gtk3::MenuBar;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;
use Gnome::Gtk3::Builder;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
class AppSignalHandlers:ver<0.4.3> is Gnome::Gtk3::Application {

  constant APP-ID = 'io.github.martimm.tutorial';

  has Str $!app-rbpath;
#  has Gnome::Gtk3::Application $!app;
  has Gnome::Gtk3::Grid $!grid;
#  has Gnome::Gio::MenuModel $!menubar;
  has Gnome::Gtk3::MenuBar $!menubar;
  has Gnome::Gtk3::ApplicationWindow $!app-window;
  has Str $!resource-section = '-';

  #-----------------------------------------------------------------------------
  submethod new ( |c ) {
    self.bless( :GtkApplication, :app-id(APP-ID), |c);
  }

  #-----------------------------------------------------------------------------
  submethod BUILD ( :$!resource-section ) {

    my Gnome::Gio::Resource $r .= new(:load<GResources/Application.gresource>);
    $r.register;

    # startup signal fired after registration; only primary
    self.register-signal( self, 'app-startup', 'startup');

    # fired after g_application_quit
    self.register-signal( self, 'app-shutdown', 'shutdown');

    # fired after g_application_run
    self.register-signal( self, 'app-activate', 'activate');

    #
    self.register-signal( self, 'file-open', 'open');
    self.register-signal( self, 'local-options', 'handle-local-options');
    self.register-signal( self, 'remote-options', 'command-line');
    self.register-signal( self, 'win-add', 'window-added');
    self.register-signal( self, 'win-removed', 'window-removed');

    # set register session property
    #my Gnome::GObject::Value $gv .= new(:init(G_TYPE_BOOLEAN));
    #$gv.set-boolean(True);
    #self.set-property( 'register-session', $gv);
    #self.register-signal( self, 'app-end-session', 'query-end');

    self.set-default;

    # now we can register the application.
    my Gnome::Glib::Error $e = self.register;
    die $e.message if $e.is-valid;
  }

  #-----------------------------------------------------------------------------
  method app-startup ( Gnome::Gtk3::Application :widget($app) ) {
note 'app registered';
#    self.run;
  }

  #-----------------------------------------------------------------------------
  method app-activate ( Gnome::Gtk3::Application :widget($app) ) {
note 'app activated';

    $!app-rbpath = self.get-resource-base-path;

    my Gnome::Gtk3::Builder $builder .= new;
    my Gnome::Glib::Error $e = $builder.add-from-resource(
      "$!app-rbpath/$!resource-section/ApplicationMenu.ui"
    );
    die $e.message if $e.is-valid;

#!!! get/set-app-menu removed from version 4. https://gitlab.gnome.org/GNOME/Initiatives/-/wikis/App-Menu-Retirement
    $!menubar .= new(:build-id<menubar>);
    self.set-menubar($!menubar);

    self!link-menu-action(:action<file-new>);
    self!link-menu-action(:action<file-quit>);
    self!link-menu-action(:action<show-index>);
    self!link-menu-action(:action<show-about>);
    self!link-menu-action(:action<select-compression>, :state<uncompressed>);

    $!app-window .= new(:application(self));
    $!app-window.set-size-request( 600, 400);
    $!app-window.set-title('Application Window Test');
    $!app-window.set-border-width(20);
    $!app-window.register-signal( self, 'exit-program', 'destroy', :win-man);

    # prepare widgets which are directly below window
    $!grid .= new;
    my Gnome::Gtk3::Button $b1 .= new(:label<Stop>);
    $!grid.grid-attach( $b1, 0, 0, 1, 1);
    $b1.register-signal( self, 'exit-program', 'clicked');

    $!app-window.container-add($!grid);
    $!app-window.show-all;

    note "\nInfo:\n  Registered: ", self.get-is-registered;
    note '  resource base path: ', $!app-rbpath;
    note '  app id: ', self.get-application-id;
  }

  #-----------------------------------------------------------------------------
  method !link-menu-action ( Str :$action, Str :$method is copy, Str :$state ) {

    $method //= $action;

    my Gnome::Gio::SimpleAction $menu-entry;
    if ?$state {
      $menu-entry .= new(
        :name($action),
        :parameter-type(Gnome::Glib::VariantType.new(:type-string<s>)),
        :state(Gnome::Glib::Variant.new(:parse("'$state'")))
      );
      $menu-entry.register-signal( self, $method, 'change-state');

    }

    else {
      $menu-entry .= new(
        :name($action),
#        :parameter-type(Gnome::Glib::VariantType.new(:type-string<s>))
      );
      $menu-entry.register-signal( self, $method, 'activate');
    }

    self.add-action($menu-entry);

    #cannot clear -> need to use it in handler!
    $menu-entry.clear-object;
  }

  #-----------------------------------------------------------------------------
  method file-open (
    Pointer $f, Int $nf, Str $hint,
    Gnome::Gtk3::Application :_widget($app)
  ) {
note 'app open: ', $nf;
  }

  #-----------------------------------------------------------------------------
  method local-options (
    N-GVariantDict $nvd,
    Gnome::Gtk3::Application :_widget($app)
    --> Int
  ) {

    # -1 continue app
    # 0 stop with success
    # > 0 stop with failure
    my Int $exit-code = 0;

#    my Gnome::Glib::VariantDict $vd .= new(:native-object($nvd));
#    if $vd.contains('version') or $vd.contains('v') {
#      note 'Version: ', self.ver;
#    }
note 'local options: ', @*ARGS.gist;

    if $*version {
      note "Version of $?CLASS.gist(); {self.^ver}";
    }

    if $*e11 {
      note "Force error 11";
      $exit-code = 11;
    }

    else {
      # continue
      $exit-code = -1;
    }

    $exit-code
  }

  #-----------------------------------------------------------------------------
  method remote-options (
    N-GObject $ncl, Gnome::Gtk3::Application :widget($app) --> Int
  ) {
    my Int $exit-code = 10;
    my Gnome::Gio::ApplicationCommandLine $cl .= new(:native-object($ncl));
#    note 'remote options?; ', $cl.get-is-remote;
#    note 'exit-status: ', $cl.get-exit-status;
    if $cl.get-is-remote {
      $cl.print("asjemenou\n");
      note 'remote arguments: ', $cl.get-arguments.gist;
#      self.release;
      $cl.set-exit-status($exit-code);
    }

    else {
      #self.hold;
      self.activate;
    }

#    state Bool $held = False;
#    if !$held {
#      self.hold;
#      $held = True;
#      $exit-code = 12;
#    }

#    elsif $*rel {
#      $held = False;
#      self.release;
#      $exit-code = 13;
#    }

#    else {
#      $exit-code = 14;
#    }

#    $cl.printerr("error $exit-code\n");
    $exit-code
  }

  #-----------------------------------------------------------------------------
  method app-end-session ( Gnome::Gtk3::Application :widget($app) ) {
note 'session end';
  }

  #-----------------------------------------------------------------------------
  method win-add ( N-GObject $window, Gnome::Gtk3::Application :widget($app) ) {
note 'window added';
  }

  #-----------------------------------------------------------------------------
  method win-removed ( N-GObject $window, Gnome::Gtk3::Application :widget($app) ) {
note 'window removed';
  }

  #-----------------------------------------------------------------------------
  method app-shutdown ( Gnome::Gtk3::Application :widget($app) ) {
note 'app shutdown';
  }

  #-- [button] -----------------------------------------------------------------
  # when triggered by window manager, $win-man is True. Otherwise widget
  # is a button and a label can be retrieved
  method exit-program (
    :$_widget, gulong :$_handler-id, Bool :$win-man = False
  ) {
    note $_widget.get-label unless $win-man;
    self.quit;
  }

  #-- [menu] -------------------------------------------------------------------
  # File > New
  method file-new ( N-GVariant $parameter ) {
    my Gnome::Glib::Variant $v .= new(:native-object($parameter));
    note $v.print() if $v.is-valid;
    note "Select 'New' from 'File' menu";
  }

  # File > Quit
  method file-quit ( N-GVariant $parameter ) {
    note "Select 'Quit' from 'File' menu";
    my Gnome::Glib::Variant $v .= new(:native-object($parameter));
    note $v.print() if $v.is-valid;

    self.quit;
  }

  # File > Compressed
  method select-compression (
    N-GVariant $value,
    Gnome::Gio::SimpleAction :_widget($file-compress-action) is copy,
    N-GObject :_native-object($no)
  ) {
    note 'valid action: ', $file-compress-action.is-valid;
    note 'valid no: ', $no.gist;

    $file-compress-action .= new(:native-object($no))
      unless $file-compress-action.is-valid;

    note "Select 'Compressed' from 'File' menu";
#    note $file-compress-action.get-name;
    my Gnome::Glib::Variant $v .= new(:native-object($value));
    note "Set to $v.print()" if $v.is-valid;

    $file-compress-action.set-state(
      Gnome::Glib::Variant.new(:parse("$v.print()"))
    );
  }

  # Help > Index
  method show-index ( N-GVariant $parameter ) {
    note "Select 'Index' from 'Help' menu";
  }

  # Help > About
  method show-about ( N-GVariant $parameter ) {
    note "Select 'About' from 'Help' menu";
  }
}



#-------------------------------------------------------------------------------
my @*files = ();
my Bool $*version = False;
my Bool $*open = False;
my Bool $*cmd = False;
my Bool $*e11 = False;
my Bool $*rel = False;

my Int $flags = 0;
#$flags +|= G_APPLICATION_HANDLES_OPEN;          # if $*open;
$flags +|= G_APPLICATION_HANDLES_COMMAND_LINE;  # if $*cmd;
$flags +|= G_APPLICATION_SEND_ENVIRONMENT;
# +| G_APPLICATION_NON_UNIQUE),

my AppSignalHandlers $ah .= new(
#  :app-id('io.github.martimm.test.application'),
  :$flags, :resource-section<sceleton>
);

my Int $ec = $ah.run;
note 'exit code: ', $ec;
$ah.clear-object;
exit($ec);
