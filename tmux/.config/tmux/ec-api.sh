#!/usr/bin/env zsh

BACKEND_PATH="$HOME/Projects/Work/elevation/elevation-church-backend"
START_API="RUST_LOG=debug cargo watch --ignore schema.graphql --env-file ./.env -- cargo run --bin elevation_church_api"
START_TESTS="RUST_LOG=warn cargo watch --ignore schema.graphql --env-file ./.env.test -- cargo test --features test-helpers -- --nocapture --show-output"

cd "$BACKEND_PATH" || exit 1
docker compose up -d

tmux new-session -d -s ec-api -c "$BACKEND_PATH" "$START_API"
tmux split-window -v -t ec-api -c "$BACKEND_PATH" "$START_TESTS"
tmux attach -t ec-api
