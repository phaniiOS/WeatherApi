//
//  ViewController.swift
//  WeatherApi
//
//  Created by IMCS2 on 2/22/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cityField: UITextField!
    
    @IBOutlet var weatherOutput: UITextView!
    @IBOutlet var mainView: UIView!
    
    @IBAction func checkAction(_ sender: Any) {
        var city = cityField.text!
        city = city.capitalized
        if city.contains(" "){
            let temp = city.split(separator: " ")
            city = ""
            for i in 0 ..< temp.count{
                city += temp[i]
                if(i != temp.count - 1){
                    city += "%20"
                }
            }
        }
//                   print(city)
        let urlString: String = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=50197e49f9b400fc3e782350dc658374"
        guard let request = URL(string: urlString) else {
            weatherOutput.text = "There is something wrong with the URL"
            return
        }

        let jsonDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            self.showSpinner(onView: self.mainView)
            if error == nil {
                if let unwrapdata = data {
                    do{
                        let jsonData = try JSONSerialization.jsonObject(with: unwrapdata, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        if let jsonWeather = jsonData?["weather"] {
                            var weatherDescription = ""
                            let jsonWeatherArray = jsonWeather as! NSArray
                            for weather in jsonWeatherArray {
                                var desdcription = (weather as! NSDictionary)["description"] as! String
                                weatherDescription += desdcription + " "
                            }
                            DispatchQueue.main.async {
                                self.weatherOutput.text = weatherDescription
//                                self.removeSpinner()
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.weatherOutput.text = "Invalid City"
//                                self.removeSpinner()
                            }
                        }
                    }catch {
                        print("Error fetching API")
                    }
                }
            }
        }
        jsonDataTask.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Clouds")!)
    }
    
}

