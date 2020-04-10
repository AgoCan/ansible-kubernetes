#!/bin/bash

# 镜像请加上冒号
BINARY_IMAGE="hank997/kubernetes-deploy:"

BIN_DIR="/etc/ansible/hank-kubernetes/bin"

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
    mkdir -p $BIN_DIR
    docker pull $BINARY_IMAGE$1
    docker run -itd --name binary_image $BINARY_IMAGE$1 sh
    docker cp binary_image:/hankbook-k8s-command $BIN_DIR
    docker rm -f binary_image
}

main(){
    install_docker
    while [ ${version} != q ]
    do
    clear
    echo "################################"
    echo "选择安装版本"
    echo "1. kubernetes 17.4"
    echo "################################"
    done
    read -p "请选择: " version
    if [ -z ${version} ];then
        version=null
    elif [ ${version} = 1 ];then
        download_binary 17.4
    else
        echo 退出吧...
        version=q
    fi
}