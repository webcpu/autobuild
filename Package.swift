import PackageDescription

let package = Package(
    name: "autobuild",
    targets: [
        Target(
            name: "sys",
            dependencies: [.Target(name: "POSIX")]),
        Target(
            name: "POSIX",
            dependencies: [.Target(name: "libc")]),
        //Target(
        //name: "dep",
        //dependencies: [.Target(name: "sys"), .Target(name: "PackageDescription")]),
        Target(
            name: "CommandLine",
            dependencies: [.Target(name: "libc")]),
        Target(
            name: "HaskellSwift",
            dependencies: [.Target(name: "libc")]),
        Target(
            name: "autobuild",
            dependencies: [.Target(name: "libc"),
                .Target(name: "POSIX"),
                .Target(name: "sys"),
                .Target(name: "HaskellSwift"),
                .Target(name: "CommandLine")
            ])
    ]
)

