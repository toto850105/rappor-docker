FROM ubuntu:14.04

WORKDIR /root
ADD setup setup.sh
RUN apt-get update && apt-get install -yqq wget curl git gfortran-4.8 vim g++-4.8 openssl build-essential r-cran-ggplot2 gcc-4.8 libssl-dev protobuf-compiler libprotobuf-dev libapparmor1 psmisc
RUN wget https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb \
	&& dpkg -i rstudio-server-1.0.143-amd64.deb \
	&& apt-get -f install -y \
	&& rm *.deb \
	&& useradd -m rstudio \
	&& echo rstudio:rstudio | chpasswd
RUN ./setup.sh
RUN git clone https://github.com/google/rappor.git
WORKDIR rappor
RUN ./build.sh && cp -r analysis apps/rappor-analysis/ && cp -r analysis apps/rappor-sim/
RUN cp -r /root/rappor /home/rstudio \
	&& chown -R rstudio:rstudio /home/rstudio
ADD run run.sh
VOLUME ["/root/rappor"]
EXPOSE 6788 6789 8787

ENTRYPOINT ["/bin/bash"]
CMD ["./run.sh"]
