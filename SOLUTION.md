
# Solution

## Architecture Overview


## Networking (VPC)

VPC: Custom CIDR 10.0.0.0/16 with:
 - Private subnets (10.0.1.0/24) for all the resources

## Routing tables:
 - Private subnets route through a single NAT Gateway

## Security groups:
 - ECS: allows inbound HTTP (port 80)
 - RDS: allows inbound from ECS SG only

## Compute (ECS Fargate)
ECS Fargate cluster running a single HTTP service

Configured with:
 - CPU: 1024
 - Memory: 1024

## CloudWatch logging + container-level health checks
 - Uses IAM Execution Role for logging and ECS operations

## Storage

RDS (PostgreSQL):
 - Deployed in private subnets

20 GB storage

Used for structured data

DynamoDB:

 - PAY_PER_REQUEST mode

Used for fast session storage

## Messaging
 - SQS: For decoupled message queuing
 - SNS: Sends notifications via email


## Identity & Access Management (IAM)
 - ECS Execution Role with AWS-managed policy:
   - Allows ECS to pull images, write logs, etc.

Follows least privilege principle


## Trade-Offs

## ECS with Fargate:
### Pros:
- No Infrastructure to manage
- Autoscaling capabilities
### Cons:
- Slightly more expensive than EC2 for always-on workloads

## NAT Gateway: using only one shared Gateway
### Pros:
- Reduced cost vs. per-AZ deployment
### Cons:
- Single point of failure

## CloudWatch Logs
### Pros:
- Easy centralized logging and monitoring system
### Cons:
- Can be expensive at high volumes if logs are not pruned
## Security/Monitoring Notes

### ECS

With the use of private subnets, this setup is security-focused but can benefit from adding the following resources:

ALB to enable HTTPS traffic to the application, which enforces encryption of data for the http service. Minimizes attacks.

### RDS and DynamoDB

For further network security, I would create a separate subnet for the RDS and DynamoDB. This will enable better network management and enhanced security. It allows better control over traffic flow and isolates sensitive data 
### Monitoring

This setup would benefit a lot from a centralized monitoring system with aggregated logs/metrics such as ELK, Grafana, or OpenSearch

## Cost Strategies:

Making use of Compute Optimizer or CloudWatch metrics to better understand the application resource (Memory and CPU) needs under various conditions

Make use of Savings Plans - When you commit to usage. Compute saving plans allow one to commit to a certain level of usage over a period of time.

#### ECS - Cost Optimization

Right-sizing of tasks:
- Use monitoring metrics to gauge if the tasks are correctly spec'd. This will avoid over-provisioning by ensuring that resources are allocated accordingly to each task
- Use of scaling policies - Configuring autoscaling policies to adjust the number of tasks based on workloads. Oversized tasks can lead to higher costs
  
Utilizing Fargate Spot:
Pros:
 - Fargate Spot offers significant cost savings by making use of spare AWS capacity
 - This can be coupled with on-demand Fargate and only use Fargate Spot for upscaling when available
Cons:
 - Fargate Spot can be terminated at any given time, so it is not good to use for long-running tasks
