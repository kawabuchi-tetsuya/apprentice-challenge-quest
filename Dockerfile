FROM ubuntu:latest

RUN apt update -y && \
  apt install -y sudo make curl ssh vim locales gnupg && \
  locale-gen en_US.UTF-8 && \
  update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN useradd -m -s /bin/bash foge && \
  echo "foge:fogefoge" | chpasswd && \
  usermod -aG sudo foge

RUN gpasswd -a foge sudo

USER foge
WORKDIR /home/foge
