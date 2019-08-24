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

public class InputMethod.InstallEngineDialog : Granite.MessageDialog {
    public InstallEngineDialog (Gtk.Window parent) {
        Object (
            primary_text: _("Choose the Engine to Install"),
            secondary_text: _("Select an engine from the list to install and use."),
            image_icon: new ThemedIcon ("dialog-information"),
            transient_for: parent,
            buttons: Gtk.ButtonsType.CANCEL
        );
    }

    construct {
        var engines_list = new Gtk.ListBox ();
        engines_list.activate_on_single_click = true;
        engines_list.expand = true;
        engines_list.selection_mode = Gtk.SelectionMode.NONE;

        foreach (var lang in InstallList.get_all ()) {
            var engine = new EnginesRow (lang.get_name ());
            engines_list.add (engine);
        }

        var back_button = new Gtk.Button.with_label (_("Languages"));
        back_button.halign = Gtk.Align.START;
        back_button.margin = 6;
        back_button.get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);

        var language_title = new Gtk.Label ("");

        var language_header = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        language_header.pack_start (back_button);
        language_header.set_center_widget (language_title);

        var frame = new Gtk.Frame (null);
        frame.margin_top = 24;
        frame.margin_bottom = 24;
        frame.add (engines_list);

        custom_bin.add (frame);

        var install_button = add_button (_("Install"), Gtk.ResponseType.OK);
        install_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        show_all ();

        response.connect ((response_id) => {
            if (response_id == Gtk.ResponseType.OK) {
                // Install the selected engine
            }
        });
    }
}
