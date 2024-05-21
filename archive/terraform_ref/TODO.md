# TODO

<!--
- output admin token in terraform
- allow to choose if public\private dns records are created for nodes
- null resource node destroy depends on pe primary being online
- use subdomains for projects instead of names?
- change json to tfvars to allow comments
- allow passing ami_id OR ami filters
- add eyaml instructions
- move to pe ports to an internal variable and do a count in alb resources
- manually delete old pzlive stuff created in aws from old problem terraform
- output ami description?
- make hostname the fqdn in bootstraps and everywhere
- manage creating extension_requests via tags
- private key file save location as variable
- optional private zone usage
- define variables properly, work out the nodes data type and set defaults
- pass puppet primary server same way nodes are as hash
- generate token for different user than admin
- set hostname in puppet?
- set timezone in puppet?
- configure better (not *) autosigning in puppet?
- healthcheck on alb
- update readme aws prereqs to include certificate, public zone, private zone
- move tokens etc. to s3 and move back to userdata
- remove lifetime tag
- remove lifecycle termination_data from aws_instance resources
-->
