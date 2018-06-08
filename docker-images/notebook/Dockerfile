FROM jupyter/base-notebook

USER root
RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse vim git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER $NB_USER

RUN conda install --yes -c pyviz pyviz
RUN conda install --yes -c conda-forge/label/dev rasterio
RUN conda install --yes -c conda-forge \
    cython \
    cytoolz \
    dask-ml \
    erddapy \
    fastparquet \
    gcsfs \
    jedi \
    jupyterlab \
    jupyterlab_launcher \
    lz4 \
    matplotlib \
    nb_conda_kernels \
    nbserverproxy \
    netcdf4 \
    nomkl \
    numcodecs \
    python-blosc \
    s3fs \
    scikit-learn \
    utide \
    websocket-client \
    xarray \
    && conda clean -tipsy

RUN pip install --upgrade pip

RUN pip install fusepy  kubernetes==4.0.0 dask-kubernetes \
        git+https://github.com/xgcm/xgcm \
        --upgrade --no-cache-dir


USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /home/$NB_USER/examples && chown -R $NB_USER /home/$NB_USER/examples
RUN mkdir /pre-home && mkdir /pre-home/examples && chown -R $NB_USER /pre-home
COPY worker-template.yaml /pre-home
COPY examples/ /pre-home/examples/

ENV DASK_TICK_MAXIMUM_DELAY=5s
ENV DASKERNETES_DIAGNOSTICS_LINK {JUPYTERHUB_SERVICE_PREFIX}proxy/{port}/status
ENV DASKERNETES_WORKER_TEMPLATE_PATH /home/$NB_USER/worker-template.yaml
ENV DASKERNETES_WORKER_NAME dask-{JUPYTERHUB_USER}-{uuid}
ENV DASK_DIAGNOSTICS_LINK {JUPYTERHUB_SERVICE_PREFIX}proxy/{port}/status
ENV DASK_KUBERNETES_WORKER_TEMPLATE_PATH /home/$NB_USER/worker-template.yaml
ENV DASK_KUBERNETES_WORKER_NAME dask-{JUPYTERHUB_USER}-{uuid}

RUN mkdir /gcs && chown -R $NB_USER /gcs
RUN mkdir /opt/app

# Add NB_USER to sudo
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
RUN sed -ri "s#Defaults\s+secure_path=\"([^\"]+)\"#Defaults secure_path=\"\1:$CONDA_DIR/bin\"#" /etc/sudoers
USER $NB_USER

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh jupyter lab"]
