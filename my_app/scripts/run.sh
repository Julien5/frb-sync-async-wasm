#!/usr/bin/env bash

set -e
set -x

function deploy-app() {
	mkdir -p /tmp/j5/app
	cd /tmp/j5/app
	tar xvf /tmp/webapp.tgz 
}

function main() {
	deploy-app
}

main "$@"
