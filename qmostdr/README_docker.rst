Notes
#####

#. Access the running container
::

    > docker ps
    > docker exec -it pipeline bash

    * to exit the container without stopping it, do **CTRL-P** then **CTRL-Q**

#. Start cron scheduler and add a line to the crontab file
::

    > service cron start
    > crontab -e

    * check if the backup is happening

#. If you wan t to avoid users inside the container to gain root privileges/execute
sudo, even when the users are sudoers, call this on docker run
::

    --security-opt="no-new-privileges:true" \

#. To commit the running container into a new image, thus saving the work you've
done inside
::

    docker commit <container_id> <new_image_name>

Avoid different permissions between user inside container and host
******************************************************************
When running the container, used_id of the user inside the container should
match the one from the host machine. That way, modified fields by one user
(container/host) will be have the same permissions as the other user
(container/host). If that is not the case, then after each run of the container
we will need to tide-up the host created/modified using **chmod/chown**.

There are 2 main simple methods allowing to match user_id from inside/outside
the container.

Option 1
========
In the Dockerfile use
::

    RUN useradd --create-home --shell /bin/bash --uid ${USER_ID} -G some_group ${USER} \
    && echo "${USER}:${USER}" | chpasswd \
    && usermod -aG wheel ${USER}

where USER_ID and USER can be defined in the Dockerfile  or inherited from the call
of **docker run** using **ARG** and **--build-arg**

Option 2
========
In the call of **docker run** use
::

    --user $(id -u):$(id -g)

If the container was compiled with the same user_id as the host, then the user
inside the container will have access to its **home** directory. If not, the
user in the container will have no name neither access to the home.

Additional libraries
####################

cfitsio and fpack/funpack
*************************

Source:

- https://www.gnu.org/software/gnuastro/manual/html_node/CFITSIO.html
- https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html

Instructions
::

    > tar -xvf cfitsio-3.48.tar.gz
    > cd cfitsio-3.48
    > ./configure --prefix=/usr/local
    > make
    > make install
    > make testprog # or make utils
    > testprog > testprog.lis
    > diff testprog.lis testprog.out # Should have no output
    > cmp testprog.fit testprog.std # Should have no output
    > make clean

::

    $ ./configure
    $ make
    $ make fpack
    $ make funpack

fits_verify
***********

Source: https://heasarc.gsfc.nasa.gov/docs/software/ftools/fitsverify/

Instructions:
The the source code must be compiled and linked with the CFITSIO library.

::
    $ gcc -g -O2 -Wl,-rpath,/usr/local/lib \
    -o fitsverify ftverify.c fvrf_data.c fvrf_file.c fvrf_head.c \
    fvrf_key.c fvrf_misc.c -DSTANDALONE -L. -lcfitsio -lm \
    $ cp fitsverify /usr/local/bin/


wcslib
******

Source:

- https://www.gnu.org/software/gnuastro/manual/html_node/WCSLIB.html
- https://www.atnf.csiro.au/people/mcalabre/WCS/wcslib/software.html
- https://www.atnf.csiro.au/people/Mark.Calabretta/WCS/

Instructions

::

    $ tar -xvf wcslib.tar.bz2
    $ cd wcslib-7.3
    $ ./configure
    # Another option (given in GNU astro)
    # If `./configure' fails, remove `-lcurl' and run again.
    # $ ./configure LIBS="-pthread -lcurl -lm" --without-pgplot     \
    #              --disable-fortran
    $ make
    $ make check
    $ make install

gsl
***
GNU Scientific Library. Not sure if it's needed

Source: https://www.gnu.org/software/gnuastro/manual/html_node/GNU-Scientific-Library.html

Instructions
::

    $ tar xf gsl-latest.tar.gz
    $ cd gsl-X.X                     # Replace X.X with version number.
    $ ./configure
    $ make -j8                       # Replace 8 with no. CPU threads.
    $ make check
    $ sudo make install

fv
**
No: It needs X11
Source: https://heasarc.gsfc.nasa.gov/docs/software/ftools/fv/

Instructions
::

    > gunzip -c fv5.5.2_Linux.tar.gz | tar xf -
    # Then add the directory to PATH

ds9
***
No: It needs X11                                                               
Source: https://sites.google.com/cfa.harvard.edu/saoimageds9

