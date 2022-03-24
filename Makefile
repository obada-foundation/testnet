SHELL := /bin/sh

deploy:
	docker run \
		-it \
		--rm \
		-v $$(pwd)/ssh:/home/ansible/.ssh \
		-v $$(pwd)/deployment:/home/ansible/deployment \
		-v $$(pwd)/inventory:/home/ansible/inventory \
		-v $$(pwd)/testnets:/home/ansible/testnets \
		obada/ansible \
		ansible-playbook deployment/playbook.yml -i inventory
