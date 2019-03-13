# Version 1.0
FROM ubuntu:latest
LABEL project="Snort"
LABEL maintainer="German Bianchini (gbianchini@la-madrilena.com)"

# Preparacion de los archivos para la instalacion de Snort
RUN mkdir /home/instalacion
ADD install_snort.sh .
ADD daq-2.0.6.tar.gz /home/instalacion/
ADD LuaJIT-2.0.5.tar.gz /home/instalacion/
ADD snort-2.9.12.tar.gz /home/instalacion/

# Preparacion de los programas de la imagen
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y openssh-server ethtool build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev liblzma-dev openssl libssl-dev net-tools nghttp2 nano

# Instalacion de Snort
RUN chmod +x install_snort.sh && ./install_snort.sh

# Inicio el servicio
CMD ["/bin/bash"]