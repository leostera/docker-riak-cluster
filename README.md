Dockerized Riak Cluster
--------------------

Hi! Glad to see you're interested in a dockerized riak cluster as well.
This repository includes 3 Dockerfiles, one of them is the base Riak image
that installs all the required software artifacts for it to run appropriately.

The other 2 dockerfiles (`Node.dockerfile`, and `Master.dockerfile`) use
that base image (which FYI you don't have to build, it's already published
in our internal docker hub :D) and extend it with the appropriate entrypoint
scripts so they act accordingly. Node for just a joining node. Master for
a node that acts as ring owner, and installs IDM extensions and whatnot.

This could be mighty useful if you're trying to replicate some production-like
state where a node goes down, is unavailable, or any other type of SNAFU situations.

Just bear in mind that your docker-machine will likely need to be quite big
in terms of RAM at least.

# Cluster Usage

## Cluster up, Scotty!
To start up a cluster with 1 master and 3 nodes, the defaults, just run

```bash
make cluster
```

If you're interested, this just calls `docker-compose scale` and then `docker-compose logs`. 
Nothing too fancy.

Other nice things you can do are listed below.

## Container Stats

Wouldn't it be great to stat all your containers with a single command? Think `docker stats -a`.
Unfortunately, `docker stats` doesn't include an `-a` flag, so I've included this little hacky
target that does something similar. Make sure you use `watch` with it!

```bash
watch make stats
```

And voila! You'll get the stats for all your running containers. We might as well just filter
the ones that are riak related here...feel free to submit a PR :)

## Bash me up, Scotty!

Check out the `master-shell` and `node-shell` targets to quickly go into the running master
node or into the first node (I know, it should take a param to get into any node, but hey it's a WIP!
go complain elsewhere or submit a PR).

# About the Riak Node Image 

We include two handy targets for this, `build` and `publish`, that take care of building the `current
tag` and the tag `latest` and also publishing. Be extra wary of publishing breaking changes to latest!
There might be people relying on that image.
