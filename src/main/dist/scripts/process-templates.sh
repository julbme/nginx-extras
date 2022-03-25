#!/bin/sh

TEMPLATES_SRC_DIR=$1
TEMPLATES_DEST_DIR=$2

ENV_VAR_PREFIX="J3_"

main() {
    # check if directory exist
    if [ ! -d "${TEMPLATES_SRC_DIR}" ]; then
        echo "${TEMPLATES_SRC_DIR} is not a valid directory"
        exit 1
    fi

    # check if directory exist
    if [ ! -d "${TEMPLATES_DEST_DIR}" ]; then
        mkdir -p "${TEMPLATES_DEST_DIR}"
    fi

    # Create temporary directory
    TEMP_DIR=$(mktemp -d)

    # Get vars to substitute
    TEMPLATE_ENV_VARS=$(grep -hEro "\\$\\{${ENV_VAR_PREFIX}[A-Z0-9_]+\\}" "${TEMPLATES_SRC_DIR}" | sed -E 's/^\${('${ENV_VAR_PREFIX}'[A-Z0-9_]+)}$/\1/g' | uniq | sort | tr '\n' ' ')
    TEMPLATE_ENV_VARS_WITH_BRACKETS=$(grep -hEro "\\$\\{${ENV_VAR_PREFIX}[A-Z0-9_]+\\}" "${TEMPLATES_SRC_DIR}" | uniq | sort | tr '\n' ' ')
    echo "= EnvVars to substitute: ${TEMPLATE_ENV_VARS}"

    # Export defaults
    for TEMPLATE_ENV_VAR in ${TEMPLATE_ENV_VARS}; do
        TEMPLATE_ENV_VAR_VALUE=$(eval "echo \"\$$TEMPLATE_ENV_VAR\"")
        if [ -z "${TEMPLATE_ENV_VAR_VALUE}" ]; then
            echo "== WARNING: env.$TEMPLATE_ENV_VAR is unset"
            export "$TEMPLATE_ENV_VAR=???env.$TEMPLATE_ENV_VAR???"
        fi
    done

    echo "= Generating files."

    # Copy templates to target
    for TEMPLATE_FILE in "${TEMPLATES_SRC_DIR}"/*.template; do
        [ -e "$TEMPLATE_FILE" ] || break

        # Get template file name
        TEMPLATE_FILE_NAME=$(basename "${TEMPLATE_FILE}")

        # Remove extension .template
        CONF_FILE_NAME=${TEMPLATE_FILE_NAME%.template}

        # Envsubst
        echo "== EnvSubst values into file <${CONF_FILE_NAME}>."
        envsubst "'${TEMPLATE_ENV_VARS_WITH_BRACKETS}'" < "${TEMPLATE_FILE}" > "${TEMP_DIR}/${CONF_FILE_NAME}"
    done

    # Copy to destination
    echo "= Copying all conf files to destination directory."
    mv "${TEMP_DIR}"/*.conf "${TEMPLATES_DEST_DIR}"

    # Clean temporary dir
    echo "= Cleaning temporary directory."
    rm -rf "${TEMP_DIR}"

    # Complete
    echo "= Complete!"
}

main