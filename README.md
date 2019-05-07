# Switchboard Input Method Plug

![screenshot](data/Screenshot.png?raw=true)

Switchboard Input Method Plug is an additional Plug for [Switchboard](https://github.com/elementary/switchboard) that allows you to choose, install, and set up input method, which should be useful when you'd like to set up a system that can type Chinese, Japanese, and Korean.

This project tries to address https://github.com/elementary/switchboard-plug-keyboard/issues/22 and https://github.com/bagjunggyu/Input-Method-Tab.

## Building and Installation

Because this Plug is not ready for every day use yet, you'll need to install it by building. I'm going to create a PPA to allow you to install it more easily when the Plug is ready.

You'll need the following dependencies:

* libswitchboard-2.0-dev
* libgranite-dev
* libgtk-3-dev
* meson
* valac

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    sudo ninja install
