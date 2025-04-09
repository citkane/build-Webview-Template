# build-Webview-Template
This template provides for test building a [Webview](https://github.com/webview/webview) user application locally on each OS:<br>
Windows, Linux or MacOS.

It does not provide for cross-compilation usage.

It's primary purpose is to check Webview's behaviour across a gamit of compiling scenarios, primarily:
- Directly included and compiled from a user's C++ application
- Static link libs to a user's C++ application
- Shared link libs to a user's C++ application
- Target link (`webview::core`) to a user's C++ application
- Target link (`webview::core_static`) to a user's C application
- Target link (`webview::core_shared`) to a user's C application

**Build platforms used:**
- MSVC >= 2022 version 17.8 (Windows)
- MINGW [*POSIX*] (Windows)
- LLVM (Linux and MacOS)

**Threading Models:**
- POSIX (mostly)
- WIN (only for MSVC C)

**Usage:**
```bash
cd your/webview
```

```bash
git clone https://github.com/citkane/build-Webview-Template.git
cd build-Webview-Template

make
make run
```

The contained `main.cc` user app is focused on testing the [guarantee-thread-safety fork branch](https://github.com/citkane/webview/tree/guarantee-thread-safety) of Webview, so it will fail until that is merged.

Fork this repo and modify `main.cc` or edit the `makefile` user options to your own needs.

Depends on PR's:
- [#1293](https://github.com/webview/webview/pull/1293)
- [#1292](https://github.com/webview/webview/pull/1292)


