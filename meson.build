project('inputmethod', 'vala', 'c', version: '0.1.6')

switchboard_dep = dependency('switchboard-2.0')
ibus_dep = dependency('ibus-1.0')
gettext_name = meson.project_name() + '-plug'

i18n = import('i18n')
add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    language: 'c'
)

vala_args = []
if(ibus_dep.version().version_compare('>=1.5.19'))
    vala_args += ['--define=IBUS_1_5_19']
endif

shared_module(meson.project_name(),
    'src/Views/EnginesListView.vala',
    'src/Views/SettingsView.vala',
    'src/Widgets/AddEnginesPopover.vala',
    'src/AddEnginesList.vala',
    'src/Plug.vala',
    'src/Utils.vala',
    vala_args,
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
