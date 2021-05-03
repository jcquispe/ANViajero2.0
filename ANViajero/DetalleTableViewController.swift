//
//  DetalleTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 28/4/21.
//

import UIKit

class DetalleTableViewController: UITableViewController {

    var indice: Int64 = 0
    var f250 = ["INFORMACIÓN DEL VIAJE", "IDENTIFICACIÓN PERSONAL", "EQUIPAJE ACOMPAÑADO", "REGISTRO DE DIVISAS", "GENERAR CÓDIGO QR"]
    var f250_en = ["TRAVEL INFORMATION", "IDENTIFICATION", "ACCOMPANIED BAGGAGE", "CURRENCY REGISTRATION", "GENERATE QR CODE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return f250.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = f250[indexPath.row]
        cell.detailTextLabel?.text = "Esto es una prueba"
        cell.imageView?.image = UIImage(named: "user")
        cell.accessoryType = .detailButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "travelSegue", sender: self)
        case 1:
            performSegue(withIdentifier: "identificationSegue", sender: self)
        case 2:
            performSegue(withIdentifier: "baggageSegue", sender: self)
        case 3:
            performSegue(withIdentifier: "currencySegue", sender: self)
        default:
            print("nsldf")
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "travelSegue":
            let destination = segue.destination as? ViajeController
            destination!.indice = indice
        case "identificationSegue":
            let destination = segue.destination as? IdentificacionController
            destination!.indice = indice
        case "baggageSegue":
            let destination = segue.destination as? EquipajeController
            destination!.indice = indice
        case "currencySegue":
            let destination = segue.destination as? DivisaController
            destination!.indice = indice
        /*case "qucodeSegue":
            */
        default:
            print("Error")
        }
    }

}
