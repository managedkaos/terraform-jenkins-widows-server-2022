plan refresh init validate output fmt:
	terraform $(@)

list:
	terraform state list

format:
	terraform fmt

upgrade:
	terraform init -upgrade

update:
	terraform get -update

