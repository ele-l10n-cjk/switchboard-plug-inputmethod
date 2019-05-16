# Switchboard Input Method Plug

![screenshot](data/Screenshot.png?raw=true)

Switchboard Input Method Plug is an additional Plug for [Switchboard](https://github.com/elementary/switchboard) that allows you to choose, install, and set up input method, which should be useful when you'd like to set up a system that can type Chinese, Japanese, and Korean.

This project tries to address https://github.com/elementary/switchboard-plug-keyboard/issues/22 and https://github.com/bagjunggyu/Input-Method-Tab.

## Installation

### For Users

    sudo add-apt-repository ppa:ryonakaknock3/switchboard-plug-inputmethod
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
