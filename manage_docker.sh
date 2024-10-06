#!/bin/bash

# Function to display an error message and exit
function throw_error {
  echo "Error: $1"
  exit 1
}

# Initialize variables
CONFIG=""
ACTION=""
ENV=""

# Parse key arguments
while [ $# -gt 0 ]; do
  case "$1" in
  --config=*)
    CONFIG="${1#*=}"
    ;;
  --action=*)
    ACTION="${1#*=}"
    ;;
  --env=*)
    ENV="${1#*=}"
    ;;
  *)
    throw_error "Invalid argument: $1. Expected --config, --action, and --env."
    ;;
  esac
  shift
done

# Check if required parameters are provided
if [ -z "$CONFIG" ]; then
  throw_error "No configuration provided. Please specify --config='pure' or --config='shioaji'."
fi

if [ -z "$ACTION" ]; then
  throw_error "No action provided. Please specify --action='up' or --action='down'."
fi

if [ -z "$ENV" ]; then
  throw_error "No environment provided. Please specify --env='local' or --env='dev'."
fi

# Define the compose file based on config and env
PURE_COMPOSE_FILE="./config/jupyter/env/$ENV/docker-compose.yaml"
SHIOAJI_COMPOSE_FILE="./config/shioaji/env/$ENV/docker-compose.yaml"

# Determine the correct compose file based on config
case "$CONFIG" in
pure)
  COMPOSE_FILE=$PURE_COMPOSE_FILE
  ;;
shioaji)
  COMPOSE_FILE=$SHIOAJI_COMPOSE_FILE
  ;;
*)
  throw_error "Invalid config input. Please specify --config='pure' or --config='shioaji'."
  ;;
esac

# Set the Docker service name
SERVICE_NAME="${CONFIG}-jupyter-lab"

# Execute the Docker Compose command based on action
if [ "$ACTION" = "up" ]; then
  echo "Launching Docker Compose with config: $CONFIG and environment: $ENV"
  docker compose -f $COMPOSE_FILE up -d

  # If config is 'shioaji', run "jupyter notebook list" inside the container
  if [ "$CONFIG" = "shioaji" ]; then
    echo "Waiting for the shioaji container to start..."
    sleep 12 # Adjust the sleep time if necessary

    # Run the "jupyter notebook list" command inside the container and print the output
    echo "Fetching Jupyter Notebook list from the shioaji container:"
    TOKEN=$(docker exec -it "$SERVICE_NAME" jupyter notebook list | sed -n 's/.*token=\([^&]*\).*/\1/p' | cut -d ' ' -f 1)
    echo "Jupyter Notebook Token: $TOKEN"
  fi
elif [ "$ACTION" = "down" ]; then
  echo "Shutting down Docker Compose with config: $CONFIG and environment: $ENV"
  docker compose -f $COMPOSE_FILE down
else
  throw_error "Invalid action. Please specify --action='up' or --action='down'."
fi
