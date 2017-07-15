import PackageDescription

let package = Package(
    name: "autobuild",
    targets: [
        Target(
            name: "POSIX",
            dependencies: [.Target(name: "libc")]),
        Target(
            name: "CommandLineKit",
            dependencies: [.Target(name: "libc")]),
        Target(
            name: "autobuild",
            dependencies: [
                .Target(name: "POSIX"),
                .Target(name: "libc"),
                .Target(name: "CommandLineKit")
            ])
    ]
)


