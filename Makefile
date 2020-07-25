DOCKER_REACT_IMAGE_NAME:=balanced-gg-react
TAG:=$(shell git log -1 --pretty=format:"%H")



# Remove images generated by build
.PHONY: clean
clean:
	if [ -n "$(shell docker images -q $(DOCKER_REACT_IMAGE_NAME):$(TAG))" ]; then \
		docker run -v $(PWD):/opt/mount --rm --entrypoint rm $(DOCKER_REACT_IMAGE_NAME):$(TAG) -rf /opt/mount/src/vendor; \
		docker image ls --filter reference=$(DOCKER_REACT_IMAGE_NAME):$(TAG) --quiet | xargs docker image rm -f; \
	fi

# Builds the image
.PHONY: build
build:
	docker build -t $(DOCKER_REACT_IMAGE_NAME):$(TAG) ./app/
	# Support composer: tag as 'latest'
	docker tag $(DOCKER_REACT_IMAGE_NAME):$(TAG) $(DOCKER_REACT_IMAGE_NAME):latest


# Starts the application in a container
.PHONY: run
run:
	docker-compose -f docker-compose.yml down
	docker-compose -f docker-compose.yml up

