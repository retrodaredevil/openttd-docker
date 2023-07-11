# OpenTTD Server

[![](https://img.shields.io/badge/Docker%20Image-retrodaredevil/openttd)](https://github.com/retrodaredevil/openttd-docker/pkgs/container/openttd)
[![](https://img.shields.io/github/stars/retrodaredevil/openttd-docker.svg?style=social)](https://github.com/retrodaredevil/openttd-docker/stargazers)

This docker container contains the `openttd` binary and utilities to make running and loading save files easier.
This is designed to be used as a dedicated server for OpenTTD.

View the source code here: [retrodaredevil/openttd-docker](https://github.com/retrodaredevil/openttd-docker).

## Features
* Automatically load save from a file, directory, or directory (search recursively).
  * When searching in a directory, the file that was edited most recently is chosen
* Run as any user you want
* Paths used inside container are easy to understand (no usages of `/home/openttd`)
* Option to have complete control over the arguments passed to the `openttd` binary

## Configuration

This container can be configured using environment variables.

| Environment Variable | Meaning                                                                                         | Possible values                          | Default Value                     |
|----------------------|-------------------------------------------------------------------------------------------------|------------------------------------------|-----------------------------------|
| `LOAD_TYPE`          | Describes how the save file will be loaded                                                      | `none`, `file`, `directory`, `recursive` | `directory`                       |
| `LOAD_FROM`          | Used as an argument to `LOAD_TYPE`. Will determine where the save file to be loaded is located. | Any file path                            | `/app/data/openttd/save/autosave` |

| `LOAD_TYPE` value | Meaning                                                                                                                                                                             | How is `LOAD_FROM` Used?                             |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------|
| `none`            | No save file is loaded, so a new game is created. (No `-g` option is passed to `openttd` binary)                                                                                    | Unused. Has no effect.                               |
| `file`            | A save file is loaded.                                                                                                                                                              | Is the path to the save file                         |
| `directory`       | The most recent save file in a given directory is loaded.                                                                                                                           | Is the path to the directory containing save file(s) |
| `recursive`       | The most recent save file in a given directory and its sub-directories is loaded. Unlike `directory`, this will look in sub-directories and their subdirectories, etc, recursively. | Is the path to the directory containing save file(s) |

## `docker compose` examples

```yaml
version: "3.7"
services:
  openttd:
    image: ghcr.io/retrodaredevil/openttd:edge-13.3
    container_name: openttd
    restart: "no"
    user: 2000:2000
    ports:
      - "3979:3979/udp"
      - "3979:3979/tcp"
    environment:
      - "LOAD_TYPE=none"
      #- "LOAD_TYPE=directory"
      #- "LOAD_FROM=/app/data/openttd/save/autosave"
      #- "LOAD_TYPE=file"
      #- "LOAD_FROM=/app/data/openttd/save/main.sav"
    volumes:
      - ./data:/app/data/openttd
      - ./config:/app/config/openttd
    tty: true
    stdin_open: true
```
