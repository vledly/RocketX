import Foundation

enum SampleData {
    static let launch = Launch(
        id: "crew-5",
        name: "Crew-5",
        details: "A crewed mission to the International Space Station.",
        date: Date(timeIntervalSince1970: 1_665_000_000),
        status: .successful,
        rocketID: "falcon-9",
        launchpadID: "ksc-lc-39a",
        imageURL: URL(string: "https://images.example.com/crew-5.jpg"),
        thumbnailURL: URL(string: "https://images.example.com/crew-5-thumbnail.jpg"),
        webcastURL: URL(string: "https://www.youtube.com/watch?v=crew-5")
    )

    static let rocket = Rocket(
        id: "falcon-9",
        name: "Falcon 9",
        type: "rocket",
        details: "A reusable two-stage rocket designed and manufactured by SpaceX.",
        imageURL: URL(string: "https://images.example.com/falcon-9.jpg"),
        successRate: 99,
        active: true,
        stages: 2,
        firstFlight: "2010-06-04",
        engineCount: 9,
        engineType: "merlin"
    )

    static let launchpad = Launchpad(
        id: "ksc-lc-39a",
        name: "KSC LC-39A",
        fullName: "Kennedy Space Center Historic Launch Complex 39A"
    )

    static let launchWithLaunchpad = LaunchWithLaunchpad(
        launch: launch,
        launchpad: launchpad
    )
}
