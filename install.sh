#!/bin/bash

# 镜像请加上冒号
BINARY_IMAGE="hank997/kubernetes-deploy:"

CODE_DIR="/etc/ansible/hank-kubernetes"

install_docker(){
    wget -O /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

    # 查看docker-ce版本
    yum --showduplicates list docker-ce

    # 安装docker-ce
    yum -y install docker-ce
    # 启动服务
    systemctl enable docker
    systemctl start docker

    # 参考文档 http://mirrors.ustc.edu.cn/help/dockerhub.html
    mkdir -p /etc/docker
    echo '{"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"]}' >> /etc/docker/daemon.json 
    systemctl restart docker
}

download_binary(){
    mkdir -p $CODE_DIR && \
    docker pull $BINARY_IMAGE$1 && \
    docker run -itd --name k8s_binary_image $BINARY_IMAGE$1 sh && \
    docker cp k8s_binary_image:/hank-kubernetes/bin/ $CODE_DIR && \
    docker rm -f k8s_binary_image || \
    exit 1
}

install_ansible_git(){
    yum install epel-release -y
    # 安装ansible
    yum install ansible git -y
    cd /etc/ansible/
    git clone https://github.com/AgoCan/ansible-kubernetes.git
    #cp /etc/ansible/ansible-kubernetes/kubernetes-hosts /etc/ansible/hosts
}

main(){
    if [[ `systemctl status docker| grep running | wc -l` != "1" ]]
    then
        install_docker
    fi
    while [[ ${version} != q ]]
    do
    clear
    echo "################################"
    echo "选择安装版本"
    echo "1. kubernetes 17.4"
    echo "2. kubernetes 18.12"
    echo "2. kubernetes 19.4"
    echo "任意键退出"
    echo "################################"
    
    read -p "请选择: " version
    if [ -z ${version} ];then
        version=null
    elif [ ${version} = 1 ];then
        download_binary 17.4
    elif [ ${version} = 2 ];then
        download_binary 18.12
    elif [ ${version} = 3 ];then
        download_binary 19.4
    else
        echo 退出吧...
        version=q
    fi
    done
    install_ansible_git
}
main
