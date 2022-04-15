import XCTest
import class Foundation.Bundle
@testable import Ape

final class TemplateTests: XCTestCase {

	private let iso8601Formatter = ISO8601DateFormatter()

	func testRenderOneDay() throws {
		let templateUrl = Bundle.module.url(forResource: "one-day-template", withExtension: "json")
		let data = try Data(contentsOf: templateUrl!)

		let template = try JSONDecoder().decode(Template.self, from: data)
		let renderedItems = try template.render(forMonth: 4, andYear: 2022)

		let expectedDates = [
			iso8601Formatter.date(from: "2022-04-04T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-11T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-18T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-25T00:00:00Z")!
		]

		let expectedItems = expectedDates.map { Template.RenderedItem(date: $0, name: "item", quantity: 1, wage: 1) }

		XCTAssertEqual(expectedItems, renderedItems)
	}

	func testRenderTwoDays() throws {
		let templateUrl = Bundle.module.url(forResource: "two-days-template", withExtension: "json")
		let data = try Data(contentsOf: templateUrl!)

		let template = try JSONDecoder().decode(Template.self, from: data)
		let renderedItems = try template.render(forMonth: 4, andYear: 2022)

		let expectedDates = [
			iso8601Formatter.date(from: "2022-04-04T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-06T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-11T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-13T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-18T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-20T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-25T00:00:00Z")!,
			iso8601Formatter.date(from: "2022-04-27T00:00:00Z")!
		]

		let expectedItems = expectedDates.map { Template.RenderedItem(date: $0, name: "item", quantity: 1, wage: 1) }

		XCTAssertEqual(expectedItems, renderedItems)
	}

	func testRenderLastDayOfMonth() throws {
		let templateUrl = Bundle.module.url(forResource: "last-day-of-month-template", withExtension: "json")
		let data = try Data(contentsOf: templateUrl!)

		let template = try JSONDecoder().decode(Template.self, from: data)
		let renderedItems = try template.render(forMonth: 4, andYear: 2022)

		let expectedItem = Template.RenderedItem(
			date: iso8601Formatter.date(from: "2022-04-30T00:00:00Z")!,
			name: "item",
			quantity: 1,
			wage: 1
		)

		XCTAssertEqual(expectedItem, renderedItems.last)
	}

	func testRenderEmpty() throws {
		let templateUrl = Bundle.module.url(forResource: "empty-template", withExtension: "json")
		let data = try Data(contentsOf: templateUrl!)

		let template = try JSONDecoder().decode(Template.self, from: data)
		let renderedItems = try template.render(forMonth: 4, andYear: 2022)

		XCTAssertTrue(renderedItems.isEmpty)
	}

	func testRenderInvalidMonth() throws {
		let templateUrl = Bundle.module.url(forResource: "one-day-template", withExtension: "json")
		let data = try Data(contentsOf: templateUrl!)

		let template = try JSONDecoder().decode(Template.self, from: data)

		XCTAssertThrowsError(try template.render(forMonth: 13))
	}

	func testTabSeparated() throws {
		let templateUrl = Bundle.module.url(forResource: "one-day-template", withExtension: "json")
		let data = try Data(contentsOf: templateUrl!)

		let template = try JSONDecoder().decode(Template.self, from: data)
		let renderedItems = try template.render(forMonth: 4, andYear: 2022)

		let dateFormatter = DateFormatter()
		dateFormatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")

		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency

		let date = dateFormatter.string(from: iso8601Formatter.date(from: "2022-04-04T00:00:00Z")!)
		let wage = numberFormatter.string(from: 1)!
		let expected = "\(date)\titem\t1.0\t\(wage)"

		XCTAssertEqual(expected, renderedItems.first?.tabSeparated)
	}

	func testWeekdayDecoding() throws {
		let templateUrl = Bundle.module.url(forResource: "all-weekdays-template", withExtension: "json")
		let data = try Data(contentsOf: templateUrl!)

		_ = try JSONDecoder().decode(Template.self, from: data)
	}

	func testMisspelledWeekday() throws {
		let templateUrl = Bundle.module.url(forResource: "misspelled-weekday-template", withExtension: "json")
		let data = try Data(contentsOf: templateUrl!)

		XCTAssertThrowsError(try JSONDecoder().decode(Template.self, from: data))
	}

	func testInvalidTemplate() throws  {
		let templateUrl = Bundle.module.url(forResource: "invalid-template", withExtension: "json")
		let data = try Data(contentsOf: templateUrl!)

		XCTAssertThrowsError(try JSONDecoder().decode(Template.self, from: data))
	}
}
