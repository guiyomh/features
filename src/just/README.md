
# just (just)

Installs just, just is a handy way to save and run project-specific commands on justfile.

## Example Usage

```json
"features": {
    "ghcr.io/guiyomh/features/just:0": {}
}
```

To install just LSP:

```json
"features": {
    "ghcr.io/guiyomh/features/just:0": {
        "lspVersion": "latest"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select version of just. | string | latest |
| lspVersion | Install just-lsp, a language server for just. Set to `false` to skip, `latest` for the newest release, or a specific version number. | string | false |

<!-- markdownlint-disable MD041 -->

## Supported platforms

`linux/amd64` and `linux/arm64` platforms `debian`, `ubuntu` and `alpine`.

## References

- just: <https://just.systems>
- just-lsp: <https://github.com/terror/just-lsp>


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/guiyomh/features/blob/main/src/just/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
