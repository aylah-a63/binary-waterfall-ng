# Binary Waterfall NG
A port of Ella Jameson's Binary Waterfall, with the issues and PRs the original never got to. Point it at any file and see and hear the raw bytes as video and audio.

Supports Windows, now Linux and macOS.

## Install

Linux and macOS:
```bash
curl -fsSL https://raw.githubusercontent.com/aylah-a63/binary-waterfall-ng/main/install.sh | bash
```

Windows:
```bash
curl.exe -fsSL https://raw.githubusercontent.com/aylah-a63/binary-waterfall-ng/main/install.bat -o install.bat; .\install.bat
```
***Follow good security practices when pasting commands into a terminal.*** Please read either [install.sh](install.sh) or [install.bat](install.bat) before running the command.

Needs `git` and `python` (`python3` on Linux/macOS). The script builds from source, so the first run takes a few minutes.

It installs to:
- **Linux:** `~/.local/bin/binary-waterfall`, plus a desktop entry and icon in `~/.local/share`. Make sure `~/.local/bin` is on your `PATH`.
- **macOS:** `/Applications/binary-waterfall.app`
- **Windows:** `%LOCALAPPDATA%\Programs\binary-waterfall\binary-waterfall.exe`, plus a Start Menu shortcut

### Linux audio
Playback uses the system GStreamer, so its plugins have to be installed. On Debian/Ubuntu that is `gstreamer1.0-plugins-base`, `gstreamer1.0-plugins-good` and `libpulse-mainloop-glib0`; most desktop installs already have them.

## Building it yourself
```bash
git clone https://github.com/aylah-a63/binary-waterfall-ng.git
cd binary-waterfall-ng
./build.sh
```
The first build creates a `.venv` and downloads the dependencies. The result is `binary-waterfall` on Linux, `binary-waterfall.app` on macOS, and `binary-waterfall.exe` on Windows (run `build.bat` instead of `build.sh`).

## Uninstall
Delete `/Applications/binary-waterfall.app`, or on Linux:
```bash
rm ~/.local/bin/binary-waterfall \
   ~/.local/share/applications/binary-waterfall.desktop \
   ~/.local/share/icons/binary-waterfall.png
```

On Windows, delete `%LOCALAPPDATA%\Programs\binary-waterfall` and the "Binary Waterfall" shortcut from your Start Menu.

## Anything different?
Yes. There have been issues and PRs open since 2023; this repo fixes the issues. 

## Credits
Thank you so much to Ella Jameson for developing the original software. Please make sure to check out her work here: https://github.com/nimaid/binary-waterfall

Licensed under the GPL, same as the original.
