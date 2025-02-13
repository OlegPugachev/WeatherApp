
import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var location: String = ""
    @State var forecast: Forecast? = nil
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "E, MMM, d"
    }
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter Location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button{
                        getWeatherForecast(for: location)
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                    }
                }
                if let forecast = forecast {
                    List(forecast.daily, id: \.dt) { day in
                        VStack(alignment: .leading) {
                            Text(dateFormatter.string(from: day.dt))
                                .fontWeight(.bold)
                            HStack {
                                Image(systemName: "hourglass")
                                    .font(.title)
                                    .frame(width: 50, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.green))
                                VStack(alignment: .leading){
                                    Text(day.weather[0].description.capitalized)
                                    HStack {
                                        Text("High: \(day.temp.max, specifier: "%.0f")")
                                        Text("Low: \(day.temp.min, specifier: "%.0f")")
                                    }
                                    HStack {
                                        Text("Clouds: \(day.clouds)")
                                        Text("POP: \(day.pop)")
                                    }
                                    Text("Humidity: \(day.humidity)")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }else {
                    Spacer()
                }
            }.padding(.horizontal)
                .navigationTitle("Weather")
        }
    }
    
    func getWeatherForecast(for location: String) {
        let apiService = APIService.shared
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                // Don't forget to use your own key
                apiService.getJSON(urlString:"https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid={your api key}",
                                   dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
                    switch result {
                        case .success(let forecast):
                            self.forecast = forecast
                            //                            for day in forecast.daily {
                            //                                print(dateFormatter.string(from: day.dt))
                            //                                print("Max: ", day.temp.max)
                            //                                print("Min: ", day.temp.min)
                            //                                print("Humidity: ", day.humidity)
                            //                                print("Description: ", day.weather[0].description)
                            //                                print("Clouds: ", day.clouds)
                            //                                print("pop: ", day.pop)
                            //                                print("IconURL: ", day.weather[0].weatherIconURL)
                            //                            }
                        case .failure(let apiError):
                            switch apiError {
                                case .error(let errorString):
                                    print(errorString)
                            }
                    }
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
