FROM jupyter/base-notebook:8ccdfc1da8d5

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential=12.4ubuntu1 \
        emacs \
        git \
        inkscape \
        jed \
        libsm6 \
        libxext-dev \
        libxrender1 \
        lmodern \
        netcat \
        unzip \
        nano \
        curl \
        wget \
        gfortran \
        cmake \
        bsdtar && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd $HOME/work;\
    pip install scipy \
                flask \
                ipywidgets \
                nbconvert==5.4.0 \
                jupyterlab>=0.35.4 \
                pandas \
                numpy \
                matplotlib ; \
    python -m sos_notebook.install;\
    git clone --single-branch -b master https://github.com/mathieuboudreau/pipelines-jupyter-book;     \
    cd pipelines-jupyter-book;\
    git clone --depth 1 --branch 4.0.0 https://github.com/neuropoly/spinalcordtoolbox.git sct; \
    cd sct; \
    yes | ./install_sct; \
    cd .. ;\
    chmod -R 777 $HOME/work/pipelines-jupyter-book;

ENV PATH "/home/jovyan/work/pipelines-jupyter-book/sct/bin:$PATH"

WORKDIR $HOME/work/pipelines-jupyter-book

USER $NB_UID

RUN jupyter labextension install @jupyterlab/plotly-extension;  \
    jupyter labextension install @jupyterlab/celltags; \
    jupyter labextension install jupyterlab-sos
