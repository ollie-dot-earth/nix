{
  pkgs,
  inputs,
  ...
}:
{
  programs.librewolf = {
    enable = true;
    # package = pkgs.librewolf-bin;
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "middlemouse.paste" = false;
      "general.autoscroll" = true;
      "privacy.resistFingerprinting" = false;
      "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
    };
    languagePacks = [
      "en-GB"
      "nl-nl"
    ];
    profiles.default = {
      containersForce = true;
      search = {
        force = true;
        default = "ddgnoai";
        engines = {
          bing.metaData.hidden = true;
          google.metaData.hidden = true;

          ddgnoai = {
            name = "DuckDuckGo (no AI)";
            icon = "https://duckduckgo.com/favicon.ico";
            urls = [
              {
                template = "https://noai.duckduckgo.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

          };
          nix-packages = {
            name = "Nix Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "nixpkgs" ];
          };
        };
      };
      settings = {
        "extensions.autoDisableScopes" = 0;
        "browser.startup.homepage" = "https://strawmelonjuice.com/startpage/";
        "general.useragent.locale" = "en-GB";
        "browser.newtabpage.pinned" = [
          {
            title = "My home";
            url = "https://strawmelonjuice.com/startpage/";
          }
        ];
      };
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        bitwarden
        # Or it's new contender:
        # heylogin # Not in firefox-addons (yet?)
        pronoundb
        ublock-origin
      ];
    };
  };
}
