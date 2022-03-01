# Sample Python Prometheus export

This is a sample app which exports http metrics to prometheus. This also includes deployment config for the app, prometheus and grafana for kubernetes. 
## Python app

Queries different http urls and posts the metrics through prometheus client. This app also includes a http server. The prometheus metrics can be accessed from `/metrics` endpoint. 

Metrics exported: 

`sample_external_url_up`: `0` for successfule http query else `1`

`sample_external_url_response_ms`: Response time for http query


## Pre-requisite:
Make sure to have `python3`, `docker` and `minikube` (or an actual K8s cluster) installed. 

## Setup for the app


Clone the repo and run the following command to install `Python poetry` (python package manager) and all the python dependencies in a virtual environment. 

```
make install
```

You can execute the app with following command,
```
make run
```
Go to http://localost:8000 to see the metrics in Prometheus format. 

## Setup for the kuberentes deployment.

Create a minikube cluster 
```
make minikube
```

Deploy prometheus and grafana in namepsace `monitoring`. 
```
make deploy_prometheus
```
This will promethus with auto discovery capablity. Configs can be found in `/prometheus`

Verify Prometheus : 
```
minikube service prometheus-service -n monitoring
```
Verify Grafana :
```
minikube service grafana -n monitoring
```

Now deploy the sample python app in `sample-app` namespace. 

```
make deploy_app
```

Wait for the ingress to get allocated a IP. The go to the `http://<INGRESS IP>/metrics` to see the prometheus metrics being exported from the app. 

Also query the prometheus dashboard for the metrics. And also query the metrics on grafana to verify.

Dashboard config can be found at `k8s/grafana-dashboard.json`