deploy:
	docker run \
		-it \
		--rm \
		-v $$(pwd)/ssh:/home/ansible/ssh \
		-v $$(pwd)/deployment:/home/ansible/deployment \
		-v $$(pwd)/inventory:/home/ansible/inventory \
		obada/ansible \
		ansible-playbook deployment/playbook.yml -i inventory
