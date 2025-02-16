import Foundation

public enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist not found")
        }
        return dict
    }()
    
    static let baseURL: URL = {
        guard let baseURL = Config.infoDictionary[Keys.baseURL.rawValue] as? String else {
            fatalError("Base URL not set in plist")
        }
        guard let url = URL(string: baseURL) else {
            fatalError("Base URL is invalid")
        }
        return url
    }()
    
    static let openWeatherMapKEY: String = {
        guard let key = Config.infoDictionary[Keys.openWeatherMapKEY.rawValue] as? String else {
            fatalError("API key not set in plist")
        }
        if key.isEmpty {
            fatalError("API key not set in Config file")
        }
        return key
    }()
    
    private enum Keys: String {
        case baseURL = "BASE_URL"
        case openWeatherMapKEY = "OPEN_WEATHER_MAP_KEY"
    }
}


