# BOSH Release for round-robin-app

Deploys a simple hello world application with a naive round-robin proxy in front.
If an app goes down, the proxy will continue to route to it so you can see when it is down and when it comes back.

```
curl <proxy_ip>:4567 # see response from one app
curl <proxy_ip>:4567 # see response from another app in round robin order
```

## Deployment

To use this bosh release, first upload it to your bosh:

```
bosh target BOSH_HOST
git clone https://github.com/cloudfoundry-community/round-robin-app-boshrelease.git
cd round-robin-app-boshrelease
bosh upload release releases/round-robin-app-1.yml
```

For [bosh-lite](https://github.com/cloudfoundry/bosh-lite), you can quickly create a deployment manifest & deploy a cluster:

```
templates/make_manifest warden
bosh -n deploy
```

For AWS EC2:

```
templates/make_manifest aws-ec2
bosh -n deploy
```

### Override security groups

For AWS & Openstack, the default deployment assumes there is a `default` security group.
If you wish to use a different security group(s) then you can pass in additional configuration when running `make_manifest` above.
Make sure your security group allows access on port 4567 from anywhere.

Create a file `my-networking.yml`:

``` yaml
---
networks:
- name: round-robin-app1
  type: dynamic
  cloud_properties:
    security_groups:
    - round-robin-app
```

Where `- round-robin-app` means you wish to use an existing security group called `round-robin-app`.

You now suffix this file path to the `make_manifest` command:

```
templates/make_manifest openstack-nova my-networking.yml
bosh -n deploy
```
