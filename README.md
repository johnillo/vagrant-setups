# Vagrant Development Environment

A personal collection of local development environments using [Vagrant (VirtualBox)](https://www.vagrantup.com/intro/index.html). Update Vagrantfile and provisioning scripts depending on your project requirements as these contain generic configurations.

## Prerequisites

Have the following installed on your development machine.

* [Vagrant](https://vagrantup.com)
* [VirtualBox](https://virtualbox.org)

## Available Runtimes

### PHP

- Ubuntu Xenial x64
- PHP 7.2 with XDebug
- Apache
- Node.js 8.x
- MySQL
- Composer

## Notes

- You can commit `Vagrantfile` and provisioning scripts to your source control (excluding `.vagrant` and log files generated).
- Synced Folders affects performance especially for applications/frameworks that frequently write data to paths synced to the Host. One solution is to use NFS. Read more about this issue [here](https://www.vagrantup.com/docs/synced-folders/nfs.html).
- Virtual Machines use significant storage space. Have an extra storage ready or remove unused Vagrant environments by running `vagrant destroy`.
- Don't forget to stop your environment using `vagrant halt` before shutting down your computer to prevent possible data corruption.
- A fast and stable internet connection is needed when provisioning environments. Also, ensure that you're not in a metered connection.
