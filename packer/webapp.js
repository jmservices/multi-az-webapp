{
    "variables": {
        "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
        "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}",
        "region":         "eu-west-1",
        "ami_name":       "webapp"
    },
    "builders": [
        {
            "access_key": "{{user `aws_access_key`}}",
            "ami_name": "{{ user `ami_name`}}-{{timestamp}}",
            "instance_type": "t2.micro",
            "region": "{{user `region`}}",
            "secret_key": "{{user `aws_secret_key`}}",
            "source_ami_filter": {
              "filters": {
              "virtualization-type": "hvm",
              "name": "CentOS Linux 7 x86_64 HVM EBS*",
              "root-device-type": "ebs"
              },
              "owners": ["679593333241"],
              "most_recent": true
            },
            "ssh_username": "centos",
            "type": "amazon-ebs"
        }
    ],
    "provisioners": [
        {
            "type": "shell",
            "inline":[
                "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
                "sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
                "sudo yum install -y docker-ce",
                "sudo usermod -aG docker centos",
                "sudo systemctl enable docker.service",
                "sudo systemctl start docker.service",
                "sudo yum install -y epel-release",
                "sudo yum install -y python-pip",
                "sudo pip install docker-compose",
                "sudo yum upgrade -y python*",
                "sudo docker version >> /home/centos/docker-version.txt && sudo chown centos:centos /home/centos/docker-version.txt",
                "sudo docker-compose version >> /home/centos/docker-compose-version.txt && sudo chown centos:centos /home/centos/docker-compose-version.txt"
            ]
        },
        {
            "type": "file",
            "source": "./docker.zip",
            "destination": "/home/centos/"
        },
        {
            "type": "shell",
            "inline":[
                "sudo service docker start",
                "sudo yum install -y unzip",
                "unzip /home/centos/docker.zip",
                "rm -i /home/centos/docker.zip",
                "sudo docker-compose -f /home/centos/docker/docker-compose.yml up -d"
            ]
        }
    ]
}
