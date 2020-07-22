# Switchboard Input Method Plug

> ### This Component Has Been Deprecated
> The functions provided in this Plug were merged into the official Keyboard Plug. You can now configure input method engines there.

![screenshot](data/Screenshot.png?raw=true)

Switchboard Input Method Plug is an additional Plug for [Switchboard](https://github.com/elementary/switchboard) that allows you to choose, install, and set up input method, which should be useful when you'd like to set up a system that can type Chinese, Japanese, and Korean.

This project tries to address https://github.com/elementary/switchboard-plug-keyboard/issues/22 and https://github.com/bagjunggyu/Input-Method-Tab.

## Installation

### For Users

    sudo add-apt-repository ppa:ryonakaknock3/ele-l10n-cjk
    sudo apt install switchboard-plug-inputmethod

If you have never added a PPA before, you might need to run this command first: 

    sudo apt install software-properties-common

### For Developers

You'll need the following dependencies:

* libgranite-dev
* libgtk-3-dev
* libibus-1.0-dev
* libswitchboard-2.0-dev
* meson
* valac

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    sudo ninja install

## Contributing

There are many ways you can contribute, even if you don't know how to code.

### Reporting Bugs or Suggesting Improvements

Simply [create a new issue](https://github.com/ele-l10n-cjk/switchboard-plug-inputmethod/issues/new) describing your problem and how to reproduce or your suggestion. If you are not used to do, [this section](https://elementary.io/docs/code/reference#reporting-bugs) is for you.

### Writing Some Code

We follow the [coding style of elementary OS](https://elementary.io/docs/code/reference#code-style) and [its Human Interface Guidelines](https://elementary.io/docs/human-interface-guidelines#human-interface-guidelines), please try to respect them.

### Translating This App

I accept translations through Pull Requests. If you're not sure how to do, [the guideline I made](po/README.md) might be helpful.
