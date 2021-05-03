//
//  IdentificacionController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 30/4/21.
//

import UIKit

class IdentificacionController: UIViewController {

    var indice: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEmbed" {
            let destination = segue.destination as! IdentificacionTableViewController
            destination.indice = indice
        }
    }

}
