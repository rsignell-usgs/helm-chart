FROM jupyter/base-notebook

USER root
RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse vim git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER $NB_USER

RUN conda install --yes \
    -c defaults \
    -c pyviz/label/dev \
    -c bokeh/channel/dev \
    -c intake \
    -c conda-forge \
    bokeh=0.12.16 \
    cython \
    cytoolz \
    dask=0.17.5 \
    dask-ml \
    datashader \
    distributed=1.21.8 \
    fastparquet \
    ipywidgets \
    jupyter \
    jupyterlab=0.32.1 \
    jupyterlab_launcher=0.10.5 \
    jupyter_client \
    holoviews \
    libsodium \
    lz4 \
    matplotlib \
    nb_conda_kernels \
    netcdf4 \
    nomkl \
    numba \
    numcodecs \
    numpy=1.14.3 \
    pandas \
    python-blosc \
    pyzmq=17 \
    s3fs \
    scipy \
    scikit-image \
    scikit-learn \
    tornado \
    zarr=2.2.0 \
    zict \
    intake-xarray \
    && conda clean -tipsy

RUN pip install --upgrade pip

RUN pip install fusepy \
                click \
                jedi \
                kubernetes==6.0.0 \
                gcsfs==0.1.0 \
                xarray==0.10.4 \
                nbserverproxy==0.8.1 \
                git+https://github.com/xgcm/xgcm \
                --upgrade --no-cache-dir \
                --upgrade-strategy only-if-needed

RUN pip install git+https://github.com/dask/dask@bf5cfb01da7c6bc13f6e968df307f0352cb942ff \
                git+https://github.com/dask/distributed@13eebb6d660c379e8a2fc8e3c9b7474ba4dd5e4a \
                git+https://github.com/dask/dask-kubernetes@c773aad6d24903ae760d7c61c347a4195ba52dc5 \
                --no-cache-dir \
                --upgrade \ 
                --no-deps

RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 @jupyterlab/hub-extension \
                                 @pyviz/jupyterlab_pyviz

RUN jupyter serverextension enable --py nbserverproxy --sys-prefix

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /home/$NB_USER/examples && chown -R $NB_USER /home/$NB_USER/examples
RUN mkdir /pre-home && mkdir /pre-home/examples && chown -R $NB_USER /pre-home
COPY examples/ /pre-home/examples/

ENV DASK_CONFIG=/home/$NB_USER/config.yaml
COPY config.yaml /pre-home
COPY worker-template.yaml /pre-home

RUN mkdir /gcs && chown -R $NB_USER /gcs
RUN mkdir /opt/app

# Add NB_USER to sudo
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
RUN sed -ri "s#Defaults\s+secure_path=\"([^\"]+)\"#Defaults secure_path=\"\1:$CONDA_DIR/bin\"#" /etc/sudoers
USER $NB_USER

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh jupyter lab"]
