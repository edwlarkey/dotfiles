# Quickshell component TODO

Mac OS 9 / Platinum-styled additions inspired by Omarchy, Caelestia, and end-4.

## Highest fit for Mac OS 9

- [x] Notification toasts as classic alert boxes (title bar, icon, OK)
- [x] Notification center as a Platinum window (Notification Manager)
- [x] OSD for volume/brightness/mic as a small HUD (volume exists; brightness is the gap)
- [ ] Calendar popup on the clock (Date & Time control panel)
- [ ] Network panel (Chooser / Internet)
- [ ] Bluetooth panel
- [ ] Display/brightness panel (Monitors)
- [ ] Audio mixer with per-app sliders (Sound control panel)
- [x] Clipboard history as Scrapbook
- [ ] Color picker as the classic Mac wheel/crayons picker
- [ ] Screenshot overlay with marching-ants selection
- [ ] Screensaver (After Dark / Energy Saver)
- [ ] Idle inhibitor / stay-awake as an Energy Saver toggle
- [ ] Do not disturb / night light as Control Strip modules
- [ ] Keyboard layout indicator (International)
- [ ] Proper Appearance/Settings window (replace the settings stub)

## Common in modern shells, still Platinum-able

- [ ] MPRIS media player (QuickTime Player window + bar/dock module)
- [ ] Weather + forecast popup
- [ ] Microphone mute widget
- [ ] Mode indicators cluster (DND, night light, recording, stay awake)
- [x] Dashboard drawer (media, weather, CPU/RAM/disk)
- [ ] Overview with live window previews (Exposé-ish, more OS X than 9)
- [ ] Launcher extras: calculator, emoji, clipboard search, run-command
- [ ] Wallpaper picker
- [ ] Screen recording indicator + stop
- [ ] Reminders / countdown
- [ ] Power profiles in the battery popup
- [ ] On-screen keyboard (Key Caps)

## Fun / optional

- [ ] Desktop clock / desktop icons
- [ ] Stickies
- [ ] Audio visualizer on wallpaper
- [ ] QR/OCR capture
- [x] Mullvad / WireGuard VPN status
- [ ] Update badge

## Suggested first batch

These give the Omarchy "complete shell" feel without fighting the theme:

- [x] Notifications
- [x] Brightness OSD
- [ ] Calendar
- [ ] Network
- [ ] Bluetooth
- [ ] Media
- [x] Clipboard/Scrapbook

## Platinum pass

Measured from the Mac OS 8 HIG, as recorded in ZacOS 9 `docs/reference/`. Bar height stays 32. Apple mark stays, including the white logo swap on an open title.

### Colors

- [x] Retune `Config.colors` to 8-bit system grays: face `#dddddd`, frame `#cccccc`, shade `#999999`, dim `#888888`, stripe `#777777`, menu shadow `#222222`, inactive `#555555`. Keep black outline and white highlight. Add the default lavender accent ramp: top `#6666cc`, body `#333399`, bottom `#000088`.
- [x] Point `Bevel.qml` at shade `#999999` instead of `#404040`, so raised edges stop looking etched.
- [x] Menu bar: add the `#999999` shade row above the black bottom line.
- [x] Open menu titles use the accent ramp with white text, not a black invert. Keep the white Apple-logo swap.
- [x] Menus (Apple menu, app switcher, session, dock popups): separator is `#888888` over `#ffffff`; 1 px `#222222` drop shadow; disabled text `#888888`.
- [x] Title-bar stripes: `#ffffff` / `#777777`, gray row offset 1 px to the right.
- [x] Window titles in Charcoal. Chicago stays available, but not on title bars.

### Control Strip

- [ ] Drop the rounded pull tab (`radius: 5`). Closed state is a square angled grip, and the input mask follows that grip. Skipped for now.
- [x] Keep the current strip height.
- [x] Draw each module as its own cell with a 1 px black divider, not one continuous bevel slab.
- [x] An open module stays recessed for as long as its popup is open.
