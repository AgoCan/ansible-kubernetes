FROM busybox
ENV K8S_VERSION=v1.18.12
ENV HELM_VERSION=v3.4.1
ENV BIN_DIR=/hank-kubernetes/bin/
WORKDIR /usr/local/src
RUN mkdir -p ${BIN_DIR} && \
    wget https://dl.k8s.io/${K8S_VERSION}/kubernetes-client-linux-amd64.tar.gz && \
    wget https://dl.k8s.io/${K8S_VERSION}/kubernetes-server-linux-amd64.tar.gz  && \
    wget https://dl.k8s.io/${K8S_VERSION}/kubernetes-node-linux-amd64.tar.gz   && \
    tar xf kubernetes-client-linux-amd64.tar.gz && \
    tar xf kubernetes-server-linux-amd64.tar.gz && \
    tar xf kubernetes-node-linux-amd64.tar.gz   && \
    mv kubernetes/client/bin/kubectl ${BIN_DIR} && \
    mv kubernetes/node/bin/kubelet kubernetes/node/bin/kube-proxy ${BIN_DIR} && \
    mv kubernetes/server/bin/kube-apiserver ${BIN_DIR} && \
    mv kubernetes/server/bin/kube-controller-manager ${BIN_DIR} && \
    mv kubernetes/server/bin/kube-scheduler ${BIN_DIR} && \
    wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm ${BIN_DIR} && \
    wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
    chmod +x cfssl_linux-amd64 && \
    mv cfssl_linux-amd64 ${BIN_DIR}/cfssl && \
    wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
    chmod +x cfssljson_linux-amd64 && \
    mv cfssljson_linux-amd64 ${BIN_DIR}/cfssljson && \
    wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 && \
    chmod +x cfssl-certinfo_linux-amd64 && \
    mv cfssl-certinfo_linux-amd64 ${BIN_DIR}/cfssl-certinfo && \
    rm -rf /usr/local/src/*