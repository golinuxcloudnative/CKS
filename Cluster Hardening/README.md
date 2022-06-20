# Cluster Hardening 15%

## Restrict access to Kubernetes API
https://kubernetes.io/docs/reference/access-authn-authz/
https://kubernetes.io/docs/concepts/security/controlling-access/


User account - humans (developer, admins, devops)
Service account - app that interacts with K8S (prometheus, dashbaord)

X509
Static Token File
Bootstrap Tokens
Service Account Tokens


## Use Role Based Access Controls to minimize exposure
https://kubernetes.io/docs/concepts/security/rbac-good-practices/


## Exercise caution in using service accounts e.g. disable defaults, minimize permissions on newly created ones


## Update Kubernetes frequently