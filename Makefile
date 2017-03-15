.PHONY: build run dev test push rmi deploy-ecs

APP_NAME = parliamentukprototype

# The value assigned here is for execution in local machines
# When executed by GoCD it may inject another value from a GoCD environment variable
AWS_ACCOUNT_ID=$(shell aws sts get-caller-identity --output text --query "Account" 2> /dev/null)

# GO_PIPELINE_COUNTER is the pipeline number, passed from our build agent.
GO_PIPELINE_COUNTER?="unknown"

# VERSION is used to tag the Docker images
VERSION=0.2.$(GO_PIPELINE_COUNTER)

# ECS-related
ECS_CLUSTER = ecs
AWS_REGION = eu-west-1
IMAGE = $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(APP_NAME)

build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest \
		--build-arg PARLIAMENT_BASE_URL=$(PARLIAMENT_BASE_URL) \
		--build-arg GTM_KEY=$(GTM_KEY) \
		--build-arg ASSET_LOCATION_URL=$(ASSET_LOCATION_URL) \
		.

# Container port 3000 is specified in the Dockerfile
CONTAINER_PORT = 3000
# Host port of 80 can be changed to any value but remember the app URL would be http://localhost:<host-port>
HOST_PORT = 80

run: build
	docker run --rm -p $(HOST_PORT):$(CONTAINER_PORT) $(IMAGE)

dev:
	docker run -p $(HOST_PORT):$(CONTAINER_PORT) -v ${PWD}:/opt/$(APP_NAME) $(IMAGE)

test: build
	docker run --rm $(IMAGE) bundle exec rake

push:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

rmi:
	docker rmi $(IMAGE):$(VERSION)
	docker rmi $(IMAGE):latest

# http://serverfault.com/questions/682340/update-the-container-of-a-service-in-amazon-ecs?rq=1
deploy-ecs:
# aws ecs register-task-definition --cli-input-json file://./aws_ecs/task-definition.json
	./aws_ecs/register-task-definition.sh $(APP_NAME)
	aws ecs update-service --service $(APP_NAME) --cluster $(ECS_CLUSTER) --region $(AWS_REGION) --task-definition $(APP_NAME)
