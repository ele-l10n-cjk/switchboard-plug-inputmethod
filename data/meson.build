icon_sizes = ['32']

foreach i : icon_sizes
    install_data(
        join_paths('icons', i, 'preferences-desktop-ims.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'elementary', 'categories', i)
    )
endforeach

i18n.merge_file(
    input: 'io.elementary.switchboard.inputmethod.appdata.xml.in',
    output: 'io.elementary.switchboard.inputmethod.appdata.xml',
    po_dir: join_paths(meson.source_root (), 'po', 'extra'),
    install_dir: join_paths(get_option('datadir'), 'metainfo'),
    install: true
)
