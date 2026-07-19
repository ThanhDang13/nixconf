{ ... }:
{
  flake.nixosModules.fcitx5 = { pkgs, lib, ... }: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          qt6Packages.fcitx5-unikey
          fcitx5-gtk
          qt6Packages.fcitx5-configtool
        ];

        waylandFrontend = true;
        ignoreUserConfig = true;

        settings = {
          globalOptions = {
            Hotkey = {
              EnumerateWithTriggerKeys = "True";
              EnumerateSkipFirst = "False";

              "TriggerKeys/0" = "Alt+Z";
              "TriggerKeys/1" = "Zenkaku_Hankaku";
              "TriggerKeys/2" = "Hangul";

              "AltTriggerKeys/0" = "Shift_L";

              "EnumerateGroupForwardKeys/0" = "Super+space";
              "EnumerateGroupBackwardKeys/0" = "Shift+Super+space";

              "ActivateKeys/0" = "Hangul_Hanja";
              "DeactivateKeys/0" = "Hangul_Romaja";

              "PrevPage/0" = "Up";
              "NextPage/0" = "Down";
              "PrevCandidate/0" = "Shift+Tab";
              "NextCandidate/0" = "Tab";

              "TogglePreedit/0" = "Control+Alt+P";
            };

            Behavior = {
              ActiveByDefault = "False";
              ShareInputState = "No";
              PreeditEnabledByDefault = "True";
              ShowInputMethodInformation = "False";
              showInputMethodInformationWhenFocusIn = "False";
              CompactInputMethodInformation = "True";
              ShowFirstInputMethodInformation = "False";
              DefaultPageSize = 5;
              OverrideXkbOption = "False";
              PreloadInputMethod = "True";
              AllowInputMethodForPassword = "False";
              ShowPreeditForPassword = "False";
              AutoSavePeriod = 30;
            };
          };

          inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "unikey";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
              Layout = "";
            };
            "Groups/0/Items/1" = {
              Name = "unikey";
              Layout = "";
            };
          };

          addons = {
            classicui.globalSection = {
              PreferTextIcon = "True";
            };

            notifications.globalSection = {
              Enabled = "False";
            };
          };
          
        };
      };
    };

    environment.variables = {
      GTK_IM_MODULE = lib.mkForce "";
    };
  };
}