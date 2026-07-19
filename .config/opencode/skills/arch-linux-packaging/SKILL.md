---
name: arch-linux-packaging
description: Use when editing PKGBUILDs, or when building packages via makepkg. Covers CFLAGS/LDFLAGS/options conventions, env vars, debuggability checks, and the rebuild workflow. Triggers on PKGBUILD, makepkg, .makepkg.conf, ~/Packaging/, AUR, aurutils.
---

# Arch Linux Packaging

Building Arch Linux packages locally, either from AUR or custom/local only.

## Tree layout

- `~/Packaging/Build/mine/` — Our own PKGBUILDs (editable).
- `~/Packaging/Build/custom/` — AUR PKGBUILDs with local modifications (editable).
- `~/Packaging/Build/others/` — unmodified AUR PKGBUILDs (normally not intended to have local changes except for pkgver).
- `~/Packaging/Repository/` — built `.pkg.tar.zst` files (`PKGDEST`).
- `~/Packaging/Sources/` — downloaded sources cache (`SRCDEST`).
- `~/.makepkg.conf` — user makepkg config (authoritative for OPTIONS, env vars).
- `/etc/makepkg.conf` —  system makepkg config, should be unmodified (i.e., default from package)

## Notes about OPTIONS array in ~/.makepkg.conf

- `!strip` — keeps DWARF inline in the main binary (no split debug packages).
- `debug` — appends `DEBUG_CFLAGS="-g"` to CFLAGS/CXXFLAGS during build.
- `!libtool` — strips `.la` files (typical Arch hygiene).
- `staticlibs` — keeps `*.a` archives alongside `*.so`.
- `lto` — passes `-flto=auto`.
- `zipman`, `purge`, `emptydirs`, `docs`, `autodeps` — see `/etc/makepkg.conf` defaults.

Net behavior: built binaries embed full DWARF. No separate `*-debug` packages are produced (because `!strip` blocks `create_debug_package()` early at `/usr/bin/makepkg:756`).

## Note about other environment variables in ~/.makepkg.conf

Only some packages read them; setting them globally is intentional and harmless elsewhere.

- `_debug=y` — for `linux-tachyon` only. Enables `CONFIG_DEBUG_INFO` + `!strip` (overrides the `!debug` line in that PKGBUILD's options).
- `aur_llamacpp_build_universal=true` — for `mine/llama.cpp-cuda-git` and `mine/llama.cpp-vulkan-git`. Builds universal binaries (`GGML_NATIVE=OFF`, `GGML_CPU_ALL_VARIANTS=ON`, `CMAKE_CUDA_ARCHITECTURES=all-major`). Slower build, larger pkg, broader GPU architecture support.
- `_use_sodeps=true` — for `others/flycast-git` only. Uses shared system libs.
- `_autoupdate=false` — for `others/ryujinx-git` only. Currently a no-op in PKGBUILD, the check at line 105 is commented out.

## PKGBUILD conventions for mine/ and custom/

1. **`options=()` lines should be absent** from mine/ and custom/ — let the global `OPTIONS` apply. Only re-add if a package genuinely fails to build with defaults. (Notes on past removal reasoning live in git history.)

2. **CFLAGS/CXXFLAGS/LDFLAGS assignments should be additive or selectively remove a known-broken flag, never full replacements.**

   - Additive: `export CFLAGS="$CFLAGS -fno-char8_t"`
   - Selective removal: `export LDFLAGS="${LDFLAGS//-Wl,-z,pack-relative-relocs/}"` (e.g. `custom/expert-git:36`)
   - Forbidden: `unset CFLAGS CXXFLAGS`, `export CFLAGS="-march=... -O2 ..."` (discards makepkg's injected `-g`).

3. **Packages in others/ should not have local modifications**: `others/` PKGBUILDs are usually unmodified upstream. Any change except for `pkgver` due to `-git` packages modifying the package version, belongs in `custom/`.

## Rebuild workflow

1. Edit PKGBUILD in `mine/` or `custom/`.
2. Rebuild via `makepkg -s` (or aurutils equivalent).

## Debuggability verification

**On a built `.pkg.tar.zst`** (no install needed):

```bash
# List ELF files and check which have debug info
tmp=$(mktemp -d) && bsdtar -xf <pkg>.pkg.tar.zst -C "$tmp"
find "$tmp" -type f -exec sh -c 'file "$1" | grep -q ELF && { readelf -S "$1" 2>/dev/null | grep -q "\.debug_info" && echo "DEBUG: ${1#$tmp}" || echo "NODEBUG: ${1#$tmp}"; }' _ {} \; | sort
rm -rf "$tmp"
```

A binary with `.debug_info` + `.debug_line` + `.symtab` is gdb-friendly: function names, file:line, locals (where not optimized out).

**On an installed system**: `readelf -S /usr/bin/<pkg> | grep -E '\.debug_(info|line|str)'`.

## Known cross-toolchain caveats

- `others/qt5-webengine` — has `!debug` but mitigates internally via `CONFIG+='force_debug_info'` in qmake. Effectively debuggable despite the option.
- `others/linux-tachyon` — `!debug` in options is replaced by line 184 when `_debug=y`, so debug builds work.
- `others/aseprite` — hardcodes `_debug="true"` at line 83; that var is a patches toggle, not a debug-info toggle.

## Common makepkg internals

- `/etc/makepkg.conf:56-57` — `DEBUG_CFLAGS="-g"`, `DEBUG_CXXFLAGS="$DEBUG_CFLAGS"`, used when `debug` option is on.
- `/usr/bin/makepkg:756` — `create_debug_package()` early-returns when `!strip`, so `debug + !strip` produces inline DWARF only (no separate `-debug.pkg.tar.zst`).
- `/usr/share/makepkg/tidy/50-strip.sh:185` — `tidy_strip()` body is gated on `strip` being "y"; with `!strip`, the whole function is skipped.
- `/usr/share/makepkg/tidy/10-staticlibs.sh` — `!staticlibs` removes `*.a` only if matching `*.so` exists.
- `/usr/share/makepkg/tidy/10-libtool.sh` — `!libtool` removes `.la` archives.

