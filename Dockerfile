FROM archlinux:latest

MAINTAINER Pavol Risa "risapav at gmail"

#update OS
RUN pacman -Sy \
	&& yes | pacman -S openssh \
		sudo \
		mc 
#		openocd \
#	&& paccache --remove \
#    && rm -rf /tmp/* /var/tmp/*
	

RUN systemctl enable sshd
#RUN systemctl start sshd	

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile    

EXPOSE 22

CMD    [systemctl start sshd]
