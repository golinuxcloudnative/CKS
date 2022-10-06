```
# deploy dashboard
kubectl apply -f /vagrant/shared/dashboard/dashboard.yaml

# expose via proxy. It's not a safe way. It's just for testing purpose. You could use ingress as well to expose it or change it to NodePort
kubectl proxy --address=0.0.0.0  --accept-hosts=^.*

# access http://10.8.8.100:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

# read user
kubectl apply -f /vagrant/shared/dashboard/read-user.yaml
kubectl -n kubernetes-dashboard get secrets read-user-token-XXXXX -ojsonpath="{.data.token}{'\n'}"


# admin user
kubectl apply -f /vagrant/shared/dashboard/admin-user.yaml
```


# How to create manifests 

- Read service account
`kubectl create serviceaccount -n kubernetes-dashboard read-user --dry-run=client -oyaml > readuser-serviceaccount.yaml`
- Read cluster role
`kubectl create clusterrole cluster-read --dry-run=client --verb=list,get,watch --resource=* -oyaml > cluster-read-clusterrole.yaml`
- binding service account and read cluster role
`kubectl create clusterrolebinding --clusterrole=cluster-read --serviceaccount=kubernetes-dashboard:read-user cluster-read --dry-run=client -oyaml > cluster-read-clusterrolebinding.yaml`