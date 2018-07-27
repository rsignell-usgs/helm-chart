#!/bin/bash

set -x

echo "Copy Dask configuration files from pre-load directory into home/.config"
mkdir -p /home/jovyan/.config/dask
cp --update -r -v /pre-home/config.yaml /home/jovyan/.config/dask/
cp --update -r -v /pre-home/worker-template.yaml /home/jovyan/.config/dask/

if [ -e "/opt/app/environment.yml" ]; then
    echo "environment.yml found. Installing packages"
    /opt/conda/bin/conda env update -f /opt/app/environment.yml
else
    echo "no environment.yml"
fi

if [ "$EXTRA_CONDA_PACKAGES" ]; then
    echo "EXTRA_CONDA_PACKAGES environment variable found.  Installing."
    /opt/conda/bin/conda install $EXTRA_CONDA_PACKAGES
fi

if [ "$EXTRA_PIP_PACKAGES" ]; then
    echo "EXTRA_PIP_PACKAGES environment variable found.  Installing".
    /opt/conda/bin/pip install $EXTRA_PIP_PACKAGES
fi

# Run extra commands
$@
