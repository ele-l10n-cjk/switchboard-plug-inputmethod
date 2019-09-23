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

public class InputMethod.LanguagesRow : Gtk.ListBoxRow {
    public InputMethod.InstallList language { get; construct; }

    public LanguagesRow (InputMethod.InstallList language) {
        Object (
            language: language
        );
    }

    construct {
        var label = new Gtk.Label (language.get_name ());
        label.hexpand = true;
        label.halign = Gtk.Align.START;

        var caret = new Gtk.Image.from_icon_name ("pan-end-symbolic", Gtk.IconSize.MENU);

        var grid = new Gtk.Grid ();
        grid.margin = 3;
        grid.margin_start = 6;
        grid.margin_end = 6;
        grid.add (label);
        grid.add (caret);

        add (grid);
    }
}
