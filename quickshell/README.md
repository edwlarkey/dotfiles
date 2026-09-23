# Linux Platinum

A [Quickshell](https://quickshell.outfoxxed.me/) desktop shell themed after **Mac OS 9 Platinum**: bevels, Chicago, Charcoal, and a Control Strip along the bottom.

Built for Hyprland on Wayland. Version `0.1` — early, usable, and still growing.

## What you get

- **Menu bar** — Apple menu / app launcher, workspaces, tray, VPN, notifications, battery, clock, and the app switcher
- **Control Strip** — auto-hiding dock with launchers, volume, battery, session, clock, dashboard, Scrapbook, and settings
- **Notifications** — classic alert toasts plus a Notification Manager window
- **OSD** — volume, mic, and brightness HUDs (brightness no-ops cleanly on desktops with no backlight)
- **Dashboard** — now playing, weather, CPU / RAM / disk, Mullvad or WireGuard status
- **Scrapbook** — clipboard history via `cliphist` (text by default; check **Pictures** for image paths)
- **Session lock** — Platinum login dialog over PAM (`hyprlock` config)

## Requirements

| Need | Why |
| --- | --- |
| [Quickshell](https://quickshell.outfoxxed.me/) 0.3+ | the runtime |
| Hyprland | workspaces, focus grab, lock, app switcher |
| Pipewire | volume OSD |
| `cliphist`, `wl-copy`, `wl-paste` | Scrapbook |
| `brightnessctl` | brightness OSD on laptops (optional) |
| `mullvad` or `wg` | VPN widget (optional) |
| `curl` | weather in the dashboard |
| Icon theme **nineicons-redux-v0.6** | set in `shell.qml`; change the pragmas if you use another |

Fonts live in `fonts/`: ChicagoFLF, Charcoal, Monaco, and Material Symbols.

## Setup

Symlink this directory to the Quickshell config path:

```sh
ln -sfn /path/to/dotfiles/quickshell ~/.config/quickshell
```

Start it from Hyprland:

```
exec-once = qs
```

Clipboard history (for Scrapbook):

```
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
```

Reload after edits: Quickshell watches the config. Logs: `qs log`.

## Bindings

Call these from Hyprland (or anywhere):

```
qs ipc call appLauncher toggleAppLauncher
qs ipc call osd volumeUp
qs ipc call osd volumeDown
qs ipc call osd volumeMute
qs ipc call osd micMute
qs ipc call osd brightnessUp
qs ipc call osd brightnessDown
qs ipc call dashboard toggle
qs ipc call notifications toggle
qs ipc call scrapbook toggle
qs ipc call lock lock
```

## Configuration

Everything user-facing is in [`Config.qml`](Config.qml):

- **colors** — Platinum palette (`base`, `highlight`, `shadow`, `dark`, `outline`, …)
- **bar** — height, fonts, tray, Apple menu favorites
- **macDock** — Control Strip apps/folders, icon size, auto-hide
- **notifications**, **osd**, **dashboard**, **scrapbook** — sizes and timeouts

Dock entries look like:

```qml
{"name": "Terminal", "type": "app", "command": "ghostty", "iconName": "utilities-terminal"}
{"name": "Files", "type": "folder", "path": "/home/you", "iconName": "system-file-manager"}
```

## Layout

```
shell.qml                 entry point
Config.qml                colours, sizes, dock apps
taskbar/                  menu bar, workspaces, tray, clock
macdock/                  Control Strip
popups/                   Apple menu, app switcher, session
notifs/                   toasts + notification manager
osd/                      volume / mic / brightness HUD
dashboard/                dashboard window
scrapbook/                clipboard Scrapbook
lock/                     session lock
fonts/, assets/           Chicago, Charcoal, Apple mark
```

Singletons at the root (`Osd.qml`, `Dashboard.qml`, `Notifications.qml`, `Scrapbook.qml`, `Time.qml`) hold state; the folders hold windows and widgets.

## Notes

This is a personal shell, not a general-purpose distro theme. Expect sharp corners, hardcoded paths in `Config.qml`, and a settings window that is still a stub.

Ideas and leftovers: [`TODO.md`](TODO.md).
