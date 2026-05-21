# AWS Cloud

### CLI
```bash
docker pull gustavovinicius/ubuntu_awscli:v2

docker run -it -d --name aws gustavovinicius/ubuntu_awscli:v2
docker exec -it -u 0 aws bash

docker container rm aws

# OR
docker compose up -d --build aws

```

### Config keys
```bash
aws configure
region: us-east-2, us-west-2
output format: json
```

### Tofu
```bash
cd tofus
tofu init
tofu plan
tofu apply -auto-approve
tofu apply -auto-approve --target=aws_instance.web
tofu destroy -auto-approve --target=aws_instance.web

tofu state list
tofu state show aws_instance.web | grep region

ssh -i my-ec2-key.pem ubuntu@[public ip] -p 22
```
### Ansible
```bash
apt update
apt install software-properties-common -y
add-apt-repository --yes --update ppa:ansible/ansible
apt install ansible -y
reset
ansible --help

cd my-playbooks/local_server
# Run the playbook
ansible-playbook -i inventory.ini playbook.yml
# Verify services
ansible webservers -i inventory.ini -m shell -a "service nginx status"

ansible-playbook -i inventory.ini stop_services.yml
```