FROM centos:centos8 as baseOS
MAINTAINER Francisco Paz-Chinchon <fpc@ast.cam.ac.uk>

# Add metadata as key-value
ARG BUILD_DATE
ARG USER_ID
LABEL name="QMOST L1 Pipeline"
LABEL version="v01"
LABEL date=$BUILD_DATE
LABEL description="L1 pipeline for the QMOST project"
LABEL maintaner="fpc@ast.cam.ac.uk"

# Install OS and basic dependencies
# =================================
# Removed: epel-release
RUN yum -y update \
    && yum -y install \
    openmpi gcc gcc-gfortran make git curl binutils bzip2 \
    diffutils vim sudo \
    && yum clean all
# Miniconda
# Add into a network-connected container: datashader bokeh seaborn xarray dask
RUN curl --sSL \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm /tmp/miniconda.sh \
    && conda update conda \
    && conda install -y astropy pandas scipy sphinx pyyaml \
    && conda install -y -c conda-forge fitsio \
    && conda clean --all -y
# To aexplicity add the conda alias to sudo
RUN echo 'alias conda="/usr/local/bin/conda"' >> ~/.bashrc

# ENV
# ===
# - to update the PATH environment
# - to provide environment variables
# - set version numbers
ENV USER fpc
ENV USER_GROUP casu
ENV HOME /home/${USER}
ENV TERM xterm
ENV PYTHONPATH ${HOME}/qmostdr/devel/legacy/src
ENV LD_LIBRARY_PATH ${HOME}/qmostdr/devel/legacy/src
# ENV PATH ...
# ENV HOME /root
# ENV SHELL /bin/bash

# Install specific dependecies
# ============================
#
# ADD
# ===
# better used for tar files
# output folders after ADD: cfitsio-3.48 wcslib-7.3 fitsverify-4.20
# These 2 needs lib X11: fv5.5.2_Linux.tar.gz ds9.8.1.tar.gz
# Pending: fpack
ADD cfitsio-3.48.tar.gz /tmp
ADD wcslib.tar.bz2 /tmp
ADD fitsverify-4.20.tar.gz /tmp
#
# RUN
# ===
WORKDIR /tmp/cfitsio-3.48
RUN ./configure --prefix=/usr/local \
    && make \
    && make install \
    && make fpack \
    && make funpack \
    && make clean
WORKDIR /tmp/wcslib-7.3
# As we don't need to build Fortran programs. Removed make check because
# 3 tests fails:
# FAIL: C/twcstab
# FAIL: C/tdis3
# FAIL: C/twcslint
RUN ./configure --disable-fortran \
    && make \
    && make install \
    && make clean
# Fot fits_verify the instructions didn't work. I ran make testprog in
# cfitsio directory to get the template for compilation
WORKDIR /tmp/fitsverify-4.20
RUN gcc -g -O2 -Wl,-rpath,/usr/local/lib \
    -o fitsverify ftverify.c fvrf_data.c fvrf_file.c fvrf_head.c \
    fvrf_key.c fvrf_misc.c -DSTANDALONE -L. -lcfitsio -lm \
    && cp fitsverify /usr/local/bin/

# COPY
# ====
# copy of files, preferred over ADD for non-compressed
# Once pipeline is done, COPY it

# Adding user
# ===========
# When ready, remove the sudo permission from the qmost user
# or add a better password
# when using -r the numeric identifiers of new system groups are chosen in the
# SYS_GID_MIN-SYS_GID_MAX range, instead of GID_MIN-GID_MAX.
# To add to sudoers:
# - centOS: usermod -aG wheel ${USER}
# - ubuntu: adduser ${USER} sudo
# CentOS/Fedora/RH suggests run the docker as sudo, as the user can gain
# sudo permissions anyway.
#
# Other way: RUN echo "username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN groupadd -r ${USER_GROUP} \
    && useradd --create-home --shell /bin/bash --uid ${USER_ID} -G casu ${USER} \
    && echo "${USER}:${USER}" | chpasswd \
    && usermod -aG wheel ${USER}

# ENTRYPOINT
#
# to define the default command the docker runs. Example:
# ENTRYPOINT ["fv"]
# CMD ["--help"]

# VOLUME
#
# for data/db storage
# /home/qmost/persistent

# WORKDIR
#
# use instead of cd to change pwd

# ONBUILD
#
# An ONBUILD command executes after the current Dockerfile build completes.

EXPOSE 8080
VOLUME /data
VOLUME /code
VOLUME /home/${USER}/code
VOLUME /home/${USER}/data
WORKDIR /home/${USER}
USER ${USER}
CMD ["bash"]