FROM continuumio/miniconda3:4.3.14

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda update conda --yes  && \
conda config --remove channels defaults && \
conda config --add channels conda-forge && \
conda update -all -y -q 

RUN conda install --yes \
    bokeh \
    cloudpickle \
    cython \
    cytoolz \
    dask \
    distributed \
    esmpy \
    fastparquet \
    git \
    lz4 \
    msgpack-python \
    netcdf4 \
    nomkl \
    numba \
    numcodecs \
    numpy \
    pandas \
    python-blosc \
    s3fs \
    scikit-image \
    toolz \
    tornado \
    scipy \
    xarray\
    zarr \
    zict \
    && conda clean -tipsy

RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# if we enable this line, we get an error later on
# ```Cannot uninstall 'pyasn1'. It is a distutils installed project and thus we
# cannot accurately determine which files belong to it which would lead to only
# a partial uninstall.```
#RUN pip install --upgrade pip

RUN pip install click \
                urllib3 \
                fusepy \
                gcsfs==0.1.0 \
                dask-kubernetes==0.4.0 \
                xesmf \
                --upgrade --no-cache-dir --upgrade-strategy only-if-needed

ENV OMP_NUM_THREADS=1
ENV DASK_DISTRIBUTED__ADMIN__TICK__LIMIT=5s

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /opt/app
RUN mkdir /gcs

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
