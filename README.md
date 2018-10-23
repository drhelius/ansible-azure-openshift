ansible-azure-openshift
=========================

[OpenShift Reference Architecture](https://blog.openshift.com/openshift-container-platform-reference-architecture-implementation-guides/) implementation on Azure using Ansible.

Follow me on Twitter for updates: http://twitter.com/drhelius

![OpenShift Azure](https://blog.openshift.com/wp-content/uploads/refarch-ocp-on-azure-v6.png)

Bootstraping
------------
### Setup
...

### Bootstrap

Simply run:
```
./bootstrap.sh
```

When finished, you will get the public IPs for the Bastion host and for both the External Load Balancer and the Router Load Balancer.

In order to SSH into the Bastion host use the key in the ```certs``` folder:
```
ssh -i certs/bastion.key cloud-user@BASTION_IP
```

The ```oc``` command is configured to be used in the Bastion host.

If something failed during the installation you can run ```bootstrap.sh``` again.

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
