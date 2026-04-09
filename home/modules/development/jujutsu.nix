{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "ollie";
      user.email = "git@ollie.earth";
    };
  };
  programs.jujutsu = {
    enable = true;
    package = pkgs.jujutsu;
    settings = {
      user.name = "ollie";
      user.email = "git@ollie.earth";
      ui.diff-formatter = [
        "difft"
        "--color=always"
        "$left"
        "$right"
      ];
      ui = {
        editor = "nvim";
        streampager.wrapping = "none";
        movement.edit = true;
        default-command = "status";
      };
      aliases = {
        # Moves bookmarks from the previous commit to your current one
        tug = [
          "bookmark"
          "move"
          "--from"
          "heads(::@- & bookmarks())"
          "--to"
          "coalesce(@ & ~empty(), @-)"
        ];
        # JJ tug-push, or JJ teleport or JJ take-and-push whatever is funnier to you.
        tp = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          "jj tug && jj git push"
        ];

        # Bit more history
        log-more = [
          "log"
          "-Tbuiltin_log_compact_full_description"
          "-r"
          "all()"
          "-n30"
          "--reversed"
          "--no-pager"
        ];

        # A compact, reversed log view
        ll = [
          "log"
          "-Tbuiltin_log_compact_full_description"
          "--reversed"
          "--no-pager"
        ];

        # Rebases your active branches onto the main trunk
        catchup = [
          "rebase"
          "-b"
          "bookmarks() & mine() & ~immutable()"
          "-d"
          "trunk()"
          "--skip-emptied"
        ];
        # Lists items with '[TODO]'
        todo-list = [
          "log"
          "-Tbuiltin_log_compact_full_description"
          "-r"
          "all() & description(substring:'[TODO]') & mine()"
          "-n30"
          "--reversed"
          "--no-pager"
        ];
        # Finds the latest '[TODO]' commit and edits it.
        todo-edit-latest = [
          "edit"
          "--ignore-immutable"
          "latest(description(substring:'[TODO]') & mine())"
        ];
        # Toggles '[TODO]' on current commit.
        todo-toggle = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          ''
            CURRENT_MSG=$(jj log -r @ -T 'description' --no-graph)
            if echo "$CURRENT_MSG" | grep -q "^\[TODO\]"; then
              # If it starts with [TODO], strip it and any trailing space
              NEW_MSG=$(echo "$CURRENT_MSG" | sed 's/^\[TODO\] *//')
            else
              # If it doesn't, add it
              NEW_MSG="[TODO] $CURRENT_MSG"
            fi
            jj describe -m "$NEW_MSG"
          ''
        ];

      };
    };

  };

  home.packages = with pkgs; [
    lazyjj
    lazygit
    git
    difftastic
  ];
}
