# Cluster Setup	10%

https://kubernetes.io/docs/concepts/security/overview/

## Use Network security policies to restrict cluster level access

https://kubernetes.io/docs/concepts/services-networking/network-policies/

## Use CIS benchmark to review the security configuration of Kubernetes componenents (etc, kubelet, kubedns, kubeapi)

It's [a set of best practices](https://www.cisecurity.org/benchmark/kubernetes) to keep a Kubernetes environments secure. Most of the recommendions are valid for deployed Kubernetes. For [AKS](https://xx), [GKE](https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks) e [EKS ](https://) see the respective pages.

Some tools
  * CIS-CAT
  * [kube-bench](https://github.com/aquasecurity/kube-bench)



## Properly set up Ingress objects with security control
## Protect node metadata and endpoints
## Minimize use of, and access to, GUI elements
## Verify plataform binaries before deploying