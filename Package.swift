import PackageDescription

let package = Package(
    name: "autobuild",
    targets: [
        Target(
            name: "POSIX",
            dependencies: [.Target(name: "libc")]),
        Target(
            name: "CommandLine",
            dependencies: [.Target(name: "libc")]),
        Target(
            name: "dep",
            dependencies: [
                .Target(name: "POSIX"),
                .Target(name: "libc"),
                .Target(name: "CommandLine")
            ]),
                Target(
            name: "autobuild",
            dependencies: [.Target(name: "libc"),
                .Target(name: "dep")
            ]),
    ]
)


