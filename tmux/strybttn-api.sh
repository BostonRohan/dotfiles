#!/bin/bash

SESH="strybttn-api"
START_SERVER="RUST_LOG=debug cargo watch --workdir apps/bttn_plus_api --env-file=../../.env --ignore schema.graphql -- cargo run --bin bttn_plus_api"
START_CREDITS="RUST_LOG=debug cargo watch --workdir apps/credits --env-file=../../.env -- cargo run --bin bttn_plus_credits"
START_TESTS="RUST_LOG=debug ENVIRONMENT=test cargo watch --env-file=.env.test --ignore schema.graphql -- cargo test --workspace -- --nocapture --show-output"

cd ~/Projects/Work/storybutton/bttn_plus_backend/ || exit
docker compose up -d

if ! tmux has-session -t $SESH 2>/dev/null; then
  tmux new-session -s $SESH -n "editor" -d
  tmux send-keys -t $SESH:editor "cd ~/Projects/Work/storybutton/bttn_plus_backend/" C-m
  tmux send-keys -t $SESH:editor "nvim" C-m

  tmux new-window -t $SESH -n "server-test" -d
  tmux send-keys -t $SESH:server-test "cd ~/Projects/Work/storybutton/bttn_plus_backend/" C-m
  tmux split-window -h -t $SESH:server-test
  tmux send-keys -t $SESH:server-test.1 "$START_SERVER" C-m
  tmux send-keys -t $SESH:server-test.2 "cd ~/Projects/Work/storybutton/bttn_plus_backend/" C-m
  tmux send-keys -t $SESH:server-test.2 "$START_TESTS" C-m

  tmux new-window -t $SESH -n "credits" -d
  tmux send-keys -t $SESH:credits "cd ~/Projects/Work/storybutton/bttn_plus_backend/" C-m
  tmux send-keys -t $SESH:credits "$START_CREDITS" C-m

  tmux attach-session -t $SESH
else
  tmux attach-session -t $SESH
fi
