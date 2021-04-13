#!/usr/bin/env bash

herbstclient --idle "tag_*" 2>/dev/null | {

    while true; do
        # Read tags into $tags as array
        IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status)"
        {
            for f in "${tags[@]}" ; do
                status+=( ${f:0:1} )
            done
            count=1
            for i in "${tags[@]}" ; do
                # Read the prefix from each tag and render them according to that prefix
                case ${i:0:1} in
                    '#')
                        # the tag is viewed on the focused monitor
                        # TODO Add your formatting tags for focused workspaces
												echo "%{F#6DE879}"
                        ;;
                    ':')
                        # : the tag is not empty
                        # TODO Add your formatting tags for occupied workspaces
												echo "%{F#d8d1c3}"
                        ;;
                    '!')
                        # ! the tag contains an urgent window
                        # TODO Add your formatting tags for workspaces with the urgent hint
												echo "%{F#e8796d}"
                        ;;
                    '-')
                        # - the tag is viewed on a monitor that is not focused
                        # TODO Add your formatting tags for visible but not focused workspaces
												echo "%{F#b3b5d3}"
                        ;;
                    *)
                        # . the tag is empty
                        # There are also other possible prefixes but they won't appear here
                        echo "%{F#6a7066}" # Add your formatting tags for empty workspaces
                        ;;
                esac

                if [ $count -eq 10 ]; then
                    count=0
                fi

                echo "%{A1:herbstclient use $count:} ${i:1} %{A -u -o F- B-}"
                count=$(( count + 1 ))
            done

            echo "%{F-}%{B-}"
        } | tr -d "\n"

    echo

    # wait for next event from herbstclient --idle
    read -r || break
done
} 2>/dev/null