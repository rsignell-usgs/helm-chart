FROM continuumio/miniconda3:4.5.4

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda update -n base conda
RUN conda config --add channels conda-forge --force
RUN conda update --yes --all
RUN conda install --yes  \
    arrow \
    bokeh \
    cloudpickle \
    cython \
    cytoolz \
    dask \
    distributed \
    dask-kubernetes \
    dask-ml \
    dask-tensorflow \
    datashader \
    fastparquet \
    fusepy \
    geolinks \
    geopandas \
    geoviews \
    erddapy \
    esmpy \
    git \
    gridgeo \
    ioos_tools \
    iris \
    lz4 \
    msgpack-python \
    netcdf4 \
    nomkl \
    numba \
    numcodecs \
    numpy \
    pandas \
    pendulum \
    pyoos \
    python-blosc \
    conda-forge/label/dev::rasterio \
    retrying \
    rise \
    s3fs \
    shapely \
    siphon \
    scipy \
    scikit-image \
    scikit-learn \
    tensorflow \
    toolz \
    tornado \
    tqdm \
    utide \
    xarray \
    xlrd \
    zarr \
    zict \
    && conda clean -tipsy

RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV OMP_NUM_THREADS=1
ENV DASK_TICK_MAXIMUM_DELAY=5s

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /opt/app
RUN mkdir /gcs

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
