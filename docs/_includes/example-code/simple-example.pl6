#!/usr/bin/env raku

use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {
  method exit-program ( ) {
    $m.quit;
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-title('Example');

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;

$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

$m.main;
