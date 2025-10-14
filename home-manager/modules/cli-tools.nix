{ config, pkgs, lib, ... }:

{
  # Additional CLI tools and their configurations

  # Eza (modern ls replacement)
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
    git = true;
    icons = "auto";
  };

  # Bat (cat with syntax highlighting)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "numbers,changes,header";
    };
  };

  # Zoxide (smarter cd)
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Direnv (per-directory environments)
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Starship prompt (optional modern prompt)
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    
    settings = {
      add_newline = true;
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      
      git_branch = {
        symbol = " ";
      };
      
      git_status = {
        conflicted = "⚔️ ";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = "✅";
        renamed = "👅";
        deleted = "🗑️ ";
      };
    };
  };

  # Htop configuration
  programs.htop = {
    enable = true;
    settings = {
      tree_view = true;
      hide_userland_threads = true;
      show_cpu_frequency = true;
      show_cpu_temperature = true;
    };
  };

  # Bottom (system monitor)
  programs.bottom = {
    enable = true;
  };
}
