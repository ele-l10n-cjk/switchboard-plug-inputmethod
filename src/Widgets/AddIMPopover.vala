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

public class InputMethod.AddIMPopover : Gtk.Popover {
    public AddIMPopover (Gtk.Widget relative_object) {
        Object (
            relative_to: relative_object
        );
    }

    construct {
        var seach_entry = new Gtk.SearchEntry ();
        seach_entry.margin = 6;
        seach_entry.placeholder_text = _("Search input method");

        var listbox = new Gtk.ListBox ();

        // TODO: Sort the list by name
        List<IBus.EngineDesc> engines = new IBus.Bus ().list_engines ();
        string[] engine_names;
        foreach (var engine in engines) {
            engine_names += "%s - %s".printf (IBus.get_language_name (engine.language), get_engine_lognmae (engine));
        }

        foreach (var engine_name in engine_names) {
            var listboxrow = new Gtk.ListBoxRow ();

            var label = new Gtk.Label (engine_name);
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

        var add_button = new Gtk.Button.with_label (_("Add Input Method"));
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
        grid.attach (seach_entry, 0, 0, 1, 1);
        grid.attach (scrolled, 0, 1, 1, 1);
        grid.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 2, 1, 1);
        grid.attach (buttons_grid, 0, 3, 1, 1);

        seach_entry.grab_focus ();

        add (grid);

        cancel_button.clicked.connect (() => {
            popdown ();
        });

        add_button.clicked.connect (() => {
            // TODO: Add input method
        });
    }

    private string get_engine_lognmae (IBus.EngineDesc engine) {
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
}
