/*
* Copyright (c) 2019 Ryo Nakano
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
    public signal void on_im_changed ();

    public SettingsView () {
        Object (
            column_spacing: 12,
            row_spacing: 12,
            hexpand: true,
            halign: Gtk.Align.CENTER
        );
    }

    construct {
        var choose_im_label = new Gtk.Label (_("Choose preferred input method:"));
        choose_im_label.halign = Gtk.Align.END;
        // This line should be removed when the plug supports switching input methods
        choose_im_label.sensitive = false;

        // TODO: Support switching input methods (this combobox is dummy and do nothing now)
        var choose_im_combobox = new Gtk.ComboBoxText ();
        choose_im_combobox.halign = Gtk.Align.START;
        choose_im_combobox.append ("fcitx", _("Fcitx"));
        choose_im_combobox.append ("ibus", _("iBus"));
        choose_im_combobox.active_id = "ibus";
        // The following two lines should be removed when the plug supports switching input methods
        choose_im_combobox.sensitive = false;
        choose_im_combobox.tooltip_text = _("This option is not available yet");

        var keyboard_shortcut_label = new Gtk.Label (_("Switch input method:"));
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
        show_ibus_panel_combobox.active = InputMethod.Plug.ibus_panel_settings.get_int ("show");

        attach (choose_im_label, 0, 0, 1, 1);
        attach (choose_im_combobox, 1, 0, 1, 1);
        attach (keyboard_shortcut_label, 0, 1, 1, 1);
        attach (keyboard_shortcut_combobox, 1, 1, 1, 1);
        attach (show_ibus_panel_label, 0, 2, 1, 1);
        attach (show_ibus_panel_combobox, 1, 2, 1, 1);

        choose_im_combobox.changed.connect (() => {
            on_im_changed ();
        });

        keyboard_shortcut_combobox.changed.connect (() => {
            set_keyboard_shortcut (keyboard_shortcut_combobox.active_id);
        });

        show_ibus_panel_combobox.changed.connect (() => {
            InputMethod.Plug.ibus_panel_settings.set_int ("show", show_ibus_panel_combobox.active);
        });
    }

    private string get_keyboard_shortcut () {
        // TODO: Support getting multiple shortcut keys like ibus-setup does
        string[] keyboard_shortcuts = InputMethod.Plug.ibus_general_settings.get_child ("hotkey").get_strv ("triggers");

        foreach (var ks in keyboard_shortcuts) {
            switch (ks) {
                case "<Alt>space":
                    return "alt-space";
                case "<Shift>space":
                    return "shift-space";
            }
        }

        return "ctl-space";
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
