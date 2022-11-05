# Features

This project **Features** is a set of reusable 'features'. Quickly add a tool/cli to a development container.

*Features* are self-contained units of installation code and development container configuration. Features are designed to install atop a wide-range of base container images (this repo focuses on **debian based images**).

> This repo follows the [**proposed**  dev container feature distribution specification](https://containers.dev/implementors/features-distribution/).

**List of features:**

* [fish](deprecated/fish/README.md): Install the shell fish (deprecated in favor of `ghcr.io/meaningful-ooo/devcontainer-features/fish`)
* [vim](src/vim/README.md): Install vim editor
* [golangci-lint](src/golangci-lint/README.md): Install a fast Go linters
* [gotestsum](src/gotestsum/README.md): Install a pretty test runner
* [gorealeaser](src/goreleaser/README.md): Release Go projects as fast and easily as possible!
* [pact-go](src/pact-go/README.md): Checks versions of required Pact CLI tools for used by the library

## Usage

To reference a feature from this repository, add the desired features to a devcontainer.json. Each feature has a README.md that shows how to reference the feature and which options are available for that feature.

The example below installs the *vim* declared in the `./src` directory of this repository.

See the relevant feature's README for supported options.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/guiyomh/features/vim": {}
    }
}
```
