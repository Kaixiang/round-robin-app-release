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

For AWS:

1. make your own stub file base on the example:
```
cp templates/stub-example.yml templates/my-stub.yml
```
serveral things need to be changed for my-stub.yml to fit into your VPC enviroment.

* Change the proxy_floating_ip to a elastic ip you already have
* change the director uuid
* change the netwoks subnets for both round_robin_app1 and floating so it fits into your VPC enviroment.
* Change the security_group and subnet_id settings.

1. Generate deployment manifest from the stub file

```
templates/make_manifest templates/my-stub.yml
```

1. Deploy

```
bosh deploy
```
