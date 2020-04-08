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
yum update
# 安装python
yum install python -y
yum install git python-pip -y
pip install pip --upgrade -i https://mirrors.aliyun.com/pypi/simple/
pip install ansible==2.6.18 netaddr==0.7.19 -i https://mirrors.aliyun.com/pypi/simple/
```

3. 配置ansible的配置文件

