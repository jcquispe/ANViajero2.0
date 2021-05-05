//
//  EquipajeController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 3/5/21.
//

import UIKit

class EquipajeController: UIViewController {

    var indice: Int64 = 0
    let lang = Bundle.main.preferredLocalizations.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "es-419"{
            navigationItem.title = "EQUIPAJE"
        }
        else {
            navigationItem.title = "BAGGAGE"
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEmbed" {
            let destination = segue.destination as! EquipajeTableViewController
            destination.indice = indice
        }
    }

}
