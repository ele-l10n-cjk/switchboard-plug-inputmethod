/*
* Copyright (c) 2012-2014 Switchboard Developers (http://launchpad.net/switchboard)
*           (c) 2019 Ryo Nakano
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

public class InputMethod.Plug : Switchboard.Plug {
    private Gtk.Grid content_grid;
    private Gtk.InfoBar infobar;
    public static Settings ibus_general_settings;
    public static Settings ibus_panel_settings;

    public Plug () {
        Object (category: Category.HARDWARE,
                code_name: "hardware-pantheon-inputmethod",
                display_name: _("Input Method"),
                description:_("Configure input method"),
                icon: "preferences-desktop-ims",
                supported_settings: new Gee.TreeMap<string, string?> (null, null));
        supported_settings.set ("wallpaper", null);
    }

    static construct {
        ibus_general_settings = new Settings ("org.freedesktop.ibus.general");
        ibus_panel_settings = new Settings ("org.freedesktop.ibus.panel");
    }

    public override Gtk.Widget get_widget () {
        setup_ui ();
        content_grid.show_all ();

        return content_grid;
    }

    private void setup_ui () {
        if (content_grid != null) {
            return;
        }

        infobar = new Gtk.InfoBar ();
        infobar.message_type = Gtk.MessageType.WARNING;
        infobar.no_show_all = true;
        var content = (Gtk.Container) infobar.get_content_area ();
        var label = new Gtk.Label (_("Some changes will not take effect until you log out"));
        content.add (label);

        var engines_list_view = new InputMethod.EnginesListView ();
        var settings_view = new InputMethod.SettingsView ();

        var main_grid = new Gtk.Grid ();
        main_grid.column_spacing = 12;
        main_grid.row_spacing = 12;
        main_grid.margin = 12;
        main_grid.attach (engines_list_view, 0, 0, 1, 1);
        main_grid.attach (settings_view, 1, 0, 1, 1);

        content_grid = new Gtk.Grid ();
        content_grid.attach (infobar, 0, 0, 1, 1);
        content_grid.attach (main_grid, 0, 1, 1, 1);

        settings_view.on_im_changed.connect (() => {
            infobar.no_show_all = false;
            infobar.show_all ();
        });
    }

    public override void shown () {

    }

    public override void hidden () {

    }

    public override void search_callback (string location) {

    }

    // 'search' returns results like ("Keyboard → Behavior → Duration", "keyboard<sep>behavior")
    public override async Gee.TreeMap<string, string> search (string search) {
        var search_results = new Gee.TreeMap<string, string> ((GLib.CompareDataFunc<string>)strcmp, (Gee.EqualDataFunc<string>)str_equal);
        search_results.set ("%s → %s".printf (display_name, _("Choose preferred input method")), "");
        search_results.set ("%s → %s".printf (display_name, _("Switch engines")), "");
        search_results.set ("%s → %s".printf (display_name, _("Show candidate window")), "");
        return search_results;
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Input Method plug");
    var plug = new InputMethod.Plug ();
    return plug;
}
