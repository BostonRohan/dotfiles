#!/bin/bash

SESH="ec-web"
START_SERVER="pnpm dev"
START_TESTS="pnpm test:watch"

if ! tmux has-session -t $SESH 2>/dev/null; then
  tmux new-session -s $SESH -n "editor" -d
  tmux send-keys -t $SESH:editor "cd ~/Projects/Work/elevation/ec-website/" C-m
  tmux send-keys -t $SESH:editor "nvim" C-m

  tmux new-window -t $SESH -n "server-test" -d
  tmux send-keys -t $SESH:server-test "cd ~/Projects/Work/elevation/ec-website/" C-m
  tmux split-window -h -t $SESH:server-test
  tmux send-keys -t $SESH:server-test.1 "$START_SERVER" C-m
  tmux send-keys -t $SESH:server-test.2 "cd ~/Projects/Work/elevation/ec-website/" C-m
  tmux send-keys -t $SESH:server-test.2 "sleep 10" C-m
  tmux send-keys -t $SESH:server-test.2 "$START_TESTS" C-m

  tmux attach-session -t $SESH
else
  tmux attach-session -t $SESH
fi
