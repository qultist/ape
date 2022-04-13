import XCTest
import class Foundation.Bundle

final class ApeTests: XCTestCase {

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

		let expected = """
			04.04.2022\titem\t1.0\t1,00 €
			11.04.2022\titem\t1.0\t1,00 €
			18.04.2022\titem\t1.0\t1,00 €
			25.04.2022\titem\t1.0\t1,00 €\n
			"""

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
