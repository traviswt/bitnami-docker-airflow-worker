#!/bin/bash
#
# Environment configuration for airflow-worker

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
# shellcheck disable=SC1090,SC1091
. /opt/bitnami/scripts/liblog.sh

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-airflow-worker}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
airflow_worker_env_vars=(
    AIRFLOW_EXECUTOR
    AIRFLOW_FERNET_KEY
    AIRFLOW_SECRET_KEY
    AIRFLOW_WEBSERVER_HOST
    AIRFLOW_WEBSERVER_PORT_NUMBER
    AIRFLOW_HOSTNAME_CALLABLE
    AIRFLOW_QUEUE
    AIRFLOW_DATABASE_HOST
    AIRFLOW_DATABASE_PORT_NUMBER
    AIRFLOW_DATABASE_NAME
    AIRFLOW_DATABASE_USERNAME
    AIRFLOW_DATABASE_PASSWORD
    AIRFLOW_DATABASE_USE_SSL
    AIRFLOW_REDIS_USE_SSL
    REDIS_HOST
    REDIS_PORT_NUMBER
    REDIS_DATABASE
    REDIS_USER
    REDIS_PASSWORD
)
for env_var in "${airflow_worker_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        if [[ -r "${!file_env_var:-}" ]]; then
            export "${env_var}=$(< "${!file_env_var}")"
            unset "${file_env_var}"
        else
            warn "Skipping export of '${env_var}'. '${!file_env_var:-}' is not readable."
        fi
    fi
done
unset airflow_worker_env_vars

# Airflow paths
export AIRFLOW_BASE_DIR="${BITNAMI_ROOT_DIR}/airflow"
export AIRFLOW_HOME="${AIRFLOW_BASE_DIR}"
export AIRFLOW_BIN_DIR="${AIRFLOW_BASE_DIR}/venv/bin"
export AIRFLOW_LOGS_DIR="${AIRFLOW_BASE_DIR}/logs"
export AIRFLOW_LOG_FILE="${AIRFLOW_LOGS_DIR}/airflow-worker.log"
export AIRFLOW_CONF_FILE="${AIRFLOW_BASE_DIR}/airflow.cfg"
export AIRFLOW_TMP_DIR="${AIRFLOW_BASE_DIR}/tmp"
export AIRFLOW_PID_FILE="${AIRFLOW_TMP_DIR}/airflow-worker.pid"
export AIRFLOW_DAGS_DIR="${AIRFLOW_BASE_DIR}/dags"

# System users (when running with a privileged user)
export AIRFLOW_DAEMON_USER="airflow"
export AIRFLOW_DAEMON_GROUP="airflow"

# Airflow configuration
export AIRFLOW_EXECUTOR="${AIRFLOW_EXECUTOR:-SequentialExecutor}"
export AIRFLOW_FERNET_KEY="${AIRFLOW_FERNET_KEY:-}"
export AIRFLOW_SECRET_KEY="${AIRFLOW_SECRET_KEY:-}"
export AIRFLOW_WEBSERVER_HOST="${AIRFLOW_WEBSERVER_HOST:-127.0.0.1}"
export AIRFLOW_WEBSERVER_PORT_NUMBER="${AIRFLOW_WEBSERVER_PORT_NUMBER:-8080}"
export AIRFLOW_HOSTNAME_CALLABLE="${AIRFLOW_HOSTNAME_CALLABLE:-}"
export AIRFLOW_QUEUE="${AIRFLOW_QUEUE:-}"

# Airflow database configuration
export AIRFLOW_DATABASE_HOST="${AIRFLOW_DATABASE_HOST:-postgresql}"
export AIRFLOW_DATABASE_PORT_NUMBER="${AIRFLOW_DATABASE_PORT_NUMBER:-5432}"
export AIRFLOW_DATABASE_NAME="${AIRFLOW_DATABASE_NAME:-bitnami_airflow}"
export AIRFLOW_DATABASE_USERNAME="${AIRFLOW_DATABASE_USERNAME:-bn_airflow}"
export AIRFLOW_DATABASE_PASSWORD="${AIRFLOW_DATABASE_PASSWORD:-}"
export AIRFLOW_DATABASE_USE_SSL="${AIRFLOW_DATABASE_USE_SSL:-no}"
export AIRFLOW_REDIS_USE_SSL="${AIRFLOW_REDIS_USE_SSL:-no}"
export REDIS_HOST="${REDIS_HOST:-redis}"
export REDIS_PORT_NUMBER="${REDIS_PORT_NUMBER:-6379}"
export REDIS_DATABASE="${REDIS_DATABASE:-1}"
export REDIS_USER="${REDIS_USER:-}"
export REDIS_PASSWORD="${REDIS_PASSWORD:-}"

# Custom environment variables may be defined below
