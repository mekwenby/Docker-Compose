# 使用官方的 Ubuntu 作为基础镜像
FROM ubuntu:22.04

# 替换软件源为 163 源
RUN sed -i 's@http://.*archive.ubuntu.com@http://mirrors.163.com@g' /etc/apt/sources.list
RUN sed -i 's@http://.*security.ubuntu.com@http://mirrors.163.com@g' /etc/apt/sources.list


# 更新软件包并安装 OpenSSH 服务器
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# 设置 root 用户密码为 passwd
RUN echo 'root:passwd' | chpasswd

# 允许 root 用户通过 SSH 登录
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 取消 pam_loginuid.so 的会话标记，避免容器内 SSH 登录失败
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# 暴露 SSH 端口
EXPOSE 22

# 启动 SSH 服务
CMD ["/usr/sbin/sshd", "-D"]
