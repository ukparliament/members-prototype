IMAGE = 165162103257.dkr.ecr.eu-west-1.amazonaws.com/membersprototype

# GO_PIPELINE_COUNTER is the pipeline number, passed from our build agent.
GO_PIPELINE_COUNTER?="unknown"
DOCKER_SWARM_URL?="unknown"

# Construct the image tag.
VERSION=0.1.$(GO_PIPELINE_COUNTER)

# ECS-related
ECS_CLUSTER = ci
ECS_APP_NAME = MembersPrototype
AWS_REGION = eu-west-1

build :
	# docker-compose build
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

run :
	docker-compose up -d

runalone:
	docker run -p 80:3000 $(IMAGE)
	# Container port 3000 is specified in Dockerfile
	# Browse to http://localhost:80 to see the application

run-docker-cloud:
	docker-cloud stack up

runalone-docker-cloud:
	docker-cloud stack up -f docker-cloud.standalone.yml

rebuild :
	docker-compose down
	docker-compose up -d

test :
	docker-compose run web rake spec
	docker-compose down

push: build
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest
	docker rmi $(IMAGE):$(VERSION)
	docker rmi $(IMAGE):latest

deploy-ci:
	export DOCKER_HOST=$(DOCKER_SWARM_URL) && export IMAGE_NAME=$(IMAGE):$(VERSION) && docker-compose -f docker-compose.ci.yml down && docker-compose -f docker-compose.ci.yml up -d

# http://serverfault.com/questions/682340/update-the-container-of-a-service-in-amazon-ecs?rq=1
deploy-ecs-ci:
	aws ecs register-task-definition --cli-input-json file://./aws_ecs/members-prototype.json
	aws ecs update-service --service $(ECS_APP_NAME) --cluster $(ECS_CLUSTER) --region $(AWS_REGION) --task-definition $(ECS_APP_NAME)

scale-ci:
	export DOCKER_HOST=$(DOCKER_SWARM_URL) && export IMAGE_NAME=$(IMAGE):$(VERSION) && docker-compose -f docker-compose.ci.yml scale web=3
