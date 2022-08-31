# Features

This project **Features** is a set of reusable 'features'. Quickly add a tool/cli to a development container.

*Features* are self-contained units of installation code and development container configuration. Features are designed to install atop a wide-range of base container images (this repo focuses on **debian based images**).

> This repo follows the [**proposed**  dev container feature distribution specification](https://containers.dev/implementors/features-distribution/).

**List of features:**

* [fish](src/fish/README.md): Install the shell fish
* [vim](src/vim/README.md): Install vim editor
* [golangci-lint](src/golangci-lint/README.md): Install a fast Go linters
* [gotestsum](src/gotestsum/README.md): Install a pretty test runner
* [gorealeaser](src/goreleaser/README.md): Release Go projects as fast and easily as possible!
## Usage

To reference a feature from this repository, add the desired features to a devcontainer.json. Each feature has a README.md that shows how to reference the feature and which options are available for that feature.

The example below installs the *fish* and *vim* declared in the `./src` directory of this repository.

See the relevant feature's README for supported options.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/guiyomh/features/fish": {
            "pure": true
        },
        "ghcr.io/guiyomh/features/vim": {}
    }
}
```

## Repo and Feature Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder.  Each feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.

```text
├── src
│   ├── hello
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
│   ├── color
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
|   ├── ...
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
...
```

An [implementing tool](https://containers.dev/supporting#tools) will composite [the documented dev container properties](https://containers.dev/implementors/features/#devcontainer-feature-json-properties) from the feature's `devcontainer-feature.json` file, and execute in the `install.sh` entrypoint script in the container during build time.  Implementing tools are also free to process attributes under the `customizations` property as desired.
