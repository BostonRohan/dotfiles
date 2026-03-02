#!/usr/bin/env sh

SPACE_ICONS=("1" "2" "3" "4")

sketchybar --add event aerospace_workspace_change

sid=0
for i in "${!SPACE_ICONS[@]}"; do
  sid=$(($i + 1))
  sketchybar --add item       space.$sid left                               \
             --subscribe      space.$sid aerospace_workspace_change          \
             --set            space.$sid                                     \
                              icon=${SPACE_ICONS[i]}                         \
                              icon.font="$FONT:Bold:14.0"                    \
                              icon.padding_left=22                           \
                              icon.padding_right=22                          \
                              label.padding_right=33                         \
                              icon.highlight_color=$RED                      \
                              background.height=30                           \
                              background.corner_radius=9                     \
                              background.color=0xff3C3E4F                    \
                              background.drawing=off                         \
                              label.drawing=off                              \
                              script="$HOME/.config/sketchybar/plugins/aerospace.sh $sid" \
                              click_script="aerospace workspace $sid"
done

sketchybar   --add item       separator left                           \
             --set            separator                                 \
                              icon=                                    \
                              icon.font="Hack Nerd Font:Regular:16.0"  \
                              background.padding_left=6                 \
                              background.padding_right=6                \
                              label.drawing=off                         \
                              associated_display=active                 \
                              icon.color=$WHITE
