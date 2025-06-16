#!/bin/bash

SESH="ec-backend"
BACKEND_PATH="$HOME/Projects/Work/elevation/elevation-church-backend"
START_API="RUST_LOG=debug cargo watch --ignore schema.graphql --env-file ./.env -- cargo run --bin elevation_church_api"
START_CRON="RUST_LOG=debug cargo watch --env-file ./.env -- cargo run --bin salesforce_cron"
START_SYNC="RUST_LOG=debug cargo watch --env-file ./.env -- cargo run --bin external_sync"
START_TESTS="RUST_LOG=debug cargo watch --ignore schema.graphql --env-file ./.env.test -- cargo test -- --nocapture --show-output"

cd ~/Projects/Work/elevation/elevation-church-backend/ || exit
docker compose up -d

if ! tmux has-session -t $SESH 2>/dev/null; then
  tmux new-session -s $SESH -n "lazygit" -d
  tmux send-keys -t $SESH:lazygit "cd $BACKEND_PATH" C-m
  tmux send-keys -t $SESH:lazygit "lazygit" C-m

  tmux new-window -t $SESH -n "api-test"
  tmux send-keys -t $SESH:api-test "cd $BACKEND_PATH" C-m
  tmux split-window -h -t $SESH:api-test
  tmux send-keys -t $SESH:api-test.1 "$START_API" C-m
  tmux send-keys -t $SESH:api-test.2 "cd $BACKEND_PATH" C-m
  tmux send-keys -t $SESH:api-test.2 "$START_TESTS" C-m

  tmux new-window -t $SESH -n "cron-test"
  tmux send-keys -t $SESH:cron-test "cd $BACKEND_PATH" C-m
  tmux split-window -h -t $SESH:cron-test
  tmux send-keys -t $SESH:cron-test.1 "$START_CRON" C-m
  tmux send-keys -t $SESH:cron-test.2 "cd $BACKEND_PATH" C-m
  tmux send-keys -t $SESH:cron-test.2 "$START_TESTS" C-m

  tmux new-window -t $SESH -n "sync-test"
  tmux send-keys -t $SESH:sync-test "cd $BACKEND_PATH" C-m
  tmux split-window -h -t $SESH:sync-test
  tmux send-keys -t $SESH:sync-test.1 "sleep 30" C-m
  tmux send-keys -t $SESH:sync-test.1 "$START_SYNC" C-m
  tmux send-keys -t $SESH:sync-test.2 "cd $BACKEND_PATH" C-m
  tmux send-keys -t $SESH:sync-test.2 "$START_TESTS" C-m

  tmux attach-session -t $SESH
else
  tmux attach-session -t $SESH
fi
