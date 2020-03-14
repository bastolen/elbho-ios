//
//  CarDetailViewController.swift
//  ELBHO Adviseurs
//
//  Created by Kevin Bosma on 08/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import SwiftKeychainWrapper
import MaterialComponents
import Kingfisher
import GoogleMaps

class CarDetailViewController : UIViewController {
    let nc = NotificationCenter.default
    
    let geoCoder = CLGeocoder()
    
    var item : CarReservation? = nil
    var rows: [DetailViewRow] = []
    let tableFooter = UIView();
    
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var ImageHolder: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: MDCButton!
    
    private let disposeBag = DisposeBag()
    private var callSend: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyCgUVIYKDg-seHCHk3q-NsjCL2SxyDOd1w")
        
        let fullCarName = "\(String(describing: item!.vehicle.brand)) \(String(describing: item!.vehicle.model))"
        carNameLabel.text = fullCarName
        ImageHolder.kf.setImage(with: item?.vehicle.image)
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailViewCell", bundle: nil), forCellReuseIdentifier: "DetailViewCell")
        cancelButton.setTitle("button_car_cancel".localize.uppercased(), for: .normal)
        cancelButton.setDanger()
        
        setGoogleMaps(address: (item?.vehicle.location)!)
        
        // START GOOGLE MAPS
        tableFooter.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 270)
        tableView.tableFooterView = tableFooter
        tableView.reloadData()
    }
    
    func setGoogleMaps(address:String)
    {
        geoCoder.geocodeAddressString((address)) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 15.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            marker.map = mapView
            
            mapView.frame = CGRect(x: 15, y: 0, width: self.view.frame.width - 40, height: 270)
            self.tableFooter.addSubview(mapView)
        }
    }

    @IBAction func carCancelReservationClick(_ sender: Any) {
        if(!callSend) {
            callSend = true
            APIService.deleteCarReservation(_id: item!._id).subscribe(onNext: {
                self.showSnackbarSuccess("reservation_canceled".localize)
                self.callSend = false
                self.nc.post(name: Notification.Name("reloadCarReservations"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }, onError: {error in
                self.showSnackbarDanger("error_api".localize)
                self.callSend = false
            }).disposed(by: disposeBag)
        }
        
    }
    
}

extension CarDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell", for: indexPath ) as! DetailViewCell
        cell.titleLabel.text = row.title.uppercased()
        cell.contentLabel.text = row.content
        
        if row.icon != nil {
            cell.iconView.image = row.icon
            cell.iconView.addTapGestureRecognizer(action: row.iconClicked)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

