# Provision an EKS Cluster and deploy a simple app using Helm

Deployment Guidelines.

Environment Setup (Guide will be based on Linux – RHEL8)

Ignore below steps if you already have an environment to run git, terraform, aws, helm, kubectl

1). Setup Git

	sudo dnf install git-all
	
    verify: git --version
	
2). Install and configure AWS CLI

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    
    verify: aws --version

aws configure (Make sure to provide you AWS credentials – AWS Access Key ID, AWS Secret)
verify: aws configure list

3). Install and configure Terraform CLI

	sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
	sudo yum -y install terraform
	
    verify: terraform --version

4). Install kubectl

    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOF

    sudo yum install -y kubectl
    
    verify: kubectl version --client

5). Install Helm
	
    curl -fsSL -o get_helm.sh \
    https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    
    verify: helm version

# Deployment of Infrastructure on AWS

1). Clone the git repository

    git clone https://github.com/dulanjanad/Demo-OWASPJuiceShop.git

2). Deploy infrastructure with Terraform

    cd Demo-OWASPJuiceShop/Terraform
    terraform init
    terraform plan
    terraform apply (Type yes and it will take about 15 mins to complete the deployment)

3). Initialize the environment to connect with the EKS cluster
	
    aws eks update-kubeconfig --name OWASPJuiceShop-EKS
    (Make sure to put the correct EKS cluster name if you have changed the default cluster name when applying terraform deploy)

4). Check cluster details
	
	kubectl cluster-info 
    kubectl get nodes
    kubectl get pods -n kube-system (Make sure alb-ingress-controller pod is up and running)

Deployment of Application (One of the two ways can be used)

1). Clone Git repository

    git clone https://github.com/dulanjanad/Demo-OWASPJuiceShop.git

2). Change to helm templates directory
	
	cd Demo-OWASPJuiceShop/Kubernetes/.helm
	
3). Deploy the application with helm
	
	helm upgrade --install --wait --timeout 120s new-deployement .
	(You can specify any deployment name)

4). Verify the deployment.
	
    kubectl get ingress -n development 
    (Created Address will be shown and open it in a web browser in few mins If you have changed the namespace on variables file, make sure to put it instead development)

	helm ls
	
# Destroy Resources

1). Delete the deployment with helm
	helm delete new-deployement (Make sure to put the given deployment name)

2) Destroy AWS resources 
    cd Demo-OWASPJuiceShop/Terraform
    terraform destroy