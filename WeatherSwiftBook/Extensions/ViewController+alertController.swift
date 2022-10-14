//
//  ViewController+alertController.swift
//  WeatherSwiftBook
//
//  Created by Doolot on 14/10/22.
//

import Foundation
import UIKit

extension ViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                // Если ввести два слова например New York то данные не придут
                // Поэтому когда мы работаем с поисковой строкой надо обьединять инфу
                // Мы создаем новое имя в которой берется введенная инфа и если он содержит несколько элементов разделенные пробелом то оно их разделяет в массив т.е ["New", "York"] и затем с помощью joined(separator: "%20") мы обьединяем их
                let city = cityName.split(separator: " ").joined(separator: "%20")
                print("search info for the \(city)")
                //                self.netWorkWeatherManager.fetchCurrentWeather(forCity: cityName)
                completionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}
