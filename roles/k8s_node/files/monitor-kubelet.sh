systemctl status kubelet > /dev/null 2>&1
if [[ $? != 0 ]]
then
  systemctl start kubelet
fi