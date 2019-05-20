project('inputmethod', 'vala', 'c', version: '0.1.3')

switchboard_dep = dependency('switchboard-2.0')
gettext_name = meson.project_name() + '-plug'

i18n = import('i18n')
add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    language: 'c'
)

shared_module(meson.project_name(),
    'src/Views/EnginesListView.vala',
    'src/Views/SettingsView.vala',
    'src/Widgets/AddEnginesPopover.vala',
    'src/AddEnginesList.vala',
    'src/InputMethod.vala',
    'src/Utils.vala',
    dependencies: [
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('ibus-1.0'),
        switchboard_dep
    ],
    install: true,
    install_dir: join_paths(switchboard_dep.get_pkgconfig_variable('plugsdir'), 'hardware')
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
