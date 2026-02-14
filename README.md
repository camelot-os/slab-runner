# slab-runner image

This repository hold a Dockerfile that permits to generate a pre-built slab-cortex-m emulator that allows booting firmwares to analyze their behavior in term of MMIO.

## building the image

```
docker build -t slab-runner:latest .
```

## Image content

The docker image is an ubuntu-based image that hold the following:

   * /opt/slab-rehosting/build/qemu-system-arm : slab-backed qemu that allows python-based hardware devices stubbing
   * /opt/slab-rehosting/slab/python : required python-packages for device stubbing
   * /opt/slab-rehosting/boards : boards YAML configurations used to specify board level devices that can be stubbed
   * /opt/slab-rehosting/examples : slab-rehosting upstream examples that can be used to check various devices

## Running hardware stubbing test on existing firmwares

In the docker image, running a slab-rehosting upstream test suite is as simple as:

```
python3 /opt/slab-rehosting/slab/examples/cortex-m/stm32/u5a5/demos/sentry-autotest/test_sentry_kernel.py
```

Based on existing upstream tests, you can add python end 2 end tests you wish using the installed slab-rehosting instance.

default CMD is overridable for automation purpose. You can run tests using:

```
docker run -it slab-runner  python3 /opt/slab-rehosting/slab/examples/cortex-m/stm32/u5a5/demos/sentry-autotest/test_sentry_kernel.py
```
