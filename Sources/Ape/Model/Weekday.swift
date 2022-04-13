import Foundation

enum Weekday: String, Codable {

	case sunday, monday, tuesday, wednesday, thursday, friday, saturday

	var number: Int {
		switch self {
		case .sunday:
			return 1
		case .monday:
			return 2
		case .tuesday:
			return 3
		case .wednesday:
			return 4
		case .thursday:
			return 5
		case .friday:
			return 6
		case .saturday:
			return 7
		}
	}
}
