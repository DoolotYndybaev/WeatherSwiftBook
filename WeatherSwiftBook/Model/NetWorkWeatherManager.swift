//
//  NetWorkWeatherManager.swift
//  WeatherSwiftBook
//
//  Created by Doolot on 14/10/22.
//

import Foundation
import CoreLocation

class NetWorkWeatherManager {
    // Создаем клоужер
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forCity city: String){
        // Стринг адресс urlString
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        // Создаем URL
        guard let url = URL(string: urlString) else { return }
        //Вся работа с сетевыми запросами идет через сессию
        let session = URLSession(configuration: .default)
        // создаем запрос и он возрващает dataTask
        let task = session.dataTask(with: url) { data, responce, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        // Почему мы вызываем resume потому что у нас создается Task в подвешенном состоянии и для того что бы он начал работу т.е произошел запрос мы должны вызвать resume
        task.resume()
    }
    func fetchCurrentWeather(forLatitude: CLLocationDegrees, forLongitude: CLLocationDegrees){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(forLatitude)&lon=\(forLongitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, responce, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        task.resume()
    }
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        // для того чтобы декодировать наши данные с JSON в наш формат мы должны создать JSONDecoder
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
