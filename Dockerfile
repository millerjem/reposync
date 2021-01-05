FROM centos:7.0.1406

ARG REPOS="base extras updates konvoy-packages kubernetes libnvidia-container nvidia-container-runtime"
ARG SCRIPT="/sync-repos.sh"

RUN yum update -y nss curl libcurl
RUN yum install -y yum-utils createrepo
SHELL ["/bin/bash", "-c"]
ADD ./dkp.repo /etc/yum.repos.d/.
RUN curl -L -s https://nvidia.github.io/nvidia-container-runtime/centos7/nvidia-container-runtime.repo | sed 's/repo_gpgcheck=1/repo_gpgcheck=0/' | tee /etc/yum.repos.d/nvidia-container-runtime.repo
RUN curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | tee gpgkey-nvidia-container-runtime
RUN rpm --import gpgkey-nvidia-container-runtime
RUN yum clean all && \
    yum update yum
ADD .${SCRIPT} /.
RUN chmod +x ${SCRIPT}
RUN ${SCRIPT} ${REPOS}

FROM registry.redhat.io/ubi8/ubi
RUN yum install -y httpd perl && \
    yum clean all
ADD ./repo /var/www/cgi-bin/.
RUN chmod a+x /var/www/cgi-bin/repo
COPY --from=0 /repos /var/www/html/repos

EXPOSE 80
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
