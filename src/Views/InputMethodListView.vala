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

public class InputMethod.InputMethodListView : Gtk.Grid {
    private List<IBus.EngineDesc> engines;
    private string[] _active_engines;
    public string[] active_engines {
        get {
            _active_engines = InputMethod.Plug.ibus_general_settings.get_strv ("preload-engines");
            return _active_engines;
        }
        set {
            InputMethod.Plug.ibus_general_settings.set_strv ("preload-engines", value);
        }
    }
    private string[] engine_names;
    private Gtk.ListBox listbox;

    public InputMethodListView () {
        Object (
            column_spacing: 12,
            row_spacing: 12
        );
    }

    construct {
        // Fetch all available engines
        engines = new IBus.Bus ().list_engines ();

        var display = new Gtk.Frame (null);

        listbox = new Gtk.ListBox ();

        update_im_list ();

        var scroll = new Gtk.ScrolledWindow (null, null);
        scroll.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroll.expand = true;
        scroll.add (listbox);

        var add_button = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.BUTTON);
        add_button.tooltip_text = _("Add…");

        var remove_button = new Gtk.Button.from_icon_name ("list-remove-symbolic", Gtk.IconSize.BUTTON);
        remove_button.tooltip_text = _("Remove");

        var actionbar = new Gtk.ActionBar ();
        actionbar.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
        actionbar.add (add_button);
        actionbar.add (remove_button);

        var grid = new Gtk.Grid ();
        grid.attach (scroll, 0, 0, 1, 1);
        grid.attach (actionbar, 0, 1, 1, 1);

        display.add (grid);
        add (display);

        add_button.clicked.connect (() => {
            var pop = new AddIMPopover (add_button);
            pop.show_all ();
        });

        remove_button.clicked.connect (() => {
            int index = listbox.get_selected_row ().get_index ();
            string[] new_engines = active_engines;
            new_engines[index] = "";
            active_engines = new_engines;
            update_im_list ();
        });
    }

    // From https://github.com/ibus/ibus/blob/master/ui/gtk2/i18n.py#L47-L54
    private string gettext_engine_longname (IBus.EngineDesc engine) {
        string name = engine.name;
        if (name.has_prefix ("xkb:")) {
            return dgettext ("xkeyboard-config", engine.longname);
        }

        string textdomain = engine.textdomain;
        if (textdomain == "") {
            return engine.longname;
        }

        return dgettext (textdomain, engine.longname);
    }

    private void update_im_list () {
        listbox.get_children ().foreach ((listbox_child) => {
            listbox_child.destroy ();
            engine_names = {};
        });

        // Add the language and the name of activated engines
        foreach (var engine in engines) {
            foreach (var active_engine in active_engines) {
                if (engine.name == active_engine) {
                    // From https://github.com/ibus/ibus/blob/master/setup/enginetreeview.py#L155-L156
                    engine_names += "%s - %s".printf (IBus.get_language_name (engine.language),
                                                    gettext_engine_longname (engine));
                }
            }
        }

        foreach (var engine_name in engine_names) {
            var listboxrow = new Gtk.ListBoxRow ();

            var label = new Gtk.Label (engine_name);
            label.margin = 6;
            label.halign = Gtk.Align.START;

            listboxrow.add (label);
            listbox.add (listboxrow);
        }

        listbox.show_all ();
    }
}
