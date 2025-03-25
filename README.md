# Contagious

```sh
Contagious is a command line tool that generates container images tags for Copacetic.

Usage:
  contagious [command]

Available Commands:
  help        Help about any command
  list
  version     Print the version number

Flags:
  -h, --help   help for contagious

Use "contagious [command] --help" for more information about a command.
```

```sh
Usage:
  contagious list [flags]

Flags:
  -h, --help            help for list
  -n, --next-tag        Include next patch tag information
  -o, --output string   Output file path
```

```sh
contagious list <registry>
contagious list <registry> -n -o matrix.json
```

[GH-Action](https://github.com/duffney/contagious-action)
