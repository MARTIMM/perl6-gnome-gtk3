#!/usr/bin/env perl6

use v6;

#my $t0 = now;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
#use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;


# Class to handle signals
class AppSignalHandlers {
#`{{
  # Handle 'Hello World' button click
  method first-button-click ( :widget($b1), :other-button($b2) ) {
    $b1.set-sensitive(False);
    $b2.set-sensitive(True);
  }

  # Handle 'Goodbye' button click
  method second-button-click ( ) {
    $m.gtk-main-quit;
  }
}}
  method exit-program ( ) {
    $m.gtk-main-quit;
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new(:title<Example>);
#`{{
$top-window.set-title('Example');
$top-window.set-border-width(20);

# Create a grid and add it to the window
my Gnome::Gtk3::Grid $grid .= new(:empty);
$top-window.gtk-container-add($grid);

# Create buttons and disable the second one
my Gnome::Gtk3::Button $button .= new(:label('Hello World'));
my Gnome::Gtk3::Button $second .= new(:label('Goodbye'));
$second.set-sensitive(False);

# Add buttons to the grid
$grid.gtk-grid-attach( $button, 0, 0, 1, 1);
$grid.gtk-grid-attach( $second, 0, 1, 1, 1);

}}
# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;

#`{{
$button.register-signal(
  $ash, 'first-button-click', 'clicked',  :other-button($second)
);
$second.register-signal( $ash, 'second-button-click', 'clicked');
}}

$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

#note "Set up time: ", now - $t0;
$m.gtk-main;