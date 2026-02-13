# Pull the baseimage.
FROM jlesage/baseimage-gui:alpine-3.23-v4

# Install xterm.
RUN add-pkg virt-manager

# Copy the start script.
COPY startapp.sh /startapp.sh

# Set the application name.
RUN set-cont-env APP_NAME "virt-manager"
