ansible-azure-openshift
=========================

[OpenShift Reference Architecture](https://blog.openshift.com/openshift-container-platform-reference-architecture-implementation-guides/) implementation on Azure using Ansible.

Follow me on Twitter for updates: http://twitter.com/drhelius

![OpenShift Azure](https://blog.openshift.com/wp-content/uploads/refarch-ocp-on-azure-v6.png)

Bootstraping
------------
### Setup

Tune all the variables in [configuration.yml](configuration.yml) to your liking, including the public domains where OCP will be accesible:

```
azure:
  location: "East US"
  resource_group: "openshift"
  image_publisher: "OpenLogic"
  image_offer: "CentOS"
  image_sku: "7.5"
  image_version: "latest"

openshift:
  master_nodes: [1,2,3]
  master_size: "Standard_B2s"
  infra_nodes: [1,2,3]
  infra_size: "Standard_B2ms"
  app_nodes: [1,2,3]
  app_size: "Standard_B2s"
  bastion_size: "Standard_B2ms"
  os_user: "openshift"
  admin_domain: "ocp-adm.mydomain.com"
  router_domain: "ocp.mydomain.com"
```

Customize OpenShift installation by tweaking the [OCP inventory template](roles/bastion/templates/openshift-inventory.j2).

Two [certificate pairs](certs/) are provided for both Bastion and OCP hosts. You can replace any of them with a new generated pair, keeping the same file names.

Don't forget to [set up Azure credentials](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#authenticating-with-azure), using a Service Principal is recommended.

### Bootstrap

To launch the automation simply run:
```
./bootstrap.sh
```

When finished, you will get public IPs for Bastion host and for both Master and Router load balancers.

Set up public DNS entries with these Load Balancers IPs for your previously defined domains. You may want to use a service like [Duck DNS](https://www.duckdns.org) for testing purposes.

SSH into Bastion host using the key in the ```certs``` folder:
```
ssh -i certs/bastion.key OS_USER@BASTION_IP
```

The ```oc``` command is installed and configured so you can use it directly within Bastion host.

If something fails during installation you can run ```bootstrap.sh``` again.

License
-------
MIT License

Copyright (c) 2017 Ignacio Sanchez Gines

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
