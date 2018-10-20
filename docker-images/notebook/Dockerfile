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
    pyviz/label/earthsim::bokeh \
    pyviz/label/earthsim::holoviews \
    pyviz/label/earthsim::datashader \
    pyviz/label/earthsim::geoviews-core \
    pyviz/label/earthsim::geoviews \
    pyviz/label/earthsim::panel \
    intake::intake \
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
    iris>=1.12 \
    libiconv \
    lz4 \
    nb_conda_kernels \
    nbserverproxy \
    opencv \
    owslib \
    palettable \
    pendulum \
    pyarrow \
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
    xesmf \
    xgcm \
    xlrd \
    zarr \
    && conda clean -tipsy

RUN pip install --upgrade pip

RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 @jupyterlab/hub-extension \
                                 @pyviz/jupyterlab_pyviz \
                                 jupyter-leaflet  

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
