{pkgs, ...}:
# i have no idea why this works with the imports section
with pkgs; {
  programs.tmux = {
    enable = true;

    sensibleOnTop = true;
    terminal = "xterm-256color";
    mouse = true;
    keyMode = "vi";
    newSession = true;
    baseIndex = 1;
    prefix = "C-Space";

    plugins = [
      tmuxPlugins.catppuccin
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
    ];

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"

      # Put tmux status bar at the top
      set-option -g status-position top

      # PREFIX + [ to enter vi mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Make new windows and panes open in cwd
      bind '"' split-window -v -c '#{pane_current_path}'
      bind % split-window -h -c '#{pane_current_path}'
    '';
  };
}
