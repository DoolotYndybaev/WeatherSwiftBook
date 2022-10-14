//
//  ViewController.swift
//  WeatherSwiftBook
//
//  Created by Doolot on 14/10/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var weatherIconImageView: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var feelsLikeTemperatureLabel: UILabel!
    
    var netWorkWeatherManager = NetWorkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        // kCLLocationAccuracyKilometer - точность определения местоположения в радиусе километра
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        // requestWhenInUseAuthorization - запрос на использование местоположения
        // Но с условием что мы в инфоплист заполнили необходимую бланку
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.netWorkWeatherManager.fetchCurrentWeather(forCity: city)
            
        }
    }
    @IBAction func currentLocationAction(_ sender: UIButton) {
        let long = (locationManager.location?.coordinate.longitude)!
        let lat = (locationManager.location?.coordinate.latitude)!
        self.netWorkWeatherManager.fetchCurrentWeather(forLatitude: lat, forLongitude: long)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        netWorkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        // Если настройка геопазиции выключена вообще в телефоне
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func updateInterfaceWith(weather: CurrentWeather) {
        // Обновление интерфейса должна происходить в главном потоке причем ассинхронно чтобы не загружать главную очередь и чтобы наше приложение не зависло
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        guard let location = locations.last else { return }
        //        let latitude = location.coordinate.latitude
        //        let longitude = location.coordinate.longitude
        //
        //        netWorkWeatherManager.fetchCurrentWeather(forLatitude: latitude, forLongitude: longitude)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
