Hi this the doc of my experience in creating the EKS cluster from ec2 server using IAM role for aws access. 

1. Generated the ssh key in my local using the ssh key generation cmd - (ssh-keygen -f <keyname> )
2. Created an EC2 instance, store the public key beforehand in aws console (ec2 / network securites / key pair / actions )
3. To build the cluster you needed some pre-requisites cli 
        eksctl, kubectl, aws cli and helm 
 note: you can get the commands from the official doc. or else from this repo you do it by clusterconfiguration.yaml file. 
4. Connect EC2 with AWS:
    Attach an IAM Role directly to your EC2 instance — no keys needed.
        1. Go to AWS Console → IAM → Roles → Create Role
        2. Select EC2 as trusted entity
        3. Attach these policies:
                AmazonEKSClusterPolicy
                AmazonEKSWorkerNodePolicy
                AmazonEC2ContainerRegistryReadOnly
                IAMFullAccess
                AmazonVPCFullAccess
        note: Always use IAM Roles over access keys for EC2 instances — it's more secure and credentials rotate automatically.
                AWS CLI checks credentials in this priority order:
                PrioritySource
                    1st - Environment variables (AWS_ACCESS_KEY_ID)
                    2nd - ~/.aws/credentials file 
                    3rd - ~/.aws/config file
                    4th - EC2 IAM Role
        4. Go to EC2 → Your Instance → Actions → Security → Modify IAM Role
        5. Attach the role → click Update IAM Role
        6. Verify on EC2:
                aws sts get-caller-identity
5. Create EKS Cluster:
        We can create the EKS cluster from the official git eksctl repo files or your custom build files. I made a custom build basic file by going eks repo, adding the needed lines. you can check the cluster.yaml file.

        cmd to create the cluster: eksctl create cluster -f cluster.yaml(add your configured file name ) and it will take quite some time (~15–20 mins or long)
6. Configure kubectl to Connect to EKS
        after cluster creation it usually updates kubeconfig automatically, but it's good practice to run it explicitly:
                aws eks update-kubeconfig --region us-east-1 --name cluster-1
            then verify it by: kubectl get nodes



troubleshoot:

when creating cluster i faced some issues i want to discuss.
1. I got this error while running create cluster command:

AccessDeniedException: User: arn:aws:sts::070815351274:assumed-role/clustersetup/i-079cb5893f02a2473 is not authorized to perform: eks:DescribeClusterVersions on resource: arn:aws:eks:us-east-1:070815351274:* because no identity-based policy allows the eks:DescribeClusterVersions action

We can clearly see that  IAM Role clustersetup is missing EKS permissions. You need to add the required policies.
We can get the required policies by simply searching through search engine or official docs. 
Also create the Inline Policy for missing EKS actions
verify permissions by 
        aws eks describe-cluster-versions --region us-east-1

you can troubleshoot it by using below commands 

error: cluster hasn't been created properly, you may wish to check CloudFormation console
# Check the failed stack events
aws cloudformation describe-stack-events \
  --stack-name eksctl-cluster1-nodegroup-cluster1 \
  --region us-east-1 \
  --query 'StackEvents[?ResourceStatus==`CREATE_FAILED`].[ResourceType,ResourceStatusReason]' \
  --output table

# check node port status 
aws eks describe-nodegroup \
  --cluster-name cluster1 \
  --nodegroup-name cluster1 \
  --region us-east-1 \
  --query 'nodegroup.health'

# Check service quotas for EC2
aws service-quotas get-service-quota \
  --service-code ec2 \
  --quota-code L-1216C47A \
  --region us-east-1

# Check if node role was created
aws iam list-roles | grep cluster1




note: before creating the same cluster after any error better to delete the previously created cluster and try new 

Command to cleanup failed cluster: 
                    eksctl delete cluster --region=us-east-1 --name=<cluster name>
 and verify it by 
        
        aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE --region us-east-1 | grep cluster1 

        or

you can also delete and check by using CloudFormation console 
