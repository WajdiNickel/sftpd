FROM registry.access.redhat.com/ubi8/ubi-minimal:8.9

LABEL maintainer="Enrique Garcia [ejurado@borak.es]"

# Unpriviledged SSH 
ENV SSH_PATH=/opt/ssh

# Labels consumed by OpenShift
LABEL io.k8s.description="A rootless SFTP server" \
      io.k8s.display-name="ADEL SFTP Server" \
      io.openshift.expose-services="30022:2022" \
      io.openshift.tags="adel, sftpd"

# Change the port to 2022
EXPOSE 2022 

RUN microdnf update -y && \
    microdnf install -y --nodocs openssh-server procps && \
    microdnf clean all && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p ${SSH_PATH} && \
    groupadd adel

# Permissions to allow container to run on OpenShift
#RUN chgrp -R 0 ${SSH_PATH} && \
#    chmod -R g=u ${SSH_PATH}

#USER 1001

WORKDIR ${SSH_PATH}

ENTRYPOINT ["/usr/sbin/sshd", "-D", "-e", "-f", "config/adel_sshd_config"]

