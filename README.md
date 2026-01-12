# Spacelift (Ansible) 💖 Netbird

Puts [Netbird][] into [Spacelift][], for accessing things on the network from Ansible, etc easily.

[Netbird]: https://netbird.io/
[Spacelift]: https://spacelift.io/

The original commands defined in your Spacelift workflow are still invoked by Spacelift, we just wrap some setup/teardown around them for Netbird.

This is a port of [caius/spacelift-tailscale](https://github.com/caius/spacelift-tailscale) and [nathanwasson/spacelift-tailscale-ansible](https://github.com/nathanwasson/spacelift-tailscale-ansible) but adapted for Netbird.

## Usage

There is some up front configuration required, then it'll Just Work™ every time you trigger a run in Spacelift for that stack.

### Context for hooks & auth

You'll need to create a Spacelift Context in the UI and define the following hooks for the before phases (plan/perform/apply/destroy) (apply and destroy do not apply to Ansible):

- `spacebird up`
- `trap 'spacebird down' EXIT`
- `export HTTP_PROXY=socks5://localhost:1080 HTTPS_PROXY=socks5://localhost:1080`

And then in the after hooks for all the above phases, the following:

- `unset HTTP_PROXY HTTPS_PROXY`
- `sed -e '/HTTP_PROXY=/d' -e /HTTPS_PROXY/d -i /mnt/workspace/.env_hooks_after`

The authentication environment variables can be added to this context as well:

- `NB_SETUP_KEY` - Your Netbird Setup Key

### Ansible Configuration (SSH)

If you're using Ansible to connect over Netbird to a host via SSH, you'll need to set a ProxyCommand in your Ansible inventory file to use the SOCKS5 proxy which `spacebird` sets up on port 1080.

For example, in your inventory file you could set:

```yaml
my-netbird-stack:
  hosts:
    my-host: <netbird-ip-address>
  vars:
    ansible_connection: ssh
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o ProxyCommand="nc -X 5 -x localhost:1080 %h %p"'
```

### Runner Image

The `runner_image` needs configuring to point to the image built from this repository.

## Building from Source

### Prerequisites
- Docker
- Make (optional)

### Build Commands
```bash
# Build the image locally
make docker-build
```
