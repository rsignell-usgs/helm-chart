FROM jupyter/base-notebook:5811dcb711ba
#FROM jupyter/base-notebook:137a295ff71b

USER root
RUN apt-get update \
  && apt-get install -yq --no-install-recommends \
         libfuse-dev nano fuse vim git graphviz libgl1-mesa-glx \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/
USER $NB_USER

RUN conda update conda --yes  

RUN conda config --remove channels defaults

RUN conda install --yes  \
    python=3.6 \
    bokeh \
    holoviews \
    datashader \
    geoviews \
    panel \
    intake::intake-xarray \
    appmode \
    arrow \
    bqplot \
    cython \
    dask-kubernetes \
    dask-ml \
    dask-tensorflow \
    erddapy \
    esmpy \
    fastparquet \
    folium \
    fusepy \
    gcsfs \
    geolinks \
    geopandas \
    gridgeo \
    hvplot \
    ioos_tools \
    ipyleaflet \
    iris \
    jupyter \
    jupyterlab=0.35 \
    jupyterlab_launcher \
    jupyter_client \
    libiconv \
    lz4 \
    nbserverproxy \
    opencv \
    owslib \
    palettable \
    pendulum \
    pyarrow \
    pygam \
    pyoos \
    pydensecrf \
    python-blosc \
    python-graphviz \
    rasterio \
    retrying \
    rise \
    satsearch \
    s3fs \
    scikit-image \
    scikit-learn \
    shapely \
    siphon \
    tensorflow \
    tensorflow-hub \
    tqdm \
    utide \
    websocket-client \
    xarray \
    xesmf \
    xgcm \
    xlrd \
    zarr \
    && conda clean -tipsy

RUN pip install --upgrade pip

RUN pip install \
    git+https://github.com/pydata/xarray.git \
    git+https://github.com/dask/dask-kubernetes.git \
                --upgrade --no-cache-dir \
                --upgrade-strategy only-if-needed

RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 @jupyterlab/hub-extension@0.12 \
                                 @pyviz/jupyterlab_pyviz \
                                 jupyter-leaflet \
                                 dask-labextension 

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /home/$NB_USER/examples && chown -R $NB_USER /home/$NB_USER/examples
RUN mkdir /pre-home && mkdir /pre-home/examples && chown -R $NB_USER /pre-home

ENV DASK_CONFIG=/home/$NB_USER/config.yaml

COPY config.yaml /pre-home
COPY worker-template.yaml /pre-home

COPY examples/ /pre-home/examples/

RUN mkdir /s3 && chown -R $NB_USER /s3
RUN mkdir /opt/app

# Add NB_USER to sudo
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
RUN sed -ri "s#Defaults\s+secure_path=\"([^\"]+)\"#Defaults secure_path=\"\1:$CONDA_DIR/bin\"#" /etc/sudoers
USER $NB_USER

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh jupyter lab"]
