#!/bin/bash

SESH="ec-api"
START_SERVER="RUST_LOG=debug cargo watch --ignore schema.graphql --env-file ./.env -- cargo run --bin elevation_church_api"
START_TESTS="RUST_LOG=debug cargo watch --ignore schema.graphql --env-file ./.env.test -- cargo test -- --nocapture --show-output"

cd ~/Projects/Work/elevation/elevation-church-backend/ || exit
docker compose up -d

if ! tmux has-session -t $SESH 2>/dev/null; then
  tmux new-session -s $SESH -n "editor" -d
  tmux send-keys -t $SESH:editor "cd ~/Projects/Work/elevation/elevation-church-backend/" C-m
  tmux send-keys -t $SESH:editor "nvim" C-m

  tmux new-window -t $SESH -n "server-test"
  tmux send-keys -t $SESH:server-test "cd ~/Projects/Work/elevation/elevation-church-backend/apps/elevation_church_api/" C-m
  tmux split-window -h -t $SESH:server-test
  tmux send-keys -t $SESH:server-test.1 "$START_SERVER" C-m
  tmux send-keys -t $SESH:server-test.2 "cd ~/Projects/Work/elevation/elevation-church-backend/apps/elevation_church_api/" C-m
  tmux send-keys -t $SESH:server-test.2 "$START_TESTS" C-m

  tmux attach-session -t $SESH
else
  tmux attach-session -t $SESH
fi
