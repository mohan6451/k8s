

            AWS EKS Kubernetes

            eksctl & kubectl Commands Reference Guide

Cluster Operations
Command	Description
eksctl create cluster --name <n> --region <r>	Create cluster (simple)
eksctl create cluster -f cluster.yaml	Create cluster from config file
eksctl get cluster	List all clusters
eksctl get cluster --name <n> --region <r>	Describe specific cluster
eksctl delete cluster --name <n> --region <r>	Delete cluster
eksctl upgrade cluster --name <n> --version 1.30 --approve	Upgrade Kubernetes version

Node Group Operations
Command	Description
eksctl get nodegroup --cluster <n>	List node groups
eksctl create nodegroup --cluster <n> --name <ng> --node-type t3.medium	Create node group
eksctl scale nodegroup --cluster <n> --name <ng> --nodes 3	Scale node group
eksctl delete nodegroup --cluster <n> --name <ng>	Delete node group
eksctl upgrade nodegroup --cluster <n> --name <ng>	Upgrade node group
eksctl drain nodegroup --cluster <n> --name <ng>	Drain node group

IAM Operations
Command	Description
eksctl utils associate-iam-oidc-provider --cluster <n> --approve	Create OIDC provider
eksctl create iamserviceaccount --cluster <n> --name <sa>	Create IAM service account
eksctl get iamserviceaccount --cluster <n>	List IAM service accounts
eksctl delete iamserviceaccount --cluster <n> --name <sa>	Delete IAM service account

Addon Operations
Command	Description
eksctl get addon --cluster <n>	List addons
eksctl create addon --cluster <n> --name vpc-cni --version latest	Create addon
eksctl update addon --cluster <n> --name vpc-cni	Update addon
eksctl delete addon --cluster <n> --name vpc-cni	Delete addon

Fargate Operations
Command	Description
eksctl create fargateprofile --cluster <n> --name <fp> --namespace <ns>	Create Fargate profile
eksctl get fargateprofile --cluster <n>	List Fargate profiles
eksctl delete fargateprofile --cluster <n> --name <fp>	Delete Fargate profile

Utility Commands
Command	Description
eksctl utils write-kubeconfig --cluster <n>	Write kubeconfig
aws eks update-kubeconfig --name <n> --region <r>	Update kubeconfig (AWS CLI)
eksctl utils update-cluster-logging --cluster <n> --enable-types all --approve	Enable CloudWatch logs
eksctl utils describe-stacks --cluster <n>	Describe CloudFormation stacks

7. kubectl Command Reference

Cluster & Context
Command	Description
kubectl cluster-info	View cluster info
kubectl config get-contexts	List all contexts
kubectl config use-context <ctx>	Switch context
kubectl config current-context	View current context
kubectl config view	View full kubeconfig
kubectl config set-context --current --namespace=<ns>	Set default namespace

Nodes
Command	Description
kubectl get nodes	List all nodes
kubectl get nodes -o wide	List nodes with IP, OS, version
kubectl describe node <name>	Describe a node
kubectl top node	Node CPU/memory usage
kubectl cordon <node>	Mark node as unschedulable
kubectl uncordon <node>	Mark node as schedulable
kubectl drain <node> --ignore-daemonsets	Evict all pods from node

Namespaces
Command	Description
kubectl get namespaces	List namespaces
kubectl create namespace <ns>	Create namespace
kubectl delete namespace <ns>	Delete namespace
kubectl get all -n <ns>	Get all resources in namespace
kubectl get all -A	Get resources in ALL namespaces

Pods
Command	Description
kubectl get pods	List pods (current namespace)
kubectl get pods -o wide	List pods with details
kubectl get pods -A	List pods in all namespaces
kubectl describe pod <name>	Describe a pod
kubectl logs <pod>	Get pod logs
kubectl logs -f <pod>	Follow live logs
kubectl logs <pod> --previous	Logs from crashed container
kubectl logs <pod> -c <container>	Logs from specific container
kubectl exec -it <pod> -- /bin/bash	Shell into pod
kubectl delete pod <pod>	Delete pod
kubectl delete pod <pod> --force --grace-period=0	Force delete pod
kubectl get pods -w	Watch pod status
kubectl get pods -l app=my-app	Get pods by label

Deployments
Command	Description
kubectl get deployments	List deployments
kubectl create deployment <n> --image=nginx --replicas=3	Create deployment
kubectl describe deployment <n>	Describe deployment
kubectl scale deployment <n> --replicas=5	Scale deployment
kubectl set image deployment/<n> <c>=nginx:1.25	Update image (rolling update)
kubectl rollout status deployment/<n>	Check rollout status
kubectl rollout history deployment/<n>	View rollout history
kubectl rollout undo deployment/<n>	Rollback to previous version
kubectl rollout undo deployment/<n> --to-revision=2	Rollback to specific revision
kubectl rollout pause deployment/<n>	Pause rollout
kubectl rollout resume deployment/<n>	Resume rollout
kubectl delete deployment <n>	Delete deployment

Services
Command	Description
kubectl get svc	List services
kubectl describe svc <name>	Describe service
kubectl expose deployment <n> --type=LoadBalancer --port=80	Expose as LoadBalancer
kubectl delete svc <name>	Delete service
kubectl port-forward svc/<name> 8080:80	Port-forward to localhost

Service Types:
Type	Description
ClusterIP	Internal cluster access only (default)
NodePort	Exposes on each node's IP and a static port
LoadBalancer	Creates AWS ELB — external access
ExternalName	Maps to an external DNS name

ConfigMaps & Secrets
Command	Description
kubectl create configmap <n> --from-literal=key=val	Create ConfigMap
kubectl create configmap <n> --from-file=config.properties	ConfigMap from file
kubectl get configmap	List ConfigMaps
kubectl describe configmap <n>	Describe ConfigMap
kubectl create secret generic <n> --from-literal=user=admin	Create Secret
kubectl create secret tls <n> --cert=tls.crt --key=tls.key	Create TLS Secret
kubectl get secrets	List Secrets
kubectl get secret <n> -o jsonpath='{.data.key}' | base64 --decode	Decode secret value

Apply & Manage YAML Files
Command	Description
kubectl apply -f deployment.yaml	Apply a manifest
kubectl apply -f ./manifests/	Apply all files in directory
kubectl apply -f https://example.com/manifest.yaml	Apply from URL
kubectl delete -f deployment.yaml	Delete using manifest
kubectl apply -f deployment.yaml --dry-run=client	Dry run (test without applying)
kubectl diff -f deployment.yaml	View diff before applying

Resource Monitoring
Command	Description
kubectl top pods	Pod CPU/memory usage
kubectl top nodes	Node CPU/memory usage
kubectl top pods -A	Top pods in all namespaces
kubectl get events --sort-by=.metadata.creationTimestamp	Get events sorted by time
kubectl get events -w	Watch events live

Ingress, PV & PVC
Command	Description
kubectl get ingress -A	List all ingress
kubectl get pv	List Persistent Volumes
kubectl get pvc	List Persistent Volume Claims
kubectl describe pvc <name>	Describe PVC

8. kubectl Troubleshooting Reference

Problem	Command
Pod stuck in Pending	kubectl describe pod <name> → check Events section
Pod CrashLoopBackOff	kubectl logs <pod> --previous
Node not ready	kubectl describe node <name>
Service not reachable	kubectl get endpoints <svc-name>
Image pull error	kubectl describe pod <name> → check image name/tag
Check all warnings	kubectl get events -A --field-selector type=Warning

9. Useful Shell Aliases

Add these to ~/.bashrc for faster access:
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kaf='kubectl apply -f'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias kx='kubectl exec -it'

source ~/.bashrc

10. Quick Reference Cheat Sheet

Task	eksctl Command	kubectl Command
Create cluster	eksctl create cluster -f cluster.yaml	—
Delete cluster	eksctl delete cluster --name <n>	—
List nodes	eksctl get nodegroup --cluster <n>	kubectl get nodes -o wide
Scale nodes	eksctl scale nodegroup --nodes 3	kubectl scale deployment <n> --replicas=3
Get cluster info	eksctl get cluster	kubectl cluster-info
Update kubeconfig	eksctl utils write-kubeconfig	aws eks update-kubeconfig
View logs	—	kubectl logs -f <pod>
Shell into pod	—	kubectl exec -it <pod> -- /bin/bash
Apply manifest	—	kubectl apply -f file.yaml
Check resources	—	kubectl top pods / top nodes


