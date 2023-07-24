# EKS Bootstrap
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
This module provides a set of reusable, configurable, and scalable AWS EKS bootstrap configurations. It enables users to easily deploy and manage a highly available EKS cluster using infrastructure as code. This module supports a wide range of features, including node termination handlers, VPC CNI add-ons, service monitors, Istio service meshes, Velero backups, and Karpenter provisioners. Users can configure these features using a set of customizable variables that allow for fine-grained control over the deployment. Additionally, this module is regularly updated to keep pace with the latest changes in the EKS ecosystem, ensuring that users always have access to the most up-to-date features and functionality.

## Usage Example
```hcl
module "eks_bootstrap" {
  source                        = "squareops/eks-bootstrap/aws"
  name                          = "skaf"
  vpc_id                        = "vpc-06e37f0786b7eskaf"
  environment                   = "production"
  ipv6_enabled                  = true
  kms_key_arn                   = "arn:aws:kms:region:222222222222:key/kms_key_arn"
  keda_enabled                  = true
  kms_policy_arn                = "arn:aws:iam::222222222222:policy/kms_policy_arn" ## eks module will create kms_policy_arn
  eks_cluster_name              = "cluster_name"
  reloader_enabled              = true
  karpenter_enabled             = true
  private_subnet_ids            = [""]
  single_az_sc_config           = [{ name = "infra-service-sc", zone = "zone-name" }]
  kubeclarity_enabled           = false
  kubeclarity_hostname          = ""
  kubecost_enabled              = false
  kubecost_hostname             = ""
  cert_manager_enabled          = true
  worker_iam_role_name          = "worker_iam_role_name"
  ingress_nginx_enabled         = true
  metrics_server_enabled        = true
  external_secrets_enabled      = true
  amazon_eks_vpc_cni_enabled    = true
  cluster_autoscaler_enabled    = true
  service_monitor_crd_enabled   = true
  istio_enabled                 = false
  istio_config = {
    ingress_gateway_enabled             = true
    ingress_gateway_namespace           = "istio-ingressgateway"
    egress_gateway_enabled              = true
    egress_gateway_namespace            = "istio-egressgateway"
    observability_enabled               = true
    envoy_access_logs_enabled           = true
    prometheus_monitoring_enabled       = true
    cert_manager_cluster_issuer_enabled = true
  }
  karpenter_provisioner_enabled = true
  karpenter_provisioner_config = {
    private_subnet_name    = "private_subnet_name"
    instance_capacity_type = ["spot"]
    excluded_instance_type = ["nano", "micro", "small"]
    instance_hypervisor    = ["nitro"]   ## Instance hypervisor is picked up only if IPv6 enable is chosen
  }
  cert_manager_letsencrypt_email                = "email@example.com"
  internal_ingress_nginx_enabled                = true
  efs_storage_class_enabled                     = true
  aws_node_termination_handler_enabled          = true
  amazon_eks_aws_ebs_csi_driver_enabled         = true
  cluster_propotional_autoscaler_enabled        = true
  single_az_ebs_gp3_storage_class_enabled       = true
  cert_manager_install_letsencrypt_http_issuers = true
  velero_enabled                                = false
  velero_config = {
    namespaces                      = "my-application" ## If you want full cluster backup, leave it blank else provide namespace.
    slack_notification_token        = "xoxb-slack-token"
    slack_notification_channel_name = "slack-notifications-channel"
    retention_period_in_days        = 45
    schedule_backup_cron_time       = "* 6 * * *"
    velero_backup_name              = "my-application-backup"
    backup_bucket_name              = "velero-cluster-backup"
  }
}


```

## Compatibility

| Release | Kubernetes 1.23 | Kubernetes 1.24  | Kubernetes 1.25 |  Kubernetes 1.26 |
|------------------|------------------|------------------|----------------------|----------------------|
| Release 1.0.0  | &#x2714;  | &#x2717;  | &#x2717; | &#x2717; |
| Release 1.0.1  | &#x2714;  | &#x2714;  | &#x2714; | &#x2717; |
| Release 1.1.0  | &#x2714;  | &#x2714;  | &#x2714; | &#x2717; |
| Release 2.0.0  | &#x2714;  | &#x2714;  | &#x2714; | &#x2717; |
| Release 2.1.0  | &#x2714;  | &#x2714;  | &#x2714; | &#x2717;  |
| Release 3.0.0  | &#x2714;  | &#x2714;  | &#x2714; |  &#x2714; |
| Release 3.1.0  | &#x2714;  | &#x2714;  | &#x2714; |  &#x2714; |

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/squareops/terraform-aws-eks-bootstrap/blob/main/IAM.md)

## Addons Details
Kubernetes addons are additional components that can be installed in a Kubernetes cluster to provide extra features and functionality. They are designed to work seamlessly with the Kubernetes API and can be managed just like any other Kubernetes resource. Some common examples of Kubernetes addons include:

<details>
  <summary> AWS ALB </summary>
Amazon Web Services (AWS) Application Load Balancer (ALB) is a highly available and scalable load balancing service that routes incoming application traffic to multiple Amazon EC2 instances, containers, and IP addresses. It automatically distributes incoming application traffic across multiple targets, ensuring that your applications are highly available and scalable.

With AWS ALB, you can handle increased traffic levels, automatically scale your applications, and improve the overall performance of your applications. ALB provides advanced routing capabilities, including content-based routing, host-based routing, and path-based routing, enabling you to route traffic to different target groups based on specific rules.
</details>
<details>
  <summary> Node Termination Handler </summary>
In AWS, the Node termination handler can be used in Lambda functions or EC2 instances to handle the termination of the underlying instance or container. When an instance or container is terminated, the termination handler can be used to perform any necessary cleanup operations, such as closing open resources, before the instance or container is terminated.
In an EC2 instance, the termination handler can be set by writing a script that runs on instance startup and sets the process.on('SIGTERM', callback) method. This script can be executed using a user data script or by adding it to the instance's startup script.
</details>
<details>
  <summary> EBS </summary>
Amazon Elastic Block Store (Amazon EBS) storage classes are different levels of performance and cost for Amazon EBS volumes. The storage classes determine the type of storage, performance characteristics, and cost of each Amazon EBS volume.

There are currently four Amazon EBS storage classes:

    Standard storage class: This is the default and most widely used storage class, offering a balance of low cost and high performance. It's suitable for a wide range of applications, including boot volumes, transactional databases, and big data workloads.

    Provisioned IOPS (input/output operations per second) storage class: This class provides high-performance I/O for mission-critical and I/O-intensive workloads, such as large databases and I/O-bound applications.

    Cold storage class: This class provides low-cost storage for infrequently accessed data, such as backups and archives. Cold storage is designed to deliver low cost and high durability.

    Throughput Optimized HDD (hard disk drive) storage class: This class provides low-cost storage optimized for large, sequential workloads, such as big data and data warehouses.
</details>
<details>
  <summary> Cert Manager </summary>
  Cert Manager is a Kubernetes add-on that automates the management and issuance of TLS certificates from various issuing sources. It helps to eliminate manual steps in the certificate management process, provides cert renewals and integrates with other parts of the system.
</details>
<details>
  <summary> Cluster Autoscalar </summary>
Cluster Autoscaler is a Kubernetes component that automatically adjusts the number of nodes in a cluster based on the demand for resources. This allows you to optimize the cost of running your workloads while ensuring that they have the resources they need to run effectively.
The Cluster Autoscaler works by monitoring the resource usage of your pods and comparing it to the available capacity on the nodes in the cluster. If there are pods that cannot be scheduled because of resource constraints, the Cluster Autoscaler will increase the number of nodes in the cluster until there is enough capacity to schedule the pending pods. Similarly, if there are nodes in the cluster that are underutilized, the Cluster Autoscaler can decrease the number of nodes to optimize resource utilization and reduce costs.
Cluster Autoscaler is supported by many cloud providers, including Amazon Web Services (AWS), Google Cloud Platform (GCP), and Microsoft Azure. It can be easily integrated into your existing Kubernetes deployment and can be configured to use different scaling policies to meet the needs of your specific workloads.
</details>
<details>
  <summary> EFS </summary>
Amazon Elastic File System (Amazon EFS) is a fully managed, scalable, and highly available file storage service for use with Amazon Elastic Compute Cloud (Amazon EC2) instances. It provides a simple and scalable file storage solution that can be used by multiple EC2 instances at the same time, making it ideal for use cases such as big data, content management, and media sharing.

Amazon EFS is easy to set up, manage, and scale, and it automatically replicates data across multiple Availability Zones for high durability and availability. The service is also highly performant, with low latency and high throughput, making it suitable for a wide range of workloads.
</details>
<details>
  <summary> External Secrets </summary>
Kubernetes External Secrets is a feature in Kubernetes that allows secrets to be stored and managed outside of the cluster. External secrets are useful in scenarios where sensitive information, such as passwords or API keys, should not be stored directly in the cluster, but still needs to be used by applications running in the cluster.
Kubernetes External Secrets can be stored in external systems such as Hashicorp Vault, AWS Secrets Manager, or GCP Secret Manager, and accessed by pods using a Kubernetes Secret object. The Secret object references the external secret and maps it to a Kubernetes Secret, which can then be used by pods in the same way as regular Kubernetes Secrets.
By using External Secrets, organizations can ensure that sensitive information is securely managed and stored outside of the cluster, while still being able to use that information in their applications running in the cluster.
</details>
<details>
  <summary> Istio </summary>
Istio is an open-source service mesh platform that provides a set of tools for managing and securing microservices applications. Istio is designed to work with containerized applications and is built on top of Kubernetes, making it easy to deploy and manage.
Some of the key features of Istio include:
Traffic management: Istio provides the ability to control the flow of traffic between microservices, including load balancing, fault tolerance, and canary releases.
Security: Istio provides built-in security features, such as mutual TLS authentication, for securing communication between microservices.
Observability: Istio provides robust observability features, including distributed tracing, metric collection, and logging, making it easy to monitor and debug microservices applications.
Configurable policies: Istio provides a flexible policy framework for controlling the behavior of microservices, allowing for easy enforcement of security, observability, and traffic management policies.
Istio is widely adopted and has a strong ecosystem of partners and contributors, making it a popular choice for organizations looking to build and manage microservices applications. By using Istio, organizations can improve the reliability and security of their microservices applications and simplify the process of managing and operating them.
</details>
<details>
  <summary> Karpenter </summary>
Karpenter is a flexible, high-performance Kubernetes cluster autoscaler that helps improve application availability and cluster efficiency. Karpenter launches right-sized compute resources, (for example, Amazon EC2 instances), in response to changing application load in under a minute. Through integrating Kubernetes with AWS, Karpenter can provision just-in-time compute resources that precisely meet the requirements of your workload. Karpenter automatically provisions new compute resources based on the specific requirements of cluster workloads. These include compute, storage, acceleration, and scheduling requirements. Amazon EKS supports clusters using Karpenter, although Karpenter works with any conformant Kubernetes cluster.
</details>
<details>
  <summary> Metrics Server </summary>
Metric Server is a Kubernetes add-on that collects resource usage data from the Kubernetes API server and makes it available to other components, such as the Horizontal Pod Autoscaler (HPA) and the Cluster Autoscaler.
The Metric Server collects data on the CPU and memory usage of pods and nodes in a cluster, and provides this data to other components in a format that they can use to make scaling decisions. The HPA, for example, can use the data provided by the Metric Server to automatically scale the number of replicas of a deployment based on the resource usage of the pods. The Cluster Autoscaler can also use this data to determine when to add or remove nodes from a cluster based on the resource utilization of the pods and nodes.
Metric Server provides a simple and effective way to collect resource usage data from a cluster and make it available to other components for scaling and resource optimization. It is an important component for ensuring that your Kubernetes applications run effectively and efficiently in the cloud.
</details>
<details>
  <summary> Nginx Ingress Controller </summary>
Nginx Ingress Controller is a Kubernetes controller that manages external access to services running in a Kubernetes cluster. It provides load balancing, SSL termination, and name-based virtual hosting, among other features.
The Nginx Ingress Controller works by using the Kubernetes API to dynamically configure an Nginx instance running outside of the cluster to route traffic to services within the cluster. This allows you to easily expose your services to external users and manage the routing of incoming traffic.
The Nginx Ingress Controller provides a flexible and powerful way to manage incoming traffic to your Kubernetes applications. It is widely used in production environments and is well-suited for both simple and complex routing scenarios. Additionally, the Nginx Ingress Controller integrates with other Kubernetes components, such as the Kubernetes Ingress resource and cert-manager, to provide a complete solution for managing external access to your services.
</details>
<details>
  <summary> Reloader </summary>
Reloader can watch changes in ConfigMap and Secret and do rolling upgrades on Pods with their associated DeploymentConfigs, Deployments, Daemonsets, Statefulsets and Rollouts.
</details>
<details>
  <summary> Velero </summary>
Velero (previously known as Heptio Ark) is an open-source backup and disaster recovery solution for Kubernetes. Velero provides the ability to back up and restore Kubernetes cluster resources and persistent volumes, making it easy to recover from data loss or cluster failures.
Some key features of Velero include:
Cluster Backup and Restore: Velero allows users to create backups of their Kubernetes clusters and restore them to the same or different cluster.
Persistent Volume Backup and Restore: Velero provides the ability to backup and restore persistent volumes, ensuring that data can be recovered even if the cluster fails.
Incremental Backups: Velero supports incremental backups, which can be performed more frequently than full backups and reduce the amount of data transferred.
Snapshot Integration: Velero integrates with cloud provider snapshot services, such as AWS EBS and GCE PD, to simplify the backup process and reduce the cost of storing backup data.
Easy to Use CLI: Velero provides a user-friendly CLI that makes it easy to create, manage, and restore backups.
Velero is designed to work with cloud native environments, making it a popular choice for organizations that run their applications in the cloud. By using Velero, organizations can improve the reliability and availability of their applications and ensure that they can recover from data loss or cluster failures.
</details>
<details>
  <summary> KubeClarity </summary>
  KubeClarity helps you to secure your cloud-native applications and infrastructure by offering features such as automated threat detection, policy enforcement, compliance reporting, and continuous monitoring. It allows you to enforce security policies across all your Kubernetes environments and provides automated remediation of security issues, ensuring that your deployments are always secure and compliant.
</details>
<details>
  <summary> Kubecost </summary>
  Kubecost provides real-time cost visibility and insights for teams using Kubernetes, helping you continuously reduce your cloud costs. Breakdown costs by any Kubernetes concepts, including deployment, service, namespace label, and more.
</details>

## Notes

Before enabling the **Kubecost** addon for your Amazon EKS cluster, please make sure to subscribe to the **Kubecost - Amazon EKS cost monitoring** license.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.23 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.23 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.6 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.13 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs"></a> [efs](#module\_efs) | ./addons/efs | n/a |
| <a name="module_istio"></a> [istio](#module\_istio) | ./addons/istio | n/a |
| <a name="module_k8s_addons"></a> [k8s\_addons](#module\_k8s\_addons) | ./EKS-Blueprint/modules/kubernetes-addons | n/a |
| <a name="module_karpenter_provisioner"></a> [karpenter\_provisioner](#module\_karpenter\_provisioner) | ./addons/karpenter_provisioner | n/a |
| <a name="module_service_monitor_crd"></a> [service\_monitor\_crd](#module\_service\_monitor\_crd) | ./addons/service_monitor_crd | n/a |
| <a name="module_single_az_sc"></a> [single\_az\_sc](#module\_single\_az\_sc) | ./addons/aws-ebs-storage-class | n/a |
| <a name="module_velero"></a> [velero](#module\_velero) | ./addons/velero | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.kubecost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_iam_instance_profile.karpenter_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [helm_release.cert_manager_le_http](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.coredns-hpa](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.internal_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kubeclarity](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metrics-server-vpa](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.vpa-crds](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_ingress_v1.kubecost](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.internal_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.kube_clarity](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.kube_clarity](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.kubecost](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_password.kube_clarity](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.kubecost](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_addon_version.kubecost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [kubernetes_service.internal-nginx-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |
| [kubernetes_service.istio-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |
| [kubernetes_service.nginx-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_eks_aws_ebs_csi_driver_enabled"></a> [amazon\_eks\_aws\_ebs\_csi\_driver\_enabled](#input\_amazon\_eks\_aws\_ebs\_csi\_driver\_enabled) | Whether to enable the EKS Managed AWS EBS CSI Driver add-on or not. | `bool` | `false` | no |
| <a name="input_amazon_eks_vpc_cni_enabled"></a> [amazon\_eks\_vpc\_cni\_enabled](#input\_amazon\_eks\_vpc\_cni\_enabled) | Enable or disable the installation of the Amazon EKS VPC CNI addon. | `bool` | `false` | no |
| <a name="input_aws_load_balancer_version"></a> [aws\_load\_balancer\_version](#input\_aws\_load\_balancer\_version) | Specify the version of the AWS Load Balancer Controller for Ingress | `string` | `"1.4.4"` | no |
| <a name="input_aws_node_termination_handler_enabled"></a> [aws\_node\_termination\_handler\_enabled](#input\_aws\_node\_termination\_handler\_enabled) | Enable or disable node termination handler | `bool` | `false` | no |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Enable or disable the cert manager add-on for EKS cluster. | `bool` | `false` | no |
| <a name="input_cert_manager_install_letsencrypt_http_issuers"></a> [cert\_manager\_install\_letsencrypt\_http\_issuers](#input\_cert\_manager\_install\_letsencrypt\_http\_issuers) | Enable or disable the HTTP issuer for cert-manager | `bool` | `false` | no |
| <a name="input_cert_manager_install_letsencrypt_r53_issuers"></a> [cert\_manager\_install\_letsencrypt\_r53\_issuers](#input\_cert\_manager\_install\_letsencrypt\_r53\_issuers) | Enable or disable the creation of Route53 issuer while installing cert manager. | `bool` | `false` | no |
| <a name="input_cert_manager_letsencrypt_email"></a> [cert\_manager\_letsencrypt\_email](#input\_cert\_manager\_letsencrypt\_email) | Specifies the email address to be used by cert-manager to request Let's Encrypt certificates | `string` | `""` | no |
| <a name="input_cluster_autoscaler_chart_version"></a> [cluster\_autoscaler\_chart\_version](#input\_cluster\_autoscaler\_chart\_version) | Version of the cluster autoscaler helm chart | `string` | `"9.29.0"` | no |
| <a name="input_cluster_autoscaler_enabled"></a> [cluster\_autoscaler\_enabled](#input\_cluster\_autoscaler\_enabled) | Whether to enable the Cluster Autoscaler add-on or not. | `bool` | `false` | no |
| <a name="input_cluster_issuer"></a> [cluster\_issuer](#input\_cluster\_issuer) | Specify the letsecrypt cluster-issuer for ingress tls. | `string` | `"letsencrypt-prod"` | no |
| <a name="input_cluster_propotional_autoscaler_enabled"></a> [cluster\_propotional\_autoscaler\_enabled](#input\_cluster\_propotional\_autoscaler\_enabled) | Enable or disable Cluster propotional autoscaler add-on | `bool` | `false` | no |
| <a name="input_core_dns_hpa_config"></a> [core\_dns\_hpa\_config](#input\_core\_dns\_hpa\_config) | Configuration to provide settings of hpa over core dns | `any` | <pre>{<br>  "corednsdeploymentname": "coredns",<br>  "maxReplicas": 10,<br>  "minReplicas": 2,<br>  "targetCPUUtilizationPercentage": 80,<br>  "targetMemoryUtilizationPercentage": "150Mi"<br>}</pre> | no |
| <a name="input_efs_storage_class_enabled"></a> [efs\_storage\_class\_enabled](#input\_efs\_storage\_class\_enabled) | Enable or disable the Amazon Elastic File System (EFS) add-on for EKS cluster. | `bool` | `false` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Fetch Cluster ID of the cluster | `string` | `""` | no |
| <a name="input_enable_aws_load_balancer_controller"></a> [enable\_aws\_load\_balancer\_controller](#input\_enable\_aws\_load\_balancer\_controller) | Enable or disable AWS Load Balancer Controller add-on for managing and controlling load balancers in Kubernetes. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier for the Amazon Elastic Kubernetes Service (EKS) cluster. | `string` | `""` | no |
| <a name="input_external_secrets_enabled"></a> [external\_secrets\_enabled](#input\_external\_secrets\_enabled) | Enable or disable External Secrets operator add-on for managing external secrets. | `bool` | `false` | no |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Enable or disable Nginx Ingress Controller add-on for routing external traffic to Kubernetes services. | `bool` | `false` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | Specify the version of the NGINX Ingress Controller | `string` | `"4.7.0"` | no |
| <a name="input_internal_ingress_nginx_enabled"></a> [internal\_ingress\_nginx\_enabled](#input\_internal\_ingress\_nginx\_enabled) | Enable or disable the deployment of an internal ingress controller for Kubernetes. | `bool` | `false` | no |
| <a name="input_ipv6_enabled"></a> [ipv6\_enabled](#input\_ipv6\_enabled) | whether IPv6 enabled or not | `bool` | `false` | no |
| <a name="input_istio_config"></a> [istio\_config](#input\_istio\_config) | Configuration to provide settings for Istio | `any` | <pre>{<br>  "cert_manager_cluster_issuer_enabled": false,<br>  "egress_gateway_enabled": false,<br>  "egress_gateway_namespace": "istio-egressgateway",<br>  "envoy_access_logs_enabled": false,<br>  "ingress_gateway_enabled": true,<br>  "ingress_gateway_namespace": "istio-ingressgateway",<br>  "observability_enabled": true,<br>  "prometheus_monitoring_enabled": false<br>}</pre> | no |
| <a name="input_istio_enabled"></a> [istio\_enabled](#input\_istio\_enabled) | Enable istio for service mesh. | `bool` | `false` | no |
| <a name="input_karpenter_enabled"></a> [karpenter\_enabled](#input\_karpenter\_enabled) | Enable or disable Karpenter, a Kubernetes-native, multi-tenant, and auto-scaling solution for containerized workloads on Kubernetes. | `bool` | `false` | no |
| <a name="input_karpenter_provisioner_config"></a> [karpenter\_provisioner\_config](#input\_karpenter\_provisioner\_config) | Configuration to provide settings for Karpenter, including which private subnet to use, instance capacity types, and excluded instance types. | `any` | <pre>{<br>  "excluded_instance_type": [<br>    "nano",<br>    "micro",<br>    "small"<br>  ],<br>  "instance_capacity_type": [<br>    "spot"<br>  ],<br>  "instance_hypervisor": [<br>    "nitro"<br>  ],<br>  "private_subnet_name": ""<br>}</pre> | no |
| <a name="input_karpenter_provisioner_enabled"></a> [karpenter\_provisioner\_enabled](#input\_karpenter\_provisioner\_enabled) | Enable or disable the installation of Karpenter, which is a Kubernetes cluster autoscaler. | `bool` | `false` | no |
| <a name="input_keda_enabled"></a> [keda\_enabled](#input\_keda\_enabled) | Enable or disable Kubernetes Event-driven Autoscaling (KEDA) add-on for autoscaling workloads. | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the KMS key used to encrypt AWS resources in the EKS cluster. | `string` | `""` | no |
| <a name="input_kms_policy_arn"></a> [kms\_policy\_arn](#input\_kms\_policy\_arn) | Specify the ARN of KMS policy, for service accounts. | `string` | `""` | no |
| <a name="input_kubeclarity_enabled"></a> [kubeclarity\_enabled](#input\_kubeclarity\_enabled) | Enable or disable the deployment of an kubeclarity for Kubernetes. | `bool` | `false` | no |
| <a name="input_kubeclarity_hostname"></a> [kubeclarity\_hostname](#input\_kubeclarity\_hostname) | Specify the hostname for the Kubeclarity. | `string` | `""` | no |
| <a name="input_kubeclarity_namespace"></a> [kubeclarity\_namespace](#input\_kubeclarity\_namespace) | Name of the Kubernetes namespace where the kubeclarity deployment will be deployed. | `string` | `"kubeclarity"` | no |
| <a name="input_kubecost_enabled"></a> [kubecost\_enabled](#input\_kubecost\_enabled) | Enable or disable the deployment of an Kubecost for Kubernetes. | `bool` | `false` | no |
| <a name="input_kubecost_hostname"></a> [kubecost\_hostname](#input\_kubecost\_hostname) | Specify the hostname for the kubecsot. | `string` | `""` | no |
| <a name="input_metrics_server_enabled"></a> [metrics\_server\_enabled](#input\_metrics\_server\_enabled) | Enable or disable the metrics server add-on for EKS cluster. | `bool` | `false` | no |
| <a name="input_metrics_server_helm_version"></a> [metrics\_server\_helm\_version](#input\_metrics\_server\_helm\_version) | Version of the metrics server helm chart | `string` | `"3.8.2"` | no |
| <a name="input_metrics_server_vpa_config"></a> [metrics\_server\_vpa\_config](#input\_metrics\_server\_vpa\_config) | Configuration to provide settings of vpa over metrics server | `any` | <pre>{<br>  "maxCPU": "100m",<br>  "maxMemory": "500Mi",<br>  "metricsServerDeploymentName": "metrics-server",<br>  "minCPU": "25m",<br>  "minMemory": "150Mi"<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name prefix of the EKS cluster resources. | `string` | `""` | no |
| <a name="input_node_termination_handler_version"></a> [node\_termination\_handler\_version](#input\_node\_termination\_handler\_version) | Specify the version of node termination handler | `string` | `"0.21.0"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnets of the VPC which can be used by EFS | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_reloader_enabled"></a> [reloader\_enabled](#input\_reloader\_enabled) | Enable or disable Reloader, a Kubernetes controller to watch changes in ConfigMap and Secret objects and trigger an application reload on their changes. | `bool` | `false` | no |
| <a name="input_service_monitor_crd_enabled"></a> [service\_monitor\_crd\_enabled](#input\_service\_monitor\_crd\_enabled) | Enable or disable the installation of Custom Resource Definitions (CRDs) for Prometheus Service Monitor. | `bool` | `false` | no |
| <a name="input_single_az_ebs_gp3_storage_class_enabled"></a> [single\_az\_ebs\_gp3\_storage\_class\_enabled](#input\_single\_az\_ebs\_gp3\_storage\_class\_enabled) | Whether to enable the Single AZ storage class or not. | `bool` | `false` | no |
| <a name="input_single_az_sc_config"></a> [single\_az\_sc\_config](#input\_single\_az\_sc\_config) | Name and regions for storage class in Key-Value pair. | `list(any)` | `[]` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Configuration to provide settings for Velero, including which namespaces to backup, retention period, backup schedule, and backup bucket name. | `any` | <pre>{<br>  "backup_bucket_name": "",<br>  "namespaces": "",<br>  "retention_period_in_days": 45,<br>  "schedule_backup_cron_time": "",<br>  "slack_notification_channel_name": "",<br>  "slack_notification_token": "",<br>  "velero_backup_name": ""<br>}</pre> | no |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Enable or disable the installation of Velero, which is a backup and restore solution for Kubernetes clusters. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster and its nodes will be provisioned | `string` | `""` | no |
| <a name="input_worker_iam_role_arn"></a> [worker\_iam\_role\_arn](#input\_worker\_iam\_role\_arn) | Specify the IAM role Arn for the nodes | `string` | `""` | no |
| <a name="input_worker_iam_role_name"></a> [worker\_iam\_role\_name](#input\_worker\_iam\_role\_name) | Specify the IAM role for the nodes that will be provisioned through karpenter | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ebs_encryption_enable"></a> [ebs\_encryption\_enable](#output\_ebs\_encryption\_enable) | Whether Amazon Elastic Block Store (EBS) encryption is enabled or not. |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | ID of the Amazon Elastic File System (EFS) that has been created for the EKS cluster. |
| <a name="output_environment"></a> [environment](#output\_environment) | Environment Name for the EKS cluster |
| <a name="output_internal_nginx_ingress_controller_dns_hostname"></a> [internal\_nginx\_ingress\_controller\_dns\_hostname](#output\_internal\_nginx\_ingress\_controller\_dns\_hostname) | DNS hostname of the NGINX Ingress Controller that can be used to access it from within the cluster. |
| <a name="output_istio_ingressgateway_dns_hostname"></a> [istio\_ingressgateway\_dns\_hostname](#output\_istio\_ingressgateway\_dns\_hostname) | DNS hostname of the Istio Ingress Gateway. |
| <a name="output_kubeclarity"></a> [kubeclarity](#output\_kubeclarity) | Kubeclarity\_Info |
| <a name="output_kubecost"></a> [kubecost](#output\_kubecost) | Kubecost\_Info |
| <a name="output_nginx_ingress_controller_dns_hostname"></a> [nginx\_ingress\_controller\_dns\_hostname](#output\_nginx\_ingress\_controller\_dns\_hostname) | DNS hostname of the NGINX Ingress Controller. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contribution & Issue Reporting

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/squareops/terraform-aws-eks-bootstrap/issues) on GitHub
  2. Search to see if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Be sure to provide enough context and details so others can understand your problem.
  4. Contributing to the project can be a great way to get involved and get help. The maintainers and other contributors may be more likely to help you if you're already making contributions to the project.


## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/).

## Support Us

To support a GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/squareops/terraform-aws-eks-bootstrap).

  2. Click the "Star" button On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Starring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 5 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

You can find more information about our company on this [squareops.com](https://squareops.com/), follow us on [Linkedin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).

<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->
