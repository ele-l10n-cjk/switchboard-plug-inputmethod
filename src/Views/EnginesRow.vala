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

public class InputMethod.EnginesRow : Gtk.ListBoxRow {
    public bool selected { get; set; }
    public string engine_name { get; construct; }

    public EnginesRow (string engine_name) {
        Object (
            engine_name: engine_name
        );
    }

    construct {
        var label = new Gtk.Label (engine_name);
        label.hexpand = true;
        label.halign = Gtk.Align.START;

        var selection_icon = new Gtk.Image.from_icon_name ("object-select-symbolic", Gtk.IconSize.MENU);
        selection_icon.no_show_all = true;
        selection_icon.visible = false;

        var grid = new Gtk.Grid ();
        grid.column_spacing = 6;
        grid.margin = 3;
        grid.margin_start = 6;
        grid.margin_end = 6;

        grid.add (label);
        grid.add (selection_icon);

        add (grid);

        notify["selected"].connect (() => {
            selection_icon.visible = selected;
        });
    }
}
