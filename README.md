# Scripts
 
## Installer scripts dans un projet 

```bash
git submodule add https://github.com/labs-web/scripts.git
```

## Updating and installing Git submodules 

### Submodules not yet initialized

If you're working with a freshly cloned project that contains submodules but they haven't been downloaded yet, use this command:

```bash
git submodule update --init
```


```bash
git submodule update --init --recursive
```

###  Submodules already initialized


```bash
git submodule update --remote
```