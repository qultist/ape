import Foundation

let dateFormatter: DateFormatter = {
	let dateFormatter = DateFormatter()
	dateFormatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")

	return dateFormatter
}()

let numberFormatter: NumberFormatter = {
	let numberFormatter = NumberFormatter()
	numberFormatter.numberStyle = .currency

	return numberFormatter
}()
