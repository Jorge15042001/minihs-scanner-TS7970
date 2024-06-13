sudo apt-get install qemu-user-static
sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
sudo docker build --tag armhf-bullseye-toolchain .
