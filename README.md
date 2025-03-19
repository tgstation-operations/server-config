# /tg/station Server Configs

This repository serves as a source of truth for the configuration used on the [/tg/station](https://github.com/tgstation/tgstation) game servers. Config for [TGMC](https://github.com/tgstation/TerraGov-Marine-Corps) can be found [here](https://github.com/tgstation-operations/server-config-tgmc).

## Directory Structure
Top level configs apply to all servers.

`config.txt` imports one of the following directories depending on the specific server it's running under:
```
manuel/
sybil/
terry/
```

This is specifically filtered by including each of these in the top level `config.txt`, and using the following invocation of [`git sparse-checkout`](https://git-scm.com/docs/git-sparse-checkout).

```bash
git sparse-checkout set $SERVER/
```

This is handled by a script hooked into [tgstation-server](https://github.com/tgstation/tgstation-server), which we use to run each game server.

### Excluded paths
We exclude a few paths for various reasons (primarily copyright). These are listed in the `.gitignore` with their reasoning.

## Contributing

This repository is primarily intended to be managed by /tg/station Head Administrators, but PRs may be made if desired. The /tg/station Operations team (including the Host) does not interfere in the configurations set in this repository, unless requested by a Head Administrator or required for infrastructure integrity.
