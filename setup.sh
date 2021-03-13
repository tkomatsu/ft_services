#!/bin/bash

GREY="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PURPLE="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
END="\033[0m"

SERVICE=(
#	ftps
#	grafana
#	influxdb
	mysql
	nginx
#	phpmyadmin
#	wordpress
)

initialize () {
	minikube start --driver=docker --extra-config=apiserver.service-node-port-range=1-65535
	minikube docker-env
	eval $(minikube -p minikube docker-env)
	kubectl apply -f srcs/secret.yaml
}

build_container () {
	printf "${GREEN}Image building ...\n${END}"
	for e in ${SERVICE[@]}; do
		docker build -t tkomatsu/${e} ./srcs/${e}/
	done
}

install_metallb () {
#	# see what changes would be made, returns nonzero returncode if different
#	kubectl get configmap kube-proxy -n kube-system -o yaml | \
#	sed -e "s/strictARP: false/strictARP: true/" | \
#	sed -e "s/mode: \"\"/mode: \"ipvs\"/" | \
#	kubectl diff -f - -n kube-system
#	# apply
#	kubectl get configmap kube-proxy -n kube-system -o yaml | \
#	sed -e "s/strictARP: false/strictARP: true/" | \
#	sed -e "s/mode: \"\"/mode: \"ipvs\"/" | \
#	kubectl apply -f - -n kube-system

	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	kubectl apply -f srcs/metallb/metallb-configmap.yaml
}

set_services () {
	printf "${GREEN}Service initializing...\n${END}"
	for e in ${SERVICE[@]}; do
		kubectl apply -f ./srcs/${e}/${e}.yaml
	done
}

minikube stop
minikube delete
initialize
build_container
install_metallb
set_services
eval $(minikube docker-env -u)
