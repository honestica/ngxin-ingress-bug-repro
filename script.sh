set -x

helm init --upgrade --wait

helm upgrade nginx-ingress --set controller.extraArgs.v=2 --set controller.ingressClass=nginx --set controller.service.enableHttps=false ./nginx-ingress --install --kube-context minikube --namespace ingress

sleep 30

kubectl logs --tail 200 -lapp=nginx-ingress -n ingress

kubectl create -f templates_bug.yml
kubectl get ingress --all-namespaces -o yaml

sleep 10
kubectl logs --tail 200 -lapp=nginx-ingress -n ingress

kubectl scale --replicas=5 deployment/release-name-lfapp-web
sleep 10
kubectl logs --tail 200 -lapp=nginx-ingress -n ingress

kubectl scale --replicas=1 deployment/release-name-lfapp-web
sleep 10
kubectl logs --tail 200 -lapp=nginx-ingress -n ingress

kubectl scale --replicas=5 deployment/release-name-lfapp-web
sleep 10
kubectl logs --tail 200 -lapp=nginx-ingress -n ingress

kubectl scale --replicas=1 deployment/release-name-lfapp-web
sleep 20
kubectl logs --tail 200 -lapp=nginx-ingress -n ingress

kubectl scale --replicas=5 deployment/release-name-lfapp-web
sleep 2
kubectl scale --replicas=1 deployment/release-name-lfapp-web
sleep 2
kubectl scale --replicas=5 deployment/release-name-lfapp-web
sleep 10
kubectl scale --replicas=1 deployment/release-name-lfapp-web
sleep 20

kubectl logs --tail 800 -lapp=nginx-ingress -n ingress
