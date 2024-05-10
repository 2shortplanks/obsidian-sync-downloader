# Obsidian Sync Downloader

This is a single purpose Docker image that allows you to download the contents
of a vault stored in Obsidian Sync.

## Limitations

You'll (obviously) need a valid Obsidian Sync account in order to use this
software.  This is a paid service available from <https://obsidian.md/sync>.

Obsidian Sync is a black box process that only works with the Obsidian desktop
clients / mobile clients provided by Dynalist Inc.  There is no command line
version of the sync software.

This Docker image works by running the Obsidian Linux desktop client against
an Xserver running on a virtual frame buffer (i.e. a fake in-memory only
display) inside the docker container.  The desktop client is configured by a
combination of OCR to read the screen and scripting the keyboard input to use
the right on-screen controls.

A limitation is that it's not possible to directly specify the name of the
vault that we want to sync, but instead you can only specify the ordinal of the
vault you wish to sync (see the `OBSIDIAN_VAULT_ORDINAL` environment variable
described below for more info).

## Example Usage

An example which downloads the first obsidian sync vault in your account to
the "/tmp/results" folder on your computer

```
docker run -it \
    -e OBSIDIAN_SYNC_USERNAME=example@example.com \
    -e OBSIDIAN_SYNC_PASSWORD=opensaysme \
    -e OBSIDIAN_SYNC_PASSPHRASE=t00manys3rets \
    -e COPY_VAULT_TO=/output \
    -v /tmp/results:/output \
    2shortplanks/obsidian-sync-download
```

Note the use of `-v` to mount `/tmp/results` into the image so the downloaded
vault is available on the host computer after the run is complete.

## Environment Variables

The docker container is configured by passing environment variables to it

### ACCEPT_OBSIDIAN_TERMS_AND_CONDITIONS (optional)

Setting this to a true value automatically accepts the terms and conditions
without prompting you interactively.

### OBSIDIAN_SYNC_USERNAME (required)

The username of your Obsidian Sync account.

### OBSIDIAN_SYNC_PASSWORD (required)

The password of your Obsidian Sync account.

### OBSIDIAN_SYNC_PASSPHRASE (optional)

The passphrase that you have setup on your vault.

### OBSIDIAN_SYNC_EXCLUDE_FOLDERS (optional)

What folders to exclude from the sync.  A comma separated list.

### OBSIDIAN_VAULT_ORDINAL (optional)

What number vault you want to sync from your Obsidian Sync account.  Defaults to
1 (the first).  The ordered list of vaults can be found in Obsidian on your
computer by executing the "Open Another Vault" command, then clicking on "Setup"
in the "Open vault from Obsidian Sync" section.

### OBSIDIAN_SYNC_TIMEOUT (optional)

The maximum time, in seconds, that we will wait for the sync to complete after
the desktop client has been setup.  This defaults to 3600 (one hour).

### COPY_VAULT_TO (optional)

If set, copies the downloaded vault (using rsync, to preserve timestamps and
other details) to this path when it is fully downloaded. Useful for easily
getting the contents of the vault out of the container by copying the vault to
a directory you've mounted with docker's `-v` option.

### RUN_FOREVER (optional)

Setting this to a non-empty string means rather than exiting when the initial
sync is done, the downloader will keep running forever (and keep syncing
forever) until the container is manually stopped.

Please note that any destination specified with `COPY_VAULT_TO` will not update
once the initial sync has done.  You'll have to take extra steps to access the
updated synced files directly.

## Known Limitations

- You can't mount `/root/vault` directly with `-v`.  If you do that it'll
  confuse the Obsidian desktop client during setup, as it'll mistake the mounted
  `/root/vault` directory for an existing vault and refuse to sync.  Use the
  `COPY_VAULT_TO` option instead, or use `docker cp` / access the files
  directly on the host filesystem outside of docker.

## Debugging

If this sync doesn't work properly, there's several things you can do to debug
it and identify the problem (for example: your password is wrong, you forgot to
set a passphrase where one is needed, etc)

### Connect via VNC

There's a VNC server running on port 5900 of the container that'll allow you
to log in and manipulate the Obsidian desktop client directly.  There's no
password.

### Look at the screenshots and OCR capture

Inside the `/tmp/osd` directory there are various screenshots of the form
`/tmp/osd/screenshot-XXX.png` and corresponding text files of the form
`/tmp/osd/ocr-XXX.txt` containing the output of OCRing those screenshots.

### Look at the log

There's a log file in `/var/log/startup` that might have more info.

## Legal

### Obsidian Software

This docker image contains a copy of the Obsidian software by Dynalist Inc,
which is distributed as a convenience to the end user.  Obsidian is not free
software and using this docker image to sync with Obsidian Sync (or for any
other purpose) may, depending on your use, require a commercial license from
Dynalist Inc.

Use of the Obsidian software is subject to the terms and conditions as defined
at <https://obsidian.md/terms>.  Use of this docker image indicates you accept
those terms and conditions.

### Ubuntu Software

The operating system for this Docker image is open source software provided by
Ubuntu and the various licensing terms are included in the image.

### Additional Software

The Dockerfile and "setup" script (and all other files in the
<https://github.com/2shortplanks/obsidian-sync-downloader> repository) are
Copyright Mark Fowler 2024. <mark@twoshortplanks.com>.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the “Software”), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
