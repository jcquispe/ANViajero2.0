//
//  IdentificacionController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 30/4/21.
//

import UIKit

class IdentificacionController: UIViewController {

    var indice: Int64 = 0
    let lang = Bundle.main.preferredLocalizations.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "es-419"{
            navigationItem.title = "PERSONAL"
        }
        else {
            navigationItem.title = "PERSONAL"
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEmbed" {
            let destination = segue.destination as! IdentificacionTableViewController
            destination.indice = indice
        }
    }

}
