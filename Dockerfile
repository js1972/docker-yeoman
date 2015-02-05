# Yeoman with some generators and prerequisites
# Build an image with "docker build -t <image_name> ."
# Run a container from the image with:
# "docker run --rm -it -p 8080:8080 -v $(pwd):/home/yeoman/<dir> <image_name>"
# If you use the -v option whatever is in the host directory will overwrite
# whats in the container directory.
#
FROM silarsis/base
MAINTAINER Jason Scott <jason@jaylin.com.au>
RUN apt-get -yq update && apt-get -yq upgrade

# Install pre-requisites - J. Scott added sudo; grunt-cli.
RUN apt-get -yq install python-software-properties software-properties-common python g++ make git ruby-compass libfreetype6 sudo
# Install node.js, then npm install yo and the generators
RUN add-apt-repository ppa:chris-lea/node.js -y; \
  apt-get -yq update; \
  apt-get -yq install nodejs; \
  apt-get -yq install nano; \
  sudo npm install grunt-cli -g; \
  sudo npm install bower -g --config.interactive=false --allow-root; \
  sudo npm install yo -g; \
  sudo npm install -g generator-webapp

# Add a yeoman user because grunt doesn't like being root
RUN adduser --disabled-password --gecos "" yeoman; \
  echo "yeoman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/yeoman
USER yeoman
WORKDIR /home/yeoman

RUN git clone https://github.com/js1972/generator-openui5.git
WORKDIR /home/yeoman/generator-openui5

RUN sudo npm link
WORKDIR /home/yeoman

# Expose the port
EXPOSE 8080
CMD ["/bin/bash"]
