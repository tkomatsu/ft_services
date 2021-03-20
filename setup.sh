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
	ftps
	grafana
	influxdb
	mysql
	nginx
	phpmyadmin
	wordpress
)

initialize () {
	minikube start --driver=docker
	minikube docker-env
	eval $(minikube -p minikube docker-env)
	kubectl apply -f srcs/config/config.yaml
}

build_container () {
	printf "${GREEN}Image building ...\n${END}"
	for e in ${SERVICE[@]}; do
		printf "${BLUE}${e} building ...\n${END}"
		docker build -t tkomatsu/${e} ./srcs/${e}/
	done
}

install_metallb () {
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	kubectl apply -f srcs/config/metallb-configmap.yaml
}

set_services () {
	printf "${GREEN}Service initializing...\n${END}"
	for e in ${SERVICE[@]}; do
		kubectl apply -f ./srcs/${e}/${e}.yaml
	done
}

greeting () {
	printf ${CYAN}
	echo '  __ _                         _               '
	echo ' / _| |                       (_)              '
	echo '| |_| |_   ___  ___ _ ____   ___  ___ ___  ___ '
	echo '|  _| __| / __|/ _ \ '\''__\ \ / / |/ __/ _ \/ __|'
	echo '| | | |_  \__ \  __/ |   \ V /| | (_|  __/\__ \'
	echo '|_|  \__| |___/\___|_|    \_/ |_|\___\___||___/'
	echo ''
	printf "open `minikube ip`:80 on browser\n${END}"
}

minikube stop
minikube delete
initialize
install_metallb
build_container
set_services
eval $(minikube docker-env -u)
greeting
