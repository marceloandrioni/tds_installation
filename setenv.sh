#!/bin/sh
#
# ENVARS for Tomcat
#
export CATALINA_HOME="/usr/local/tds/tomcat"

export CATALINA_BASE="/usr/local/tds/tomcat"

export JAVA_HOME="/usr/local/tds/jdk"

# TDS specific ENVARS
#
# Define where the TDS content directory will live
#   THIS IS CRITICAL and there is NO DEFAULT - the
#   TDS will not start without this.
#
CONTENT_ROOT=/usr/local/tds/content
CONTENT_ROOT_OPT=-Dtds.content.root.path=$CONTENT_ROOT

# Set java prefs related variables (used by the wms service, for example)
JAVA_PREFS_ROOTS="-Djava.util.prefs.systemRoot=$CONTENT_ROOT/thredds/javaUtilPrefs \
                  -Djava.util.prefs.userRoot=$CONTENT_ROOT/thredds/javaUtilPrefs"

#
# Some commonly used JAVA_OPTS settings:
#

# Note: the recommended -d64 flags makes the tomcat startup fail. The error is logged to tomcat/logs/catalina.out
# Unrecognized option: -d64
# Error: Could not create the Java Virtual Machine.
# Error: A fatal exception has occurred. Program will exit.
# 
# NORMAL="-d64 -Xmx4096m -Xms512m -server"
NORMAL="-Xmx4096m -Xms512m -server"

HEAP_DUMP="-XX:+HeapDumpOnOutOfMemoryError"
HEADLESS="-Djava.awt.headless=true"
CHRONICLE_CACHE="--add-exports java.base/jdk.internal.ref=ALL-UNNAMED --add-exports java.base/sun.nio.ch=ALL-UNNAMED --add-exports jdk.unsupported/sun.misc=ALL-UNNAMED --add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED --add-opens jdk.compiler/com.sun.tools.javac=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED"

#
# proxy configuration.
#
# Note: if the Tomcat server will be behind a proxy (usual in a corporate setup),
# uncomment the lines bellow set the correct proxy configuration. This
# configuration allows the server (and applets) to access the internet if needed.
# The client (i.e. the user's browser) needs it owns configuration to access
# the internet if behind a proxy.
# Note: most of the TDS resources will work just fine without a internet
# connection, but the Godiva3 client "inside" TDS will not work correctly if
# there is no internet connection.

PROXY=""

# PROXY="-Dhttp.proxySet=true \
#        -Dhttp.proxyHost=proxy.mycompany.com \
#        -Dhttp.proxyPort=8080 \
#        -Dhttp.proxyUser=user \
#        -Dhttp.proxyPassword=password \
#        -Dhttp.nonProxyHosts='localhost|127.0.0.1|*.mycompany.com' \
#        -Dhttps.proxySet=true \
#        -Dhttps.proxyHost=proxy.mycompany.com \
#        -Dhttps.proxyPort=8080 \
#        -Dhttps.proxyUser=user \
#        -Dhttps.proxyPassword=password \
#        -Dhttps.nonProxyHosts='localhost|127.0.0.1|*.mycompany.com'"

#
# Standard setup.
#
JAVA_OPTS="$CONTENT_ROOT_OPT $NORMAL $HEAP_DUMP $HEADLESS $JAVA_PREFS_ROOTS $CHRONICLE_CACHE $PROXY"

export JAVA_OPTS
