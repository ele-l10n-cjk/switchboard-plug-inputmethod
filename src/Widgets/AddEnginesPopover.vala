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

public class InputMethod.AddEnginesPopover : Gtk.Popover {
    public signal void add_engine (string new_engine);

    public AddEnginesPopover (Gtk.Widget relative_object) {
        Object (
            relative_to: relative_object
        );
    }

    construct {
        var search_entry = new Gtk.SearchEntry ();
        search_entry.margin = 6;
        ///TRANSLATORS: This text appears in a search entry and tell users to type some search word in order to look for a input method engine which user want to add.
        ///It does not mean search engines in web browsers.
        search_entry.placeholder_text = _("Search engine");

        var liststore = new GLib.ListStore (Type.OBJECT);

        var listbox = new Gtk.ListBox ();

        // TODO: Sort the list by name
        List<IBus.EngineDesc> engines = new IBus.Bus ().list_engines ();

        /*
         * Stores strings used to add/remove engines in the code and won't be shown in the UI.
         * It consists from "<Engine name>",
         * e.g. "mozc-jp" or "libpinyin"
         */
        string[] engine_names;

        /*
         * Stores strings used to show in the UI.
         * It consists from "<Language name> - <Engine name>",
         * e.g. "Japanese - Mozc" or "Chinese - Intelligent Pinyin"
         */
        string[] engine_full_names;

        foreach (var engine in engines) {
            engine_names += engine.name;
            engine_full_names += "%s - %s".printf (IBus.get_language_name (engine.language),
                                                Utils.gettext_engine_longname (engine));
        }

        foreach (var engine_full_name in engine_full_names) {
            liststore.append (new AddEnginesList (engine_full_name));

            var listboxrow = new Gtk.ListBoxRow ();

            var label = new Gtk.Label (engine_full_name);
            label.margin = 6;
            label.halign = Gtk.Align.START;

            listboxrow.add (label);
            listbox.add (listboxrow);
        }

        var scrolled = new Gtk.ScrolledWindow (null, null);
        scrolled.height_request = 300;
        scrolled.width_request = 500;
        scrolled.expand = true;
        scrolled.add (listbox);

        var cancel_button = new Gtk.Button.with_label (_("Cancel"));

        var add_button = new Gtk.Button.with_label (_("Add Engine"));
        add_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        var buttons_grid = new Gtk.Grid ();
        buttons_grid.margin = 6;
        buttons_grid.column_spacing = 6;
        buttons_grid.hexpand = true;
        buttons_grid.halign = Gtk.Align.END;
        buttons_grid.attach (cancel_button, 0, 0, 1, 1);
        buttons_grid.attach (add_button, 1, 0, 1, 1);

        var grid = new Gtk.Grid ();
        grid.margin = 6;
        grid.hexpand = true;
        grid.attach (search_entry, 0, 0, 1, 1);
        grid.attach (scrolled, 0, 1, 1, 1);
        grid.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 2, 1, 1);
        grid.attach (buttons_grid, 0, 3, 1, 1);

        search_entry.grab_focus ();

        add (grid);

        listbox.set_filter_func ((list_box_row) => {
            var item = (AddEnginesList) liststore.get_item (list_box_row.get_index ());
            return search_entry.text.down () in item.list_item.down ();
        });

        search_entry.search_changed.connect (() => {
            listbox.invalidate_filter ();
        });

        cancel_button.clicked.connect (() => {
            popdown ();
        });

        add_button.clicked.connect (() => {
            int index = listbox.get_selected_row ().get_index ();

            // If the engine trying to add is already active, do not add it
            foreach (var active_engine in InputMethod.Utils.active_engines) {
                if (active_engine == engine_names[index]) {
                    popdown ();
                    return;
                }
            }
            add_engine (engine_names[index]);
        });
    }
}