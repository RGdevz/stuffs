#!/bin/bash
# Provide options for loading environment variables in AppRun.conf rather than loading them all by default
# Created by simonizor

# Create AppRun variable defaults in case config file is not present
APPRUN_SET_PATH="TRUE"
APPRUN_SET_LD_LIBRARY_PATH="TRUE"
APPRUN_SET_PYTHONPATH="TRUE"
APPRUN_SET_PYTHONHOME="TRUE"
APPRUN_SET_PYTHONDONTWRITEBYTECODE="TRUE"
APPRUN_SET_XDG_DATA_DIRS="TRUE"
APPRUN_SET_PERLLIB="TRUE"
APPRUN_SET_GSETTINGS_SCHEMA_DIR="TRUE"
APPRUN_SET_QT_PLUGIN_PATH="TRUE"

# Get AppRun running directory
REALPATH="$(readlink -f $0)"
RUNNING_DIR="$(dirname "$REALPATH")"

# Load config file if present
[ -f "$RUNNING_DIR/AppRun.conf" ] && . "$RUNNING_DIR/AppRun.conf"

# Set AppRun environment variables based on config settings
[ "$APPRUN_SET_PATH" = "TRUE" ] && export PATH="$RUNNING_DIR"/usr/bin/:"$RUNNING_DIR"/usr/sbin/:"$RUNNING_DIR"/usr/games/:"$RUNNING_DIR"/bin/:"$RUNNING_DIR"/sbin/:"$PATH"
[ "$APPRUN_SET_LD_LIBRARY_PATH" = "TRUE" ] && export LD_LIBRARY_PATH="$RUNNING_DIR"/usr/lib/:"$RUNNING_DIR"/usr/lib/i386-linux-gnu/:"$RUNNING_DIR"/usr/lib/x86_64-linux-gnu/:"$RUNNING_DIR"/usr/lib32/:"$RUNNING_DIR"/usr/lib64/:"$RUNNING_DIR"/lib/:"$RUNNING_DIR"/lib/i386-linux-gnu/:"$RUNNING_DIR"/lib/x86_64-linux-gnu/:"$RUNNING_DIR"/lib32/:"$RUNNING_DIR"/lib64/:"${LD_LIBRARY_PATH}":"$RUNNING_DIR"/usr/lib/x86_64-linux-gnu/pulseaudio
[ "$APPRUN_SET_PYTHONPATH" = "TRUE" ] && export PYTHONPATH="$RUNNING_DIR"/usr/share/pyshared/:"$PYTHONPATH"
[ "$APPRUN_SET_PYTHONHOME" = "TRUE" ] && export PYTHONHOME="$RUNNING_DIR"/usr/:"$PYTHONHOME"
[ "$APPRUN_SET_PYTHONDONTWRITEBYTECODE" = "TRUE" ] && export PYTHONDONTWRITEBYTECODE=1
[ "$APPRUN_SET_XDG_DATA_DIRS" = "TRUE" ] && export XDG_DATA_DIRS="$RUNNING_DIR"/usr/share/:"$XDG_DATA_DIRS"
[ "$APPRUN_SET_PERLLIB" = "TRUE" ] && export PERLLIB="$RUNNING_DIR"/usr/share/perl5/:"$RUNNING_DIR"/usr/lib/perl5/:"$PERLLIB"
[ "$APPRUN_SET_GSETTINGS_SCHEMA_DIR" = "TRUE" ] && export GSETTINGS_SCHEMA_DIR="$RUNNING_DIR"/usr/share/glib-2.0/schemas/:"$GSETTINGS_SCHEMA_DIR"
[ "$APPRUN_SET_QT_PLUGIN_PATH" = "TRUE" ] && export QT_PLUGIN_PATH="$RUNNING_DIR"/usr/lib/qt4/plugins/:"$RUNNING_DIR"/usr/lib/i386-linux-gnu/qt4/plugins/:"$RUNNING_DIR"/usr/lib/x86_64-linux-gnu/qt4/plugins/:"$RUNNING_DIR"/usr/lib32/qt4/plugins/:"$RUNNING_DIR"/usr/lib64/qt4/plugins/:"$RUNNING_DIR"/usr/lib/qt5/plugins/:"$RUNNING_DIR"/usr/lib/i386-linux-gnu/qt5/plugins/:"$RUNNING_DIR"/usr/lib/x86_64-linux-gnu/qt5/plugins/:"$RUNNING_DIR"/usr/lib32/qt5/plugins/:"$RUNNING_DIR"/usr/lib64/qt5/plugins/:"$QT_PLUGIN_PATH"
# Use APPRUN_EXEC variable if it is set otherwise attempt to find .desktop file and Exec line from .desktop file in RUNNING_DIR
if [ -z "$APPRUN_EXEC" ]; then
    DESKTOP_FILE="$(dir -C -w 1 "$RUNNING_DIR/" | grep -m1 '.desktop')"
    if [ ! -z "$DESKTOP_FILE" ]; then
        APPRUN_EXEC="$(grep -m1 'Exec=.*' "$RUNNING_DIR"/"$DESKTOP_FILE" | cut -f2 -d"=" | cut -f1 -d" ")"
        if [ -z "$APPRUN_EXEC" ]; then
            echo "Failed to find Exec line in $DESKTOP_FILE and APPRUN_EXEC variable is not set; exiting..."
            exit 1
        fi
    else
        echo "Failed to find .desktop file in $RUNNING_DIR and APPRUN_EXEC variable is not set; exiting..."
        exit 1
    fi
fi
case "$APPRUN_EXEC" in
    /*) exec "$RUNNING_DIR""$APPRUN_EXEC" "$@";;
    *) exec "$APPRUN_EXEC" "$@";;
esac
