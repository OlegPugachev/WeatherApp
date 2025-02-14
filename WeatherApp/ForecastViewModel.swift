
import Foundation

struct ForecastViewModel {
    let forecast: Forecast.Daily
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM, d"
        return dateFormatter
    }
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        return numberFormatter
    }
    
    private static var numberFormatterPercent: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    var day: String {
        return Self.dateFormatter.string(from: forecast.dt)
    }
    
    var overview: String {
        forecast.weather[0].description.capitalized
    }
    
    var high: String {
        return "H: \(Self.numberFormatter.string(from: forecast.temp.max as NSNumber) ?? "0")°"
    }
    
    var low: String {
        return "L: \(Self.numberFormatter.string(from: forecast.temp.min as NSNumber) ?? "0")°"
    }
    
    var pop: String {
        return "💧 \(Self.numberFormatterPercent.string(from: forecast.pop as NSNumber) ?? "0%" )"
    }
    
    var clouds: String {
        return "☁️ \(forecast.clouds)%"
    }
    
    var humidity: String {
        return "Humidity: \(forecast.humidity)%"
    }
}
