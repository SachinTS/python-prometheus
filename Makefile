
.PHONY: install
install:
	curl -sSL https://install.python-poetry.org | python3 -
	poetry install

.PHONY: run
run:
	poetry run python app/exporter.py

.PHONY: minikube
minikube:
	minikube start --kubernetes-version=v1.20.0 --memory=4g --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0 --vm=true
	minikube addons enable ingress
	
.PHONY: deploy_app
deploy_app:
	eval $$(minikube docker-env) && docker build -t sample-app .
	kubectl apply -f k8s/

.PHONY: deploy_prometheus
deploy_prometheus:
	kubectl apply -k prometheus/
	kubectl apply -k prometheus/grafana/
