# trydiffoscope

- upsteam: https://salsa.debian.org/reproducible-builds/trydiffoscope
- ngi-nix: https://github.com/ngi-nix/ngi/issues/83

trydiffoscope is a client to an online service, which allows one to try [diffoscope](https://diffoscope.org/) without installing it.

## Using

In order to use this [flake](https://nixos.wiki/wiki/Flakes) you need to have the 
[Nix](https://nixos.org/) package manager installed on your system. Then you can simply run this 
with:

```
$ nix run github:ngi-nix/trydiffoscope
```

You can also enter a development shell with:

```
$ nix develop github:ngi-nix/trydiffoscope
```

For information on how to automate this process, please take a look at [direnv](https://direnv.net/).
