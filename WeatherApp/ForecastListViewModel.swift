
import CoreLocation
import Foundation
import SwiftUI

enum TempUnits: Int {
    case celsius = 0
    case fahrenheit = 1
}

class ForecastListViewModel: ObservableObject {
    
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }

    @Published var forecasts: [ForecastViewModel] = []
    var appError: AppError? = nil
    @Published var isLoading: Bool = false
    @AppStorage("location") var location: String = ""
    @AppStorage("system") var system: TempUnits = .celsius {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    init () {
        if !location.isEmpty {
            getWeatherForecast()
        }
    }
    
    func getWeatherForecast() {
        isLoading = true
        let apiService = APIService.shared
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                self.isLoading = false
                self.appError = AppError(errorString: error.localizedDescription)
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                // Don't forget to use your own key
                        apiService.getJSON(urlString: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid={your_api_key}",
                                           dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in

                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system)}
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            self.isLoading = false
                            self.appError = AppError(errorString: errorString)
                            print(errorString)
                        }
                    }
                }
            }
        }

    }
}
