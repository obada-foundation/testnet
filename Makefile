SHELL := /bin/sh

deploy:
	docker run \
		-it \
		--rm \
		-w /home/ansible/deployment \
		-v $$(pwd)/ssh:/home/ansible/.ssh \
		-v $$(pwd)/deployment:/home/ansible/deployment \
		-v $$(pwd)/inventory:/home/ansible/inventory \
		-v $$(pwd)/testnets:/home/ansible/testnets \
		obada/ansible \
		ansible-playbook node-playbook.yml -i inventory

configure:
	docker run \
		-it \
		--rm \
		-w /home/ansible/deployment \
		-v $$(pwd)/deployment:/home/ansible/deployment \
		obada/ansible \
		ansible-playbook configure-node.yml --inventory localhost --connection=local --limit 127.0.0.1

certificates: ssh/obada_node_ssh_key

ssh/obada_node_ssh_key:
	mkdir -p ssh && docker run \
		-it \
		--rm \
                -v $$(pwd)/ssh:/root/.ssh \
		alpine:3.15 \
		sh -c 'apk add openssh && ssh-keygen -t ed25519 -f $$HOME/.ssh/obada_node_ssh_key -q -N "" && chown 1000:1000 $$HOME/.ssh/obada_node_ssh_key'
