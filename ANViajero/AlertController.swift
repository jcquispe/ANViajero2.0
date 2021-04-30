//
//  AlertController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 30/4/21.
//

import UIKit

class AlertController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func alert(_ titulo: String, _ mensaje: String, _ confirmar: String) -> UIAlertController{
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        //self.present(alert, animated: true)
        
        
        return alert
    }

}
