# create ASG for app servers
# create launch template for app servers

resource "aws_launch_template" "app_server_lt" {
  name_prefix   = "app-server-lt-"
  image_id      = "ami-068c0051b15cdb816" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_sg.id]
  }

user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail

# Amazon Linux 2: reliably install python3
amazon-linux-extras install -y python3.8 || yum install -y python3

cd /opt
nohup python3 -m http.server 8080 --bind 0.0.0.0 > /var/log/http.log 2>&1 &
EOF
)


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app-server-instance"
    }
  }
}

# Create Auto Scaling Group for app servers
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.private_app_subnet_1.id, aws_subnet.private_app_subnet_2.id]

  target_group_arns    = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_server_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "app-server-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}