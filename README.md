# Binary Waterfall NG
A port of Ella Jameson's Binary Waterfall for non-Windows platforms. Point it at any file and see and hear the raw bytes as video and audio.

Linux and macOS only (for now). On Windows, use [the original](https://github.com/nimaid/binary-waterfall).

## Install
```bash
curl -fsSL https://raw.githubusercontent.com/aylah-a63/binary-waterfall-ng/main/install.sh | bash
```
***Follow good practices when pasting commands.*** Please read [install.sh](install.sh) before running the command.

Needs `git` and `python3`. The script builds from source, so the first run takes a few minutes.

It installs to:
- **Linux:** `~/.local/bin/binary-waterfall`, plus a desktop entry and icon in `~/.local/share`. Make sure `~/.local/bin` is on your `PATH`.
- **macOS:** `/Applications/binary-waterfall.app`

### Linux audio
Playback uses the system GStreamer, so its plugins have to be installed. On Debian/Ubuntu that is `gstreamer1.0-plugins-base`, `gstreamer1.0-plugins-good` and `libpulse-mainloop-glib0`; most desktop installs already have them.

## Building it yourself
```bash
git clone https://github.com/aylah-a63/binary-waterfall-ng.git
cd binary-waterfall-ng
./build.sh
```
The first build creates a `.venv` and downloads the dependencies. The result is `binary-waterfall` on Linux and `binary-waterfall.app` on macOS.

## Uninstall
Delete `/Applications/binary-waterfall.app`, or on Linux:
```bash
rm ~/.local/bin/binary-waterfall \
   ~/.local/share/applications/binary-waterfall.desktop \
   ~/.local/share/icons/binary-waterfall.png
```

## Credits
Thank you so much to Ella Jameson for developing the original software. Please make sure to check out her work here: https://github.com/nimaid/binary-waterfall

Licensed under the GPL, same as the original.
