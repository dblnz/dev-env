{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    
    # Use zsh as default shell
    shell = "${pkgs.zsh}/bin/zsh";
    
    # Terminal settings
    terminal = "xterm-256color";
    
    # Enable mouse support
    mouse = true;
    
    # Use vi mode
    keyMode = "vi";
    
    # Start window and pane numbering at 1
    baseIndex = 1;
    
    # Renumber windows when one is closed
    #renumberWindows = true;
    
    # Increase scrollback buffer size
    historyLimit = 50000;
    
    # Set prefix key (default is C-b)
    # prefix = "C-a";  # Uncomment to use C-a instead of C-b
    
    # Additional configuration
    extraConfig = ''
      # Enable 24-bit color support
      set-option -ga terminal-overrides ",xterm-256color*:Tc"
      
      # Start pane numbering at 1
      set -g pane-base-index 1
      
      # Set PATH for tmux sessions
      set-environment -g PATH "$PATH:/usr/local/bin"
      
      # Better split commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      
      # Vim-like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Vim-like pane resizing
      bind C-h resize-pane -L 5
      bind C-j resize-pane -D 2
      bind C-k resize-pane -U 2
      bind C-l resize-pane -R 5
      
      # Cycle through panes
      bind o select-pane -t :.+
      bind i select-pane -t :.-
      
      # Quick pane selection
      bind -r Tab select-pane -t :.+
      
      # Reload configuration
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      
      # Copy mode bindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      
      # Don't exit copy mode after selection
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection-no-clear
    '';

    # Plugins
    #plugins = with pkgs.tmuxPlugins; [
    #  sensible
    #  yank
    #  {
    #    plugin = tmux-themepack;
    #    extraConfig = ''
    #      set -g @themepack 'powerline/default/cyan'
    #    '';
    #  }
    #  {
    #    plugin = resurrect;
    #    extraConfig = ''
    #      set -g @resurrect-strategy-nvim 'session'
    #      set -g @resurrect-capture-pane-contents 'on'
    #    '';
    #  }
    #  {
    #    plugin = continuum;
    #    extraConfig = ''
    #      set -g @continuum-restore 'on'
    #      set -g @continuum-save-interval '15'
    #    '';
    #  }
    #];
  };
}
