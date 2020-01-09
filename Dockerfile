FROM archlinux:latest

MAINTAINER Pavol Risa "risapav at gmail"

#update OS
RUN pacman -Sy \
	&& yes | pacman -S \
		openssh \
		nano \
		ranger \
		minicom \
		mc \
		openocd \
    && rm -rf /tmp/* /var/tmp/*
	

# configure ssh
RUN sed -i \
        -e 's/^#*\(PermitRootLogin\) .*/\1 yes/' \
        -e 's/^#*\(PasswordAuthentication\) .*/\1 yes/' \
        -e 's/^#*\(PermitEmptyPasswords\) .*/\1 yes/' \
        -e 's/^#*\(UsePAM\) .*/\1 no/' \
        /etc/ssh/sshd_config

# Generate host keys
RUN /usr/bin/ssh-keygen -A

# Add password to root user
RUN	echo 'root:root' | chpasswd

RUN systemctl enable sshd

# Expose tcp port
EXPOSE	 22

# Run openssh daemon
CMD	["/usr/sbin/sshd", "-D"]
