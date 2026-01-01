Project: 3-tier-architecture

Step 1. Created s3 bucket for TF backend

Step 2. Networking
    - VPC
    - 2 Public subnets
    - 2 Private subnets for web server
    - 2 Private subnets for app server
    - 2 Private subnets for db server
    - Internet gateway
    - Public IP
    - Nat gateway
    - Public route table, route to IGW, public subnets association
    - Private route table, route to NGW, private subnets association

Step 3. Security Group
    - Sg for external alb all traffic on port 80 from internet
    - Sg for web server all traffic on port 80 from alb
    - Sg for internal alb all traffic on port 80 from wed server
    - Sg for app server all traffic on port 8080 from internal alb
    - Sg for db server all traffic on port 3306 from app server

Step 4. Autoscalling Group for web server
    - created launch template for web servers
    - Create Auto Scaling Group

Step 5. External Loadbalancer
    - create external load balancer
    - create target group for web servers
    - create listener for external alb

Step 6. Autoscalling Group for app server
    - create launch template for app servers
    - create auto scalling group

Step 7. Internal Loadbalancer
    - create internal load balancer
    - create target group for app servers
    - create listener for internal alb+

Check app server is working (inside EC2)
    - curl http://localhost:8080
    - Hello from Java HTTP Server on port 8080

Step 7. RDS
    - Create a random password for the database
    - Create Secrets Manager secret to store the database password
    - Create a secret version with the generated password
    - Create DB subnet group
    - Create RDS instance
    - Database deployed in Multi-AZ for failover
