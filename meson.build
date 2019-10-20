project('inputmethod', 'vala', 'c', version: '1.0.0')

switchboard_dep = dependency('switchboard-2.0')
ibus_dep = dependency('ibus-1.0')
gettext_name = meson.project_name() + '-plug'

i18n = import('i18n')
add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    language: 'c'
)

if(ibus_dep.version().version_compare('>=1.5.19'))
    add_project_arguments(['--define', 'IBUS_1_5_19'], language: 'vala')
endif

shared_module(meson.project_name(),
    'src/Dialogs/InstallEngineDialog.vala',
    'src/Dialogs/ProgressDialog.vala',
    'src/Installer/aptd-client.vala',
    'src/Installer/InstallList.vala',
    'src/Installer/UbuntuInstaller.vala',
    'src/Views/EnginesListView.vala',
    'src/Views/EnginesRow.vala',
    'src/Views/LanguagesRow.vala',
    'src/Views/SettingsView.vala',
    'src/Widgets/AddEnginesPopover.vala',
    'src/AddEnginesList.vala',
    'src/Plug.vala',
    'src/Utils.vala',
    dependencies: [
        dependency('granite'),
        dependency('gtk+-3.0'),
        ibus_dep,
        switchboard_dep
    ],
    install: true,
    install_dir: join_paths(switchboard_dep.get_pkgconfig_variable('plugsdir'), 'hardware')
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
