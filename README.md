# Ansi

A small utility to show the [ANSI](https://en.wikipedia.org/wiki/ANSI_escape_code) format escape codes

## Usage

`ansi` Shows a menu of ansi escape codes

## Dependencies

- [Zig](https://ziglang.org)

## Installation

### Manual

1. Install the dependencies
2. Install the program

```bash
git clone https://github.com/NewDawn0/ansi
cd ansi
zig build
sudo cp zig-out/bin/ansi /usr/local/bin
```

### Using Nix

1. Add it to your packagages

```nix
environment.systemPackages = [ pkgs.ansi ];
# Or
home.packages = [ pkgs.ansi ];
```
