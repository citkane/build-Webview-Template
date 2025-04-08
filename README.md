# Weview-Build-Template
This template provides for test building a Webview user application locally on each OS:<br>
Windows, Linux or MacOS.

It does not provide for cross-compilation usage.

It's primary purpose is to check Webview's behaviour across a gamit of compiling scenarios, primarily:
- Directly included and compiled from a user's C++ application
- Static link libs to a user's C++ application
- Shared link libs to a user's C++ application
- Target linked (`webview::core`) to a user's C++ application
- Target linked (`webview::core_static`) to a user's C application
- Target linked (`webview::core_shared`) to a user's C application

**Compilers used:**
- MSVC (Windows)
- MINGW (Windows)
- LLVM (Linux)
- AppleClang (Mac)

**Usage:**
```bash
cd your/webview
git pull https://github.com/citkane/Weview-Build-Template.git
cd Weview-Build-Template

make
make run
```
