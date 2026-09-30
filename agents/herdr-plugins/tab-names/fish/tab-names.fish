# herdr tab-names hooks; only active inside herdr (HERDR_ENV=1).
# Source from config.fish or copy to ~/.config/fish/conf.d/.
if test "$HERDR_ENV" = 1
    # Override fish_title: fish 4.x's default emits "[host] cmd ~/c/dir" over ssh,
    # which makes a poor tab label. Command name while running, else the cwd basename.
    function fish_title
        if test -n "$argv[1]"
            set -l cmd (string split ' ' -- $argv[1])[1]
            echo $cmd
        else if test "$PWD" = "$HOME"
            echo '~'
        else
            path basename $PWD
        end
    end

    function __herdr_tab_names_nudge --on-event fish_prompt
        command -q herdr; or return
        command herdr plugin action invoke tab-names.sync >/dev/null 2>&1 </dev/null &
        disown 2>/dev/null
    end
end
