//
//  ViewController.swift
//  pokesearch
//
//  Created by paul on 20/03/2017.
//  Copyright © 2017 paul. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase



class ViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate, MyProtocol{

    let locationManager =  CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    var mapHasCentredOnce = false
    var geofire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode=MKUserTrackingMode.follow
        geoFireRef =  FIRDatabase.database().reference()
        geofire = GeoFire(firebaseRef: geoFireRef)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
   
    }
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse
        {
            mapView.showsUserLocation = true
        }
    }
    
    func centreMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location
        {
            if !mapHasCentredOnce{
                centreMapOnLocation(location: loc)
                mapHasCentredOnce = true
            }
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        let annoIdentifier = "Pokemon"
        if annotation.isKind(of: MKUserLocation.self){
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image=UIImage(named: "ash")
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier){
            annotationView = deqAnno
            annotationView?.annotation = annotation
        }else{
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        if let annotationView = annotationView, let anno = annotation as? PokemonAnnotation{
            
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.pokemonNumber)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        
        }
        return annotationView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createSighting(forLocation location: CLLocation,withPokemon pokeId: Int){
        geofire.setLocation(location, forKey: "\(pokeId)")
    }
    func showSightingsOnMap(location: CLLocation){
        let circleQuery = geofire!.query(at: location, withRadius: 2000)
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (
            key, location) in
            if let key = key, let location = location {
             let anno = PokemonAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                self.mapView.addAnnotation(anno)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(location: loc)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? PokemonAnnotation{
            let place = MKPlacemark(coordinate: anno.coordinate)
            let destination = MKMapItem(placemark: place)
            destination.name = "Pokemon Sighting"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate,regionDistance, regionDistance)
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey:  NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PokemonSelectController {
             if segue.identifier == "PokemonSelect" {
                controller.myProtocol = self
            slideInTransitioningDelegate.direction = .left
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
            }
    }
    }
    
    func setPokemon(pokemon: Int)
    {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        createSighting(forLocation: loc, withPokemon: pokemon)
    }
    

}

