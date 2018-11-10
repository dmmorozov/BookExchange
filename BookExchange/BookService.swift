import Foundation
import Alamofire
import SwiftyJSON

class BookService {
    /// Singleton
    static let sharedInstance = BookService()
}

// MARK: - URL
extension BookService {
    static let baseUrl = "http://95.213.28.133/server/"
    
    static func token() -> String {
        return "\(baseUrl)token/by_vk_token"
    }
}

// MARK: - Getting data
extension BookService {
    func send(token: String, onComplete: @escaping (String?) -> Void) {
        let parameters: [String: AnyObject] = [
            "token" : token as AnyObject]
        Alamofire.request(BookService.token(), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            
            switch response.result {
            case .failure(let error):
                print(error)
                onComplete(nil)
                
            case .success(let data):
                let json = JSON(data)
                let token = self.parseToken(json)
                onComplete(token)
            }
        }
    }
    
    /*func BookService(city: String, onComplete: @escaping (CityCurrentWeather?) -> Void) {
        Alamofire.request(WeatherService.currentWeatherUrl(city: city)).responseJSON {
            response in
            
            switch response.result {
            case .failure(let error):
                print(error)
                onComplete(nil)
                
            case .success(let data):
                let json = JSON(data)
                let result = self.parseCurrentWeather(json)
                onComplete(result)
            }
        }
    }
    
    func getCurrentWeathers(cityIds: [String], onComplete: @escaping ([CityCurrentWeather]) -> Void) {
        Alamofire.request(WeatherService.currentWeathersUrl(cityIds: cityIds)).responseJSON {
            response in
            
            switch response.result {
            case .failure(let error):
                print(error)
                onComplete([])
                
            case .success(let data):
                let json = JSON(data)
                let result = self.parseCurrentWeathers(json)
                onComplete(result)
            }
        }
    }
    
    func getForecast(cityId: String, onComplete: @escaping ([Forecast]) -> Void) {
        Alamofire.request(WeatherService.forecastUrl(cityId: cityId)).responseJSON {
            response in
            
            switch response.result {
            case .failure(let error):
                print(error)
                onComplete([])
                
            case .success(let data):
                let json = JSON(data)
                let result = self.parseForecast(json)
                onComplete(result)
            }
        }
    }*/
}

extension BookService {
    func parseToken(_ json: JSON) -> String? {
        return json["token"].string
    }
}
