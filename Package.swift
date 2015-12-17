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
        Target(
            name: "CommandLine",
            dependencies: [.Target(name: "libc")]),
        Target(
            name: "dep",
            dependencies: [
                .Target(name: "sys"), 
                .Target(name: "PackageDescription"), 
                .Target(name: "POSIX"),
                .Target(name: "libc"),
                .Target(name: "CommandLine")
            ]),
                Target(
            name: "autobuild",
            dependencies: [.Target(name: "libc"),
                .Target(name: "sys"),
                .Target(name: "dep")
            ]),
        /*Target(*/
            /*name: "",*/
            /*dependencies: [.Target(name: "libc")]),*/
    ]
)


