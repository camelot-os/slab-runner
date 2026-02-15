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

## about CI usage

The Sentry kernel e2e pythoh test (`test_sentry_lernel.py`) supports the following argument:

   * `--firmware-path <firmware_bin>`

This argument can be added, in a CI job, in order to pass a previously built firmware to the e2e test. Note that only binary format firmware can be used (hex files not supported). This can be done, for example, using artifacts chaining between jobs or whatever input data passing.
