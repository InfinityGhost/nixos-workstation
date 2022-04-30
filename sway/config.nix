{ pkgs, lib, ... }:

with pkgs;

let
  constants = ''
    # Logo key. Use Mod1 for Alt.
    set $mod Mod1

    # Home row direction keys, like vim
    set $left h
    set $down j
    set $up k
    set $right l

    # Terminal emulator
    set $term sakura

    # Application launcher
    # Note: pass the final command to swaymsg so that the resulting window can be opened
    # on the original workspace that the command was run on.
    set $menu ${dmenu}/bin/dmenu_path | ${dmenu}/bin/dmenu -b | xargs swaymsg exec --
  '';

  artwork = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixos-artwork";
    rev = "54164a3d4bb8a3500932a76c2b7ae9593e66116c";
    sha256 = "sha256-Dufnad/0i3XQSCwYs389Seg3kZVFSgfKeui/ne9Lxvo=";
  };

  output = ''
    # Default wallpaper
    output * bg ${artwork}/wallpapers/nix-wallpaper-simple-dark-gray.png fill

    # Gaps
    gaps outer 5
    gaps inner 5

    # Window borders
    client.focused #5e81ac #5e81ac #ffffff
    client.unfocused #00000000 #00000000 #ffffff7f

    # Font
    font pango:Terminus (TTF) 11
  '';

  keybinds = ''
    # Start a terminal
    bindsym $mod+Return exec $term

    # Kill focused window
    bindsym $mod+Shift+q kill
    bindsym $mod+F4 kill

    # Start your launcher
    bindsym $mod+d exec $menu

    # Take a screenshot
    bindsym Print exec ${grim}/bin/grim - | ${wl-clipboard}/bin/wl-copy
    bindsym Shift+Print exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp -d)" - | ${wl-clipboard}/bin/wl-copy

    # Drag floating windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    floating_modifier $mod normal

    # Reload the configuration file
    bindsym $mod+Shift+c reload

    # Exit sway (logs you out of your Wayland session)
    bindsym $mod+Shift+e exec swaymsg exit

    # Volume control
    set $sink alsa_output.pci-0000_00_1b.0.analog-stereo
    bindsym XF86AudioRaiseVolume  ${pulseaudio}/bin/pactl set-sink-volume $sink +10%
    bindsym XF86AudioLowerVolume  ${pulseaudio}/bin/pactl set-sink-volume $sink -10%
    bindsym XF86AudioMute         ${pulseaudio}/bin/pactl set-sink-mute $sink toggle

    # Move your focus around
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
    # Or use $mod+[up|down|left|right]
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # Move the focused window with the same, but add Shift
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
    # Ditto, with arrow keys
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right

    # Switch to workspace
    bindsym $mod+1 workspace 1
    bindsym $mod+2 workspace 2
    bindsym $mod+3 workspace 3
    bindsym $mod+4 workspace 4
    bindsym $mod+5 workspace 5
    bindsym $mod+6 workspace 6
    bindsym $mod+7 workspace 7
    bindsym $mod+8 workspace 8
    bindsym $mod+9 workspace 9
    bindsym $mod+0 workspace "Main"
    bindsym $mod+Control+Left workspace prev
    bindsym $mod+Control+Right workspace next

    # Move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace 1
    bindsym $mod+Shift+2 move container to workspace 2
    bindsym $mod+Shift+3 move container to workspace 3
    bindsym $mod+Shift+4 move container to workspace 4
    bindsym $mod+Shift+5 move container to workspace 5
    bindsym $mod+Shift+6 move container to workspace 6
    bindsym $mod+Shift+7 move container to workspace 7
    bindsym $mod+Shift+8 move container to workspace 8
    bindsym $mod+Shift+9 move container to workspace 9
    bindsym $mod+Shift+0 move container to workspace "Main"

    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+b splith
    bindsym $mod+v splitv

    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle, move position 0 0

    # Swap focus between the tiling area and the floating area
    bindsym $mod+space focus mode_toggle

    # Move focus to the parent container
    bindsym $mod+a focus parent

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show

    # Resizing containers
    mode "resize" {
      bindsym $left resize shrink width 10px
      bindsym $down resize grow height 10px
      bindsym $up resize shrink height 10px
      bindsym $right resize grow width 10px

      bindsym Left resize shrink width 10px
      bindsym Down resize grow height 10px
      bindsym Up resize shrink height 10px
      bindsym Right resize grow width 10px

      # Return to default mode
      bindsym Return mode "default"
      bindsym Escape mode "default"
    }
    bindsym $mod+r mode "resize"
  '';

  # man 5 sway-bar
  statusBar = ''
    bar {
      position top
      status_command "${statusCommand}/bin/swaybar"
      colors {
        statusline #ffffff
        background #00000000
        focused_workspace #5e81ac #5e81ac #ffffff
        inactive_workspace #32323200 #32323200 #5c5c5c
      }
    }
  '';

  statusCommand = pkgs.writers.writeBashBin "swaybar" ''
    function bat() {
      if [ -n "$1" ]; then
        case "$1" in
          "plug")
            acpitool -a | sed 's/.\+\?: \(.\+\?\) /\1/g';;
          "time")
            acpitool -b | sed 's/.\+\? \(.\+\?\)$/\1/g';;
        esac
      else
        acpitool -b | sed 's/.\+\? \(.\+\?%\).\+\?/\1/g'
      fi
    }

    # Clock icon based on hour of day
    function get_clock_style() {
      hr=$(date +"%l" | xargs)
      case $hr in
        1)  echo "🕐";;
        2)  echo "🕑";;
        3)  echo "🕒";;
        4)  echo "🕓";;
        5)  echo "🕔";;
        6)  echo "🕕";;
        7)  echo "🕖";;
        8)  echo "🕗";;
        9)  echo "🕘";;
        10) echo "🕙";;
        11) echo "🕚";;
        12) echo "🕛";;
      esac
    }

    # Battery Icon Style based on plug state
    function get_battery_style() {
      case `bat plug` in
        online)   echo "🔌";;
        off-line) echo "🔋";;
      esac
    }

    function get_ip() {
      ip -o -4 addr list wlp2s0 | awk '{print $4}' | cut -d/ -f1
    }

    function get_battery() {
      echo "$(bat) $(get_battery_style)"
    }

    function get_time() {
      echo "$(date +"%Y-%m-%d %l:%M:%S %p") $(get_clock_style)"
    }

    while true
    do
      echo "$(get_ip) | $(get_battery) | $(get_time)"
      sleep 1s
    done
  '';

in
{
  environment.etc."sway/config".text = builtins.concatStringsSep "\n" [
    constants
    output
    keybinds
    statusBar
  ];
}
