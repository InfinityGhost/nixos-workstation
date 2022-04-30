{ pkgs, ... }:

{
  imports = [
    ../modules/sakura/sakura-config.nix
  ];

  programs.sakura.config = {
    sakura = {
      colorset1_fore = "rgb(192,192,192)";
      colorset1_back = "rgba(0,0,0,0.85)";
      colorset1_curs = "rgb(255,255,255)";
      colorset1_key = "F1";
      colorset2_fore = "rgb(192,192,192)";
      colorset2_back = "rgb(0,0,0)";
      colorset2_curs = "rgb(255,255,255)";
      colorset2_key = "F2";
      colorset3_fore = "rgb(192,192,192)";
      colorset3_back = "rgb(0,0,0)";
      colorset3_curs = "rgb(255,255,255)";
      colorset3_key = "F3";
      colorset4_fore = "rgb(192,192,192)";
      colorset4_back = "rgb(0,0,0)";
      colorset4_curs = "rgb(255,255,255)";
      colorset4_key = "F4";
      colorset5_fore = "rgb(192,192,192)";
      colorset5_back = "rgb(0,0,0)";
      colorset5_curs = "rgb(255,255,255)";
      colorset5_key = "F5";
      colorset6_fore = "rgb(192,192,192)";
      colorset6_back = "rgb(0,0,0)";
      colorset6_curs = "rgb(255,255,255)";
      colorset6_key = "F6";
      last_colorset = 1;
      scroll_lines = 4096;
      font = "Terminus (TTF) 12";
      show_always_first_tab = "No";
      scrollbar = false;
      closebutton = true;
      tabs_on_bottom = false;
      less_questions = false;
      disable_numbered_tabswitch = false;
      use_fading = false;
      scrollable_tabs = true;
      urgent_bell = "Yes";
      audible_bell = "Yes";
      blinking_cursor = "No";
      stop_tab_cycling_at_end_tabs = "No";
      allow_bold = "Yes";
      cursor_type = "VTE_CURSOR_SHAPE_BLOCK";
      word_chars = "-,./?%&#_~:";
      palette = "tango";
      add_tab_accelerator = 5;
      del_tab_accelerator = 5;
      switch_tab_accelerator = 4;
      move_tab_accelerator = 5;
      copy_accelerator = 5;
      scrollbar_accelerator = 5;
      open_url_accelerator = 5;
      font_size_accelerator = 4;
      set_tab_name_accelerator = 5;
      search_accelerator = 5;
      add_tab_key = "T";
      del_tab_key = "W";
      prev_tab_key = "Left";
      next_tab_key = "Right";
      copy_key = "C";
      paste_key = "V";
      scrollbar_key = "S";
      set_tab_name_key = "N";
      search_key = "F";
      increase_font_size_key = "plus";
      decrease_font_size_key = "minus";
      fullscreen_key = "F11";
      set_colorset_accelerator = 5;
      icon_file = "terminal-tango.svg";
    };
  };
}
