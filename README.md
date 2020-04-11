# 前提

1. 做好ssh的免密登陆

```bash
# 创建ssh密钥对
# 更安全 Ed25519 算法
ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
# 或者传统 RSA 算法
ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/id_rsa

# 分发密钥
for i in ${node01ip} ${node02ip} ${node03ip}
do
  ssh-copy-id -o stricthostkeychecking=no $i
done
```

2. 安装python和ansible

```bash
# 文档中脚本默认均以root用户执行
#yum update
yum install epel-release -y
# 安装ansible
yum install ansible-2.9.6-1.el7 git -y
```

3. 配置ansible的配置文件

```bash
cp kubernetes-hosts /etc/ansible/hosts
```

分离配置

首先所有节点都需要加载到all节点下面，主要是方便连不是k8s集群一起做初始化

master和node节点， master不安装kubelet和proxy，方便master和node进行切分

高可用方案
- 如果需要高可用方案，请在 配置文件配置好vip
- 暂时使用了keepalived对apiserver的高可用，也就是master节点1可能产生大量访问，而节点2却在空闲中， 后续补充上负载均衡功能

etcd节点使用单独安装，一般和master配置一样即可