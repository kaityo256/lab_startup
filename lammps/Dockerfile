from centos:centos7

COPY vmd-1.9.4a38.bin.LINUXAMD64-CUDA10-OptiX600-RTX-OSPRay170.opengl.tar.gz /vmd/

RUN yum -y install glx-utils make libXinerama libXi perl \
  && cd /vmd \
  && tar xvzf vmd-1.9.4a38.bin.LINUXAMD64-CUDA10-OptiX600-RTX-OSPRay170.opengl.tar.gz \
  && cd vmd-1.9.4a38 \
  && ./configure LINUXAMD64 \
  && cd src; make install

CMD ["vmd"]
