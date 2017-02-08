IMAGE = 165162103257.dkr.ecr.eu-west-1.amazonaws.com/membersprototype

# GO_PIPELINE_COUNTER is the pipeline number, passed from our build agent.
GO_PIPELINE_COUNTER?="unknown"

# Construct the image tag.
VERSION=0.2.$(GO_PIPELINE_COUNTER)

# ECS-related
ECS_CLUSTER = ci
ECS_APP_NAME = membersprototype
AWS_REGION = eu-west-1

build :
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

run:
	docker run -p 80:3000 $(IMAGE)

dev:
	docker run -p 80:3000 -v ${PWD}:/opt/membersprototype $(IMAGE)

test : build
	docker run $(IMAGE) bundle exec rake

push:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest
	docker rmi $(IMAGE):$(VERSION)
	docker rmi $(IMAGE):latest

# http://serverfault.com/questions/682340/update-the-container-of-a-service-in-amazon-ecs?rq=1
deploy-ci:
	aws ecs register-task-definition --cli-input-json file://./aws_ecs/membersprototype.json
	aws ecs update-service --service $(ECS_APP_NAME) --cluster $(ECS_CLUSTER) --region $(AWS_REGION) --task-definition $(ECS_APP_NAME)
