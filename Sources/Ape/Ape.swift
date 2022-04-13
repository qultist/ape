import ArgumentParser
import Foundation

@main
struct Ape: ParsableCommand {

	static let configuration = CommandConfiguration(
		abstract: "Generate weekly repeating items from templates."
	)

	@Argument(help: "The path to the template.")
	var templatePath: String

	@Option(
		name: .shortAndLong,
		help: "The month to generate items for. Must be between 1 and 12. Defaults to the current month."
	)
	var month: Int?

	@Option(name: .shortAndLong, help: "The year (e.g. 2022) to generate items for. Defaults to the current year.")
	var year: Int?

	func run() throws {
		guard let templateUrl = URL(string: "file://\(templatePath)") else { throw ApeError.templatePathInvalid }
		let templateData = try Data(contentsOf: templateUrl)
		let template = try JSONDecoder().decode(Template.self, from: templateData)

		try template.render(forMonth: month, andYear: year)
			.map(\.tabSeparated)
			.forEach { print($0) }
	}
}

enum ApeError: LocalizedError {

	case templatePathInvalid

	var errorDescription: String? {
		switch self {
		case .templatePathInvalid:
			return "The path to the template is invalid."}
		}
	}
