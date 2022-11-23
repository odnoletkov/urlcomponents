import XCTest

class URLComponentsTests: XCTestCase {

    func testURLComponentsQueryIsAmbiguous() {
        XCTAssertEqual(
            URLComponents(string: "/path?a=b&b")!.query!,
            URLComponents(string: "/path?a=b%26b")!.query!
        )
    }

    func testURLComponentsCodingIsNotRevirsible() {
        let components = URLComponents(string: "/path?a=b%26b")!
        XCTAssertTrue(try components.cycleCodingDataEqual())
        XCTAssertFalse(try components.cycleCodiingValuesEqual())
    }
}

extension Decodable where Self: Encodable {
    func cycleCodingDataEqual() throws -> Bool {
        let data = try JSONEncoder().encode(self)
        let clone = try JSONDecoder().decode(Self.self, from: data)
        let cloneData = try JSONEncoder().encode(clone)
        return data == cloneData
    }
}

extension Decodable where Self: Encodable, Self: Equatable {
    func cycleCodiingValuesEqual() throws -> Bool {
        try self == JSONDecoder().decode(Self.self, from: JSONEncoder().encode(self))
    }
}
