#!/usr/bin/env sh

sketchybar --add item        cpu.top right                  \
           --set cpu.top     label.font="$FONT:Semibold:7"  \
                             label=CPU                      \
                             icon.drawing=off               \
                             width=15                       \
                             background.padding_right=23    \
                             drawing=off                    \
                                                            \
           --add item        cpu.percent right              \
           --set cpu.percent label.font="$FONT:Heavy:12"    \
                             label=CPU                      \
                             icon.drawing=off               \
                             width=18                       \
                             update_freq=2                  \
                             mach_helper="$HELPER"          \
                             background.padding_right=4     \
                                                            \
           --add graph       cpu.sys right 18               \
           --set cpu.sys     width=0                        \
                             graph.color=$RED               \
                             graph.fill_color=$RED          \
                             label.drawing=off              \
                             icon.drawing=off               \
                             background.padding_right=2     \
                             background.padding_left=2      \
                             background.height=30           \
                             background.drawing=on          \
                             background.color=$TRANSPARENT  \
                                                            \
           --add graph       cpu.user right 18              \
           --set cpu.user    graph.color=$BLUE              \
                             label.drawing=off              \
                             icon.drawing=off               \
                             background.padding_right=2     \
                             background.padding_left=2      \
                             background.height=30           \
                             background.drawing=on          \
                             background.color=$TRANSPARENT
