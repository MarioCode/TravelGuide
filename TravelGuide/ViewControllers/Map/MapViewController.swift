//
//  MapViewController.swift
//  TravelGuide
//
//  Created by Anton Makarov on 31/03/2018.
//  Copyright © 2018 Anton Makarov. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var sightViewModel: SightViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLabel.text = CurrentUser.sharedInstance.city?.name
        mapView.delegate = self
        
        for place in (sightViewModel?.diplaySights)! {
            let annotation = PinAnnotation()
            annotation.coordinate = place.coordinate
            annotation.title = place.name
            annotation.image = UIImageView()
            
            let url = URL(string: place.imagesURL.first!)
            annotation.image!.kf.setImage(with: url)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        if !annotation.isKind(of: PinAnnotation.self) {
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PinView")
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinView")
            }
            return pinAnnotationView
        }
        
        var view: AnnotationImageView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? AnnotationImageView
        if view == nil {
            view = AnnotationImageView(annotation: annotation, reuseIdentifier: "imageAnnotation")
        }
        
        let annotation = annotation as! PinAnnotation
        view?.image = annotation.image?.image
        view?.annotation = annotation
        //view?.canShowCallout = true
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view:  MKAnnotationView){
        
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
