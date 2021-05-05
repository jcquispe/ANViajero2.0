//
//  NuevoViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 30/4/21.
//

import UIKit

class ViajeController: UIViewController {
    
    var indice: Int64 = 0
    let lang = Bundle.main.preferredLocalizations.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "es-419"{
            navigationItem.title = "VIAJE"
        }
        else {
            navigationItem.title = "TRAVEL"
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEmbed" {
            let destination = segue.destination as! ViajeTableViewController
            destination.indice = indice
        }
    }
    
}
