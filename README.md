# Ape

Ape 🦧 is small command line tool to generate weekly repeating items from templates for [GrandTotal][1].

## Installation

You can install `ape` either with [Homebrew](https://brew.sh) or from source.

### Install with Homebrew

```shell-script
brew install qultist/formulae/ape
```

### Install from source

```shell-script
rake install
```

## Usage

Create a template. Templates are written in JSON.

```json
{
    "name": "template",
    "items": [
        {
            "name": "item",
            "weekdays": ["monday", "wednesday"],
            "quantity": 1,
            "wage": 1
        }
    ]
}
```

Generate items for the current month and year.

```shell-script
ape template.json
```

The month and year can be specified with the `-m` resp. `-y` options. Use `ape -help` for more information.


## License

Ape is released under the MIT license. See [LICENSE](./LICENSE) for details.

[1]: https://www.mediaatelier.com/GrandTotal7/
