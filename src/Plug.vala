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
    public static Settings ibus_general_settings;
    public static Settings ibus_panel_settings;
    private string _current_input_method;
    public string current_input_method {
        get {
            try {
                // The third line of results of "im-config -m" should be the default input method
                string im_config_result;
                Process.spawn_command_line_sync ("im-config -m", out im_config_result, null, null);
                string[] current_im = im_config_result.split ("\n");
                _current_input_method = current_im[2]; // Fetch the third line
            } catch (SpawnError e) {
                warning (e.message);
                _current_input_method = "unknown";
            }

            return _current_input_method;
        }
    }

    public Installer.UbuntuInstaller installer { get; private set; }
    private ProgressDialog progress_dialog = null;

    public Plug () {
        Object (category: Category.HARDWARE,
                code_name: "io.elementary.switchboard.inputmethod",
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

    construct {
        installer = Installer.UbuntuInstaller.get_default ();
    }

    public override Gtk.Widget get_widget () {
        if (content_grid == null) {
            var engines_list_view = new InputMethod.EnginesListView ();
            var settings_view = new InputMethod.SettingsView ();

            var main_grid = new Gtk.Grid ();
            main_grid.column_spacing = 12;
            main_grid.row_spacing = 12;
            main_grid.margin = 12;
            main_grid.attach (engines_list_view, 0, 0, 1, 1);
            main_grid.attach (settings_view, 1, 0, 1, 1);

            var stack = new Gtk.Stack ();
            stack.add_named (main_grid, "engines_view");
            stack.add_named (unsupported_im_grid (), "unsupported_im_view");
            stack.show_all ();
            stack.visible_child_name = (current_input_method == "ibus") ? "engines_view" : "unsupported_im_view";

            content_grid = new Gtk.Grid ();
            content_grid.attach (stack, 0, 0, 1, 1);
            content_grid.show_all ();

            installer.progress_changed.connect ((progress) => {
                if (progress_dialog != null) {
                    progress_dialog.progress = progress;
                    return;
                }

                progress_dialog = new ProgressDialog ();
                progress_dialog.progress = progress;
                progress_dialog.transient_for = (Gtk.Window) main_grid.get_toplevel ();
                progress_dialog.run ();
                progress_dialog = null;
            });
        }

        return content_grid;
    }

    private Gtk.Grid unsupported_im_grid () {
        var unsupported_warning = new Granite.Widgets.AlertView (
            _("Your Input Method Is Not Supported"),
            _("The default input method of the system is not configurable in this Plug.") + "\n" +
            _("Please make sure you use IBus as a default input method."),
            "dialog-warning"
        );
        unsupported_warning.get_style_context ().remove_class (Gtk.STYLE_CLASS_VIEW);
        unsupported_warning.halign = Gtk.Align.CENTER;
        unsupported_warning.valign = Gtk.Align.CENTER;

        var grid = new Gtk.Grid ();
        grid.attach (unsupported_warning, 0, 0, 1, 1);

        return grid;
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
        search_results.set ("%s → %s".printf (display_name, _("Add engines")), "");
        search_results.set ("%s → %s".printf (display_name, _("Remove engines")), "");
        search_results.set ("%s → %s".printf (display_name, _("Switch engines")), "");
        search_results.set ("%s → %s".printf (display_name, _("Show candidate window")), "");
        search_results.set ("%s → %s".printf (display_name, _("Show icon on system tray")), "");
        return search_results;
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Input Method plug");
    var plug = new InputMethod.Plug ();
    return plug;
}
