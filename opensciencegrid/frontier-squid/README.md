Frontier Squid Container Image [![Build Status](https://github.com/opensciencegrid/docker-frontier-squid/workflows/dispatched%20build-docker-image/badge.svg)](https://github.com/opensciencegrid/docker-frontier-squid/actions?query=workflow%3A%22dispatched+build-docker-image%22)
==============================

A [Docker](https://hub.docker.com/r/opensciencegrid/frontier-squid) container image for
[Squid proxy server](http://www.squid-cache.org/) as packaged by [OSG](https://www.opensciencegrid.org/).
The image is built according to the
[OSG installation instructions](http://opensciencegrid.org/docs/data/frontier-squid/).

Usage
-----

To run with the defaults on docker or podman:

```bash
docker run --rm --name frontier-squid \
  -p 3128:3128 opensciencegrid/frontier-squid:3.6-release
```

Running docker or podman with a `-u` option to start as a non-root user
is also supported.

To run with the default settings on apptainer:

```bash
apptainer run --writable-tmpfs \
  -B /scratch/squid/cache:/var/cache/squid \
  -B /scratch/squid/log:/var/log/squid \
  docker://opensciencegrid/frontier-squid:3.6-release
```

Replace `/scratch/squid` with a path to wherever you have a filesystem
large enough to hold the squid cache and logs.

See [our documentation](https://opensciencegrid.org/technology/policy/container-release/#tags) for details of our docker
image tags.

Configuring Squid
-----------------

The recommended way to configure the squid in the container is by means of environment variables.
Three such variables are supported:

Variable name       | Description                                                             | Defaults                                     |
---------------------|-------------------------------------------------------------------------|----------------------------------------------|
SQUID_IPRANGE       | Limits the incoming connections to the provided whitelist.     |By default only standard private network addresses are whitelisted. |
SQUID_CACHE_DISK    | Sets the cache_dir option which determines the disk size squid uses. Must be an integer value, and its unit is MBs. Note: The cache disk area is located at /var/cache/squid. | Defaults to 10000. |
SQUID_CACHE_MEM     | Sets the cache_mem option which regulates the size squid reserves for caching small objects in memory. Includes a space and unit, e.g. "MB". | Defaults to "128 MB". |

Additional configuration changes may be made by files in `/etc/squid/customize.d`.  See the documentation for that in [squid-customize.sh](squid-customize.sh).

Moreover, be aware that in order to preserve the cache between redeployments, you should map the following areas to persistent storage outside the container:

Mountpoint       | Description                                                          | Example docker mount               |
-----------------|----------------------------------------------------------------------|------------------------------------|
/var/cache/squid | This directory contains the cache for squid. See also SQUID_CACHE_DISK above. | -v /tmp/squid:/var/cache/squid |
/var/log/squid   | This directory contains the squid logs.                              | -v /tmp/log:/var/log/squid         |

For production deployments, OSG recommends allocating at least 50 to 100 GB (50000 to 100000 MB) to SQUID_CACHE_DISK.

For more details, see the [Frontier Squid documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Configuration).



Validate
--------

To validate your installation:

```bash
> export http_proxy=http://localhost:3128
> wget -qdO/dev/null http://frontier.cern.ch 2>&1 | grep X-Cache
X-Cache: MISS from 797a56e426cf
> wget -qdO/dev/null http://frontier.cern.ch 2>&1 | grep X-Cache
X-Cache: HIT from 797a56e426cf
```
