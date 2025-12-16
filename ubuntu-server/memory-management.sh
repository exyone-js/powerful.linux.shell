# 编辑sysctl配置
sudo tee -a /etc/sysctl.conf <<EOF
# 减少交换频率
vm.swappiness=10
vm.dirty_ratio=10
vm.dirty_background_ratio=5
vm.dirty_expire_centisecs=3000
vm.dirty_writeback_centisecs=500

# 增加内存分配过量比例
vm.overcommit_ratio=95

# 优化页面回收
vm.min_free_kbytes=65536

# 透明大页
# 对于数据库服务器建议关闭
# echo never > /sys/kernel/mm/transparent_hugepage/enabled
EOF

# 应用配置
sudo sysctl -p
