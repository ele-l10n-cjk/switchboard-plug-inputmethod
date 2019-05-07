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
    public InputMethodListView () {
        Object (
            column_spacing: 12,
            row_spacing: 12
        );
    }

    construct {
        var display = new Gtk.Frame (null);

        var cell = new Gtk.CellRendererText ();
        cell.ellipsize_set = true;
        cell.ellipsize = Pango.EllipsizeMode.END;

        var tree = new Gtk.TreeView ();
        tree.insert_column_with_attributes (-1, null, cell, "text", 0);
        tree.headers_visible = false;
        tree.expand = true;
        tree.tooltip_column = 0;

        var scroll = new Gtk.ScrolledWindow (null, null);
        scroll.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroll.expand = true;
        scroll.add (tree);

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
    }
}
