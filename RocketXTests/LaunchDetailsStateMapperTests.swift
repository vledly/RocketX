import XCTest
@testable import RocketX

final class LaunchDetailsStateMapperTests: XCTestCase {
    func testMapCreatesDisplayReadyContent() {
        let content = LaunchDetailsStateMapper().map(
            launch: SampleData.launch,
            rocket: SampleData.rocket,
            launchpad: SampleData.launchpad
        )

        XCTAssertEqual(content.title, "Crew-5")
        XCTAssertEqual(content.description, "A crewed mission to the International Space Station.")
        XCTAssertEqual(content.launchSite, "Kennedy Space Center Historic Launch Complex 39A")
        XCTAssertEqual(content.rocketID, "falcon-9")
        XCTAssertEqual(content.rocketName, "Falcon 9")
        XCTAssertEqual(content.rocketType, "Rocket")
        XCTAssertEqual(content.imageURL, SampleData.launch.imageURL)
        XCTAssertEqual(content.webcastURL, SampleData.launch.webcastURL)
        XCTAssertEqual(content.rocketImageURL, SampleData.rocket.imageURL)
        XCTAssertFalse(content.date.isEmpty)

        guard case .successful = content.status else {
            return XCTFail("Expected a successful launch status")
        }
    }
}
