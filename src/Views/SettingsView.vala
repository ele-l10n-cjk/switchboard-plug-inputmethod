/*
* Copyright 2019-2020 Ryo Nakano
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

public class InputMethod.SettingsView : Gtk.Grid {
    public SettingsView () {
        Object (
            column_spacing: 12,
            row_spacing: 12,
            hexpand: true,
            halign: Gtk.Align.CENTER
        );
    }

    construct {
        var keyboard_shortcut_label = new Gtk.Label (_("Switch engines:"));
        keyboard_shortcut_label.halign = Gtk.Align.END;

        var keyboard_shortcut_combobox = new Gtk.ComboBoxText ();
        keyboard_shortcut_combobox.halign = Gtk.Align.START;
        keyboard_shortcut_combobox.append ("alt-space", _("Alt + Space"));
        keyboard_shortcut_combobox.append ("ctl-space", _("Ctrl + Space"));
        keyboard_shortcut_combobox.append ("shift-space", _("Shift + Space"));
        keyboard_shortcut_combobox.active_id = get_keyboard_shortcut ();

        var show_ibus_panel_label = new Gtk.Label (_("Show candidate window:"));
        show_ibus_panel_label.halign = Gtk.Align.END;

        var show_ibus_panel_combobox = new Gtk.ComboBoxText ();
        show_ibus_panel_combobox.halign = Gtk.Align.START;
        show_ibus_panel_combobox.append ("none", _("Do not show"));
        show_ibus_panel_combobox.append ("auto-hide", _("Auto hide"));
        show_ibus_panel_combobox.append ("always-show", _("Always show"));

        var show_system_tray_label = new Gtk.Label (_("Show icon on system tray:"));
        show_system_tray_label.halign = Gtk.Align.END;

        var show_system_tray_switch = new Gtk.Switch ();
        show_system_tray_switch.halign = Gtk.Align.START;

        var embed_preedit_text_label = new Gtk.Label (_("Embed preedit text in application window:"));
        embed_preedit_text_label.halign = Gtk.Align.END;

        var embed_preedit_text_switch = new Gtk.Switch ();
        embed_preedit_text_switch.halign = Gtk.Align.START;

        attach (keyboard_shortcut_label, 0, 0, 1, 1);
        attach (keyboard_shortcut_combobox, 1, 0, 1, 1);
        attach (show_ibus_panel_label, 0, 1, 1, 1);
        attach (show_ibus_panel_combobox, 1, 1, 1, 1);
        attach (show_system_tray_label, 0, 2, 1, 1);
        attach (show_system_tray_switch, 1, 2, 1, 1);
        attach (embed_preedit_text_label, 0, 3, 1, 1);
        attach (embed_preedit_text_switch, 1, 3, 1, 1);

        keyboard_shortcut_combobox.changed.connect (() => {
            set_keyboard_shortcut (keyboard_shortcut_combobox.active_id);
        });

        InputMethod.Plug.ibus_panel_settings.bind ("show", show_ibus_panel_combobox, "active", SettingsBindFlags.DEFAULT);
        InputMethod.Plug.ibus_panel_settings.bind ("show-icon-on-systray", show_system_tray_switch, "active", SettingsBindFlags.DEFAULT);
        InputMethod.Plug.ibus_general_settings.bind ("embed-preedit-text", embed_preedit_text_switch, "active", SettingsBindFlags.DEFAULT);
    }

    private string get_keyboard_shortcut () {
        // TODO: Support getting multiple shortcut keys like ibus-setup does
        string[] keyboard_shortcuts = InputMethod.Plug.ibus_general_settings.get_child ("hotkey").get_strv ("triggers");

        string keyboard_shortcut = "";
        foreach (var ks in keyboard_shortcuts) {
            switch (ks) {
                case "<Alt>space":
                    keyboard_shortcut = "alt-space";
                    break;
                case "<Shift>space":
                    keyboard_shortcut = "shift-space";
                    break;
                case "<Control>space":
                    keyboard_shortcut = "ctl-space";
                    break;
                default:
                    break;
            }
        }

        return keyboard_shortcut;
    }

    private void set_keyboard_shortcut (string combobox_id) {
        // TODO: Support setting multiple shortcut keys like ibus-setup does
        string[] keyboard_shortcuts = {};

        switch (combobox_id) {
            case "alt-space":
                keyboard_shortcuts += "<Alt>space";
                break;
            case "shift-space":
                keyboard_shortcuts += "<Shift>space";
                break;
            default:
                keyboard_shortcuts += "<Control>space";
                break;
        }

        InputMethod.Plug.ibus_general_settings.get_child ("hotkey").set_strv ("triggers", keyboard_shortcuts);
    }
}
