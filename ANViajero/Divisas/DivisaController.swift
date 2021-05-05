//
//  DivisaController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 3/5/21.
//

import UIKit

class DivisaController: UIViewController {

    var indice: Int64 = 0
    let lang = Bundle.main.preferredLocalizations.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "es-419"{
            navigationItem.title = "DIVISAS"
        }
        else {
            navigationItem.title = "CURRENCY"
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEmbed" {
            let destination = segue.destination as! DivisaTableViewController
            destination.indice = indice
        }
    }

}
