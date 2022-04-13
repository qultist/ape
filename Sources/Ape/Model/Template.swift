import Foundation

struct Template: Codable {

	let name: String
	let items: [Item]

	func render(forMonth month: Int? = nil, andYear year: Int? = nil) throws -> [RenderedItem] {
		if let month = month, !(1...12 ~= month) {
			throw TemplateError.monthInvalid
		}

		var startDateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
		startDateComponents.month = month ?? startDateComponents.month
		startDateComponents.year = year ?? startDateComponents.year

		var calender = Calendar(identifier: .iso8601)
		calender.timeZone = TimeZone(identifier: "UTC")!

		var renderedItems = [RenderedItem]()

		calender.enumerateDates(
			startingAfter: calender.date(from: startDateComponents)!,
			matching: DateComponents(hour: 0),
			matchingPolicy: .strict
		) { result, _, stop in
			guard let date = result, calender.component(.month, from: date) == startDateComponents.month else {
				stop = true
				return
			}

			for item in items {
				let weekdays = item.weekdays.map(\.number)
				if weekdays.contains(calender.component(.weekday, from: date)) {
					renderedItems.append(
						RenderedItem(date: date, name: item.name, quantity: item.quantity, wage: item.wage)
					)
				}
			}
		}

		return renderedItems
	}
}

// MARK: - Item
extension Template {

	struct Item: Codable {
		let name: String
		let weekdays: [Weekday]
		let quantity: Double
		let wage: Double
	}
}

// MARK: - RenderedItem
extension Template {

	struct RenderedItem: Equatable {

		let date: Date
		let name: String
		let quantity: Double
		let wage: Double

		var tabSeparated: String {
			let formattedDate = dateFormatter.string(from: date)
			let formattedWage = numberFormatter.string(from: wage as NSNumber)!

			return "\(formattedDate)\t\(name)\t\(quantity)\t\(formattedWage)"
		}
	}
}

// MARK: - TemplateError
enum TemplateError: LocalizedError {

	case monthInvalid

	var errorDescription: String? {
		switch self {
		case .monthInvalid:
			return "Month must be between 1 and 12."
		}
	}
}
