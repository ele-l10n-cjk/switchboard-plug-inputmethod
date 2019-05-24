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

public class InputMethod.EnginesListView : Gtk.Grid {
    // Stores all installed engines
    private List<IBus.EngineDesc> engines = new IBus.Bus ().list_engines ();

    private Gtk.ListBox listbox;
    private Gtk.Button remove_button;

    public EnginesListView () {
        Object (
            column_spacing: 12,
            row_spacing: 12
        );
    }

    construct {
        var display = new Gtk.Frame (null);

        listbox = new Gtk.ListBox ();

        var scroll = new Gtk.ScrolledWindow (null, null);
        scroll.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroll.expand = true;
        scroll.add (listbox);

        var add_button = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.BUTTON);
        add_button.tooltip_text = _("Add…");

        remove_button = new Gtk.Button.from_icon_name ("list-remove-symbolic", Gtk.IconSize.BUTTON);
        remove_button.tooltip_text = _("Remove");

        update_engines_list ();

        var actionbar = new Gtk.ActionBar ();
        actionbar.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
        actionbar.add (add_button);
        actionbar.add (remove_button);

        var grid = new Gtk.Grid ();
        grid.attach (scroll, 0, 0, 1, 1);
        grid.attach (actionbar, 0, 1, 1, 1);

        display.add (grid);
        add (display);

        var pop = new AddEnginesPopover (add_button);
        add_button.clicked.connect (() => {
            pop.show_all ();
        });

        pop.add_engine.connect ((engine) => {
            string[] new_engine_list = InputMethod.Utils.active_engines;
            new_engine_list += engine;
            InputMethod.Utils.active_engines = new_engine_list;

            update_engines_list ();
            pop.popdown ();
        });

        remove_button.clicked.connect (() => {
            int index = listbox.get_selected_row ().get_index ();

            // Convert to GLib.Array once, because Vala does not support "-=" operator
            Array<string> removed_lists = new Array<string> ();
            foreach (var active_engine in InputMethod.Utils.active_engines) {
                removed_lists.append_val (active_engine);
            }
            // Remove applicable engine from the list
            removed_lists.remove_index (index);

            /*
             * Substitute the contents of removed_lists through another string array,
             * because array concatenation is not supported for public array variables and parameters
             */
            string[] new_engines;
            for (int i = 0; i < removed_lists.length; i++) {
                new_engines += removed_lists.index (i);
            }
            InputMethod.Utils.active_engines = new_engines;
            update_engines_list ();
        });
    }

    private void update_engines_list () {
        // Stores names of currently activated engines
        string[] engine_full_names = {};

        listbox.get_children ().foreach ((listbox_child) => {
            listbox_child.destroy ();
        });

        // Add the language and the name of activated engines
        foreach (var active_engine in InputMethod.Utils.active_engines) {
            foreach (var engine in engines) {
                if (engine.name == active_engine) {
                    engine_full_names += "%s - %s".printf (IBus.get_language_name (engine.language),
                                                    Utils.gettext_engine_longname (engine));
                }
            }
        }

        foreach (var engine_full_name in engine_full_names) {
            var listboxrow = new Gtk.ListBoxRow ();

            var label = new Gtk.Label (engine_full_name);
            label.margin = 6;
            label.halign = Gtk.Align.START;

            listboxrow.add (label);
            listbox.add (listboxrow);
        }

        listbox.show_all ();
        listbox.select_row (listbox.get_row_at_index (0));

        // Update the sensitivity of remove_button depends on whether there are any listboxrow or not
        remove_button.sensitive = (listbox.get_row_at_index (0) == null) ? false : true;
    }
}
