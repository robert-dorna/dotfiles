docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --mount type=bind,src="$(pwd)",target=/hostmount ubuntu-display
