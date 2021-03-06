//
//  CityViewModel.swift
//  TravelGuide
//
//  Created by Anton Makarov on 22.03.2018.
//  Copyright © 2018 Anton Makarov. All rights reserved.
//

import UIKit

class CityViewModel {
    
    var cities = [City]()
    
    func getAllCitiesFromDatabase(completion: @escaping () -> ()) {
        let savedCities = CurrentUser.sharedInstance.allSavedCities
        var cities: [City]?
        
        for cityId in savedCities {
            guard let city = DBManager.sharedInstance.getCityById(id: cityId) else {
                continue
            }
            
            var sights = [Sight]()
            for res in city.sights {
                if let sight = Sight(sRealm: res) {
                    sights.append(sight)
                }
            }

            let newCity = City(id: NSNumber(integerLiteral: cityId), country: NSNumber(integerLiteral: city.country), name: city.name, sights: sights, urlImage: city.image, isDownload: true)
            cities?.append(newCity)
        }
        
        completion()
    }
    
    func getAllCity(completion: @escaping () -> ()) {
        APIService.shared.getCities{ response, error in
            
            guard error == nil || (response != nil && response?.status == "error") else {
                return
            }
            
            response?.arrayData?.forEach( { self.cities.append($0.value) })
            completion()
        }
    }
    
    func cellInstance(_ tableView: UITableView, cellForItemAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityListTableViewCell
        
        let city = self.cities[indexPath.row]
        cell.cityName.text = city.name
        
        let url = URL(string: city.urlImage)
        cell.cityImage.kf.setImage(with: url)
        
        return cell
    }
}
