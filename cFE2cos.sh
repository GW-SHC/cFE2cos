#!/bin/bash

# TODO: Replace this with a Makefile instead of a janky script

alias errcho='>&2 printf'

function cFE2cos() {
    local HELP_TEXT="\
Valid options are:
init        Initializes the Composite build
build       Builds Composite and links it with the cFE
run         Runs the Composite virtual machine
unit-test   Builds and runs Composite with cFE unit testing enabled

Note that if unit-test has previously been run, subsequent calls to \`run\` will
also run unit tests. Run \`build\` again to recompile the component without unit
test support.\
"

    local start_dir=`pwd`

    case "$1" in
        init)
            cd ~/cFE2cos/
            git submodule update --init --recursive

            cd ~/cFE2cos/composite/src/extern/cFE
            source ./setvars.sh

            cd ~/cFE2cos/composite/src/extern/cFE/build/cpu1
            make config
            if [ $? -ne 0 ]; then
                errcho 'cFE2cos: Could not "make config" the cFE!\n'
                cd $start_dir
                return 2
            fi

            cd ~/cFE2cos/composite/src
            make config && make init
            if [ $? -ne 0 ]; then
                errcho 'cFE2cos: Could not "make config && make init" composite!\n'
                cd $start_dir
                return 2
            fi

            cd $start_dir
            return 0
            ;;

        build)
            cd ~/cFE2cos/composite/src/extern/cFE
            source ./setvars.sh

            cd ~/cFE2cos/composite/src
            make
            if [ $? -ne 0 ]; then
                errcho 'cFE2cos: composite make failed!\n'
                cd $start_dir
                return 2
            fi

            cd $start_dir
            return 0
            ;;

        run)
            echo "Initializing cFE VM..."
            cd ~/cFE2cos/composite/transfer/
            ./qemu.sh llboot_cFE.sh
            cd $start_dir
            return 0
            ;;

        unit-test)
            cd $start_dir
            UNIT_TEST=true cFE2cos build
            if [ $? -ne 0 ]; then
                errcho 'The unit tests failed to build'
                return 2
            fi

            cFE2cos run
            if [ $? -ne 0 ]; then
                errcho 'The unit tests failed'
                return 2
            fi
            return 0
            ;;

        *)
            errcho "Unknown cFE2cos command \`$1\`\n"
            errcho "$HELP_TEXT\n"
            cd $start_dir
            return 1
            ;;
    esac
}

# Setup autocompletion
complete -W 'init build run unit-test' 'cFE2cos'
