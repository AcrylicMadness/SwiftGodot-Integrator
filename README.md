# SwiftGodot Integrator (or sgint, for short) #

A simple cross-platform command line tool that makes working with [SwiftGodot](https://github.com/migueldeicaza/SwiftGodot) easier.

> [!NOTE]
> Building Swift-based Godot Extensions on Linux or Windows requires referencing Swift Runtime libraries in .gdextension file.
> This functionality is still work-in-progress.

Requires [Swift Toolchain](https://www.swift.org/install/linux/).
iOS / iOS Simulator builds require Xcode Command Line Tools.

## Getting started ##

Use this command to clone and build sgint inside current working directory:
```
curl -s https://raw.githubusercontent.com/AcrylicMadness/SwiftGodot-Integrator/refs/heads/main/setup.sh | bash
```
You can then move sgint into your /bin/ folder, or just put it into you game's root directory and use it from there.

## Usage ##

### Creating SwiftGodot extension ###

To create a new Swift-based GDExtension for your game, run following command from directory, containing `project.godot` for yor game:
```
sgint integrate
```
This will initialize a new Swift Package and configure it to work with SwiftGodot (add dependencies, set minimum target versions).
By default, name for the package will be inferred from current directory with '-Driver' suffix. You can use `-d, --driver-name <driver-name>` flag to customize the name.
```
sgint integrate -d CustomName
```

### Building ###

To build your Swift-based Godot extension, run:
```
sgint
```
This will build all the Swift code, move resulting libraries into /bin/ folder of your game and create a .gdextension file referencing them.
Use `-d, --driver-name <driver-name>` flag if you have a custom Swift Package name that sgint failed to infer:
```
sgint -d CustomName
```

On macOS, you can use `-t, --targets <targets>` flag to build for iOS or iOS Simulator as well (Requires Xcode Command Line Tools).
```
sgint -t macos -t ios
```
This command will build your extension for both macOS and iOS. Please note, that GDExtension format does not support referencing separate files for iOS and iOS Simulator, so using `sgint -p ios -p iossimulator` will fail.
