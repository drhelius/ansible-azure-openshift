#!/bin/bash
set -ue

echo "-----------------------------------------"
echo "Deploying infrastructure..."
echo "-----------------------------------------"

ansible-playbook -i ,localhost -e @configuration.yml openshift-infra.yml


echo "-----------------------------------------"
echo "Getting output variables..."
echo "-----------------------------------------"

BASTION_IP=$(cat openshift_bastion_ip.out)
ROUTER_IP=$(cat openshift_infra_ip.out)
MASTER_IP=$(cat openshift_master_ip.out)
MASTER_DOMAIN=$(cat openshift_admin_domain.out)
ADMIN_USER=$(cat openshift_os_user.out)

echo "Master Load Balancer: $MASTER_IP"
echo "Router Load Balancer: $ROUTER_IP"
echo "Bastion: $BASTION_IP"

echo "-----------------------------------------"
echo "Setting up bastion server..."
echo "-----------------------------------------"

ansible-playbook --private-key certs/bastion.key -u $ADMIN_USER -i azure_rm.py -e @configuration.yml bastion.yml

BASTION_SSH_COMMAND="ssh -q -t -o StrictHostKeychecking=no -i certs/bastion.key $ADMIN_USER@$BASTION_IP"

echo "-----------------------------------------"
echo "Praparing hosts for OpenShift installation..."
echo "-----------------------------------------"

$BASTION_SSH_COMMAND "cd openshift/host-preparation; ansible-playbook -i ../inventories/host-preparation -e @../configuration.yml host-preparation.yml"

echo "-----------------------------------------"
echo "Running OpenShift prerequisites..."
echo "-----------------------------------------"

$BASTION_SSH_COMMAND "cd openshift/openshift-ansible; ansible-playbook -i ../inventories/openshift playbooks/prerequisites.yml"

echo "-----------------------------------------"
echo "Running OpenShift installation..."
echo "-----------------------------------------"

set +e

$BASTION_SSH_COMMAND "cd openshift/openshift-ansible; ansible-playbook -i ../inventories/openshift playbooks/deploy_cluster.yml"

echo "-----------------------------------------"
echo "Setting up OpenShift CLI in bastion..."
echo "-----------------------------------------"

$BASTION_SSH_COMMAND "rm -rf .kube; scp -q -r master1.openshift.local:.kube .kube"

echo "-----------------------------------------"
echo "--------------- FINISHED! ---------------"
echo "-----------------------------------------"
echo "Master Load Balancer: $MASTER_IP"
echo "Router Load Balancer: $ROUTER_IP"
echo "Console: https://$MASTER_DOMAIN:8443"
echo "Bastion: ssh -i certs/bastion.key $ADMIN_USER@$BASTION_IP"
echo "-----------------------------------------"
echo "-----------------------------------------"
