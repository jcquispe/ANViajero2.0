//
//  DivisaController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 3/5/21.
//

import UIKit

class DivisaController: UIViewController {

    var indice: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEmbed" {
            let destination = segue.destination as! DivisaTableViewController
            destination.indice = indice
        }
    }

}
