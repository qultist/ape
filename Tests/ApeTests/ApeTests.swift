import XCTest
import class Foundation.Bundle

final class ApeTests: XCTestCase {

	private let iso8601Formatter = ISO8601DateFormatter()

	func testMain() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct
		// results.

		// Some of the APIs that we use below are available in macOS 10.13 and above.
		guard #available(macOS 10.13, *) else {
			return
		}

		// Mac Catalyst won't have `Process`, but it is supported for executables.
		#if !targetEnvironment(macCatalyst)

		let apeBinary = productsDirectory.appendingPathComponent("Ape")
		let templateUrl = Bundle.module.url(forResource: "one-day-template", withExtension: "json")!

		let process = Process()
		process.executableURL = apeBinary
		process.arguments = [templateUrl.absoluteString, "-m", "4", "-y", "2022"]

		let pipe = Pipe()
		process.standardOutput = pipe

		try process.run()
		process.waitUntilExit()

		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8)

		let dates = [
			"2022-04-04T00:00:00Z",
			"2022-04-11T00:00:00Z",
			"2022-04-18T00:00:00Z",
			"2022-04-25T00:00:00Z"
		]

		let dateFormatter = DateFormatter()
		dateFormatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")

		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency

		var expected = dates
			.map { d -> String in
				let date = dateFormatter.string(from: iso8601Formatter.date(from: d)!)
				let wage = numberFormatter.string(from: 1)!
				return "\(date)\titem\t1.0\t\(wage)"
			}
			.joined(separator: "\n")
		expected += "\n"

		XCTAssertEqual(expected, output)
		#endif
	}

	/// Returns path to the built products directory.
	var productsDirectory: URL {
		#if os(macOS)
		for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
			return bundle.bundleURL.deletingLastPathComponent()
		}
		fatalError("couldn't find the products directory")
		#else
		return Bundle.main.bundleURL
		#endif
	}
}
