# ansible-nexus-jenkins
# INSTALLATION GUIDE WITH HTTPS CERTIFICATES ON CENTOS 8.X, RHEL 8.X, ORACLE 8.X.
Orden de ejecución de los playbooks 
1. instance-config.yaml
2. nexus-install.yaml
3. nexus-settings.yaml
4. jenkins-install.yaml
5. Ejecutar el archivo certificate-https.sh ubicado en la carpeta files
6. nexus-check-status.yaml

En caso que Nexus y Jenkis se ejecuten dentro de la misma máquina, se puede ejecutar el playbook complete-installation.yaml
