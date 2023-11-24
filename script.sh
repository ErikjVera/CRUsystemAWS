#!/bin/bash
# Función para esperar hasta que las instancias estén en estado "running"
wait_until_running() {
    local instance_ids=($@)
    aws ec2 wait instance-running --instance-ids ${instance_ids[@]}
    }

# Crear una VPC
vpcId=$(aws ec2 create-vpc --cidr-block 192.168.0.0/22 --query 'Vpc.VpcId' --output text)

# Crear subred para el Departamento de Ingeniería
subnetIdEng=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block 192.168.0.0/22 --availability-zone us-east-1a --query 'Subnet.SubnetId' --output text)
# Crear una instancia EC2 para el Departamento de Ingeniería
aws ec2 run-instances --image-id ami-xxxxxxxxxxxxxx --subnet-id $subnetIdEng --count 1 --instance-type t2.micro --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ec2-Ingenieria}]'
# Esperar hasta que la instancia esté en estado "running"
wait_until_running $(aws ec2 describe-instances --filters "Name=tag:Name,Values=ec2-Ingenieria" --query 'Reservations[*].Instances[*].InstanceId' --output text)

# Crear subred para el Departamento de Desarrollo
subnetIdDev=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block 192.168.1.0/22 --availability-zone us-east-1b --query 'Subnet.SubnetId' --output text)
# Crear una instancia EC2 para el Departamento de Desarrollo
aws ec2 run-instances --image-id ami-0230bd60aa48260c6 --subnet-id $subnetIdDev --count 1 --instance-type t2.micro --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ec2-Desarrollo}]'
# Esperar hasta que la instancia esté en estado "running"
wait_until_running $(aws ec2 describe-instances --filters "Name=tag:Name,Values=ec2-Desarrollo" --query 'Reservations[*].Instances[*].InstanceId' --output text)

# Crear subred para el Departamento de Mantenimiento
subnetIdMaint=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block 192.168.2.0/22 --availability-zone us-east-1c --query 'Subnet.SubnetId' --output text)
# Crear una instancia EC2 para el Departamento de Mantenimiento
aws ec2 run-instances --image-id ami-0230bd60aa48260c6 --subnet-id $subnetIdMaint --count 1 --instance-type t2.micro --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ec2-Mantenimiento}]'
# Esperar hasta que la instancia esté en estado "running"
wait_until_running $(aws ec2 describe-instances --filters "Name=tag:Name,Values=ec2-Mantenimiento" --query 'Reservations[*].Instances[*].InstanceId' --output text)

# Crear subred para el Departamento de Soporte
subnetIdSupp=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block 192.168.3.0/22 --availability-zone us-east-1d --query 'Subnet.SubnetId' --output text)
# Crear una instancia EC2 para el Departamento de Soporte
aws ec2 run-instances --image-id ami-0230bd60aa48260c6 --subnet-id $subnetIdSupp --count 1 --instance-type t2.micro --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ec2-Soporte}]'
# Esperar hasta que la instancia esté en estado "running"
wait_until_running $(aws ec2 describe-instances --filters "Name=tag:Name,Values=ec2-Soporte" --query 'Reservations[*].Instances[*].InstanceId' --output text)
