//
//  DetalleTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 28/4/21.
//

import UIKit

class DetalleTableViewController: UITableViewController {

    var indice: Int64 = 0
    var dbc: dbController = dbController()
    let gen: AlertController = AlertController()
    let lang = Bundle.main.preferredLocalizations.first
    
    var f250 = ["INFORMACIÓN DEL VIAJE", "IDENTIFICACIÓN PERSONAL", "EQUIPAJE ACOMPAÑADO", "REGISTRO DE DIVISAS", "GENERAR CÓDIGO QR"]
    var f250_en = ["TRAVEL INFORMATION", "IDENTIFICATION", "ACCOMPANIED BAGGAGE", "CURRENCY REGISTRATION", "GENERATE QR CODE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = dbc.getDescripcion("titulo", indice)
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return f250.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let query = dbc.validaForm250(indice)
        if lang == "es-419"{
            cell.textLabel?.text = f250[indexPath.row]
            switch f250[indexPath.row]{
            case "INFORMACIÓN DEL VIAJE":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "¡Información completa!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "travel_blue")
                    cell.accessoryType = .none
                }
                else{
                    cell.detailTextLabel?.text = "Información incompleta"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "travel")
                    cell.accessoryType = .detailButton
                }
                
            case "IDENTIFICACIÓN PERSONAL":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "¡Información completa!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "user_blue")
                    cell.accessoryType = .none
                }
                else{
                    cell.detailTextLabel?.text = "Información incompleta"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "user")
                    cell.accessoryType = .detailButton
                }
            
            
            case "EQUIPAJE ACOMPAÑADO":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "¡Información completa!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "baggabe_blue")
                    cell.accessoryType = .none
                }
                else{
                    cell.detailTextLabel?.text = "Información incompleta"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "baggabe")
                    cell.accessoryType = .detailButton
                }
                
            case "REGISTRO DE DIVISAS":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "¡Información completa!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "money_blue")
                    cell.accessoryType = .none
                }
                else{
                    cell.detailTextLabel?.text = "Información incompleta"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "money")
                    cell.accessoryType = .detailButton
                }
                
            case "GENERAR CÓDIGO QR":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "¡Listo para generar!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "qr_blue")
                }
                else{
                    cell.detailTextLabel?.text = "Debe completar toda la información"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "qr")
                }
            default: break
            }
        }
        else{
            cell.textLabel?.text = f250_en[indexPath.row]
            
            switch f250_en[indexPath.row]{
            case "TRAVEL INFORMATION":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "Information complete!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "travel_blue")
                    cell.accessoryType = .none
                }
                else{
                    cell.detailTextLabel?.text = "Information uncomplete"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "travel")
                    cell.accessoryType = .detailButton
                }
                
            case "IDENTIFICATION":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "Information complete!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "user_blue")
                    cell.accessoryType = .none
                }
                else{
                    cell.detailTextLabel?.text = "Information uncomplete"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "user")
                    cell.accessoryType = .detailButton
                }
            
            case "ACCOMPANIED BAGGAGE":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "Information complete!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "baggabe_blue")
                    cell.accessoryType = .none
                }
                else{
                    cell.detailTextLabel?.text = "Information uncomplete"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "baggabe")
                    cell.accessoryType = .detailButton
                }
                
            case "CURRENCY REGISTRATION":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "Information complete!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "money_blue")
                    cell.accessoryType = .none
                }
                else{
                    cell.detailTextLabel?.text = "Information uncomplete"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "money")
                    cell.accessoryType = .detailButton
                }
                
            case "GENERATE QR CODE":
                if query[indexPath.row] == ""{
                    cell.detailTextLabel?.text = "¡Ready to generate!"
                    cell.detailTextLabel?.textColor = UIColor.blue
                    cell.imageView!.image = UIImage(named: "qr_blue")
                }
                else{
                    cell.detailTextLabel?.text = "You must complete all information"
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.imageView!.image = UIImage(named: "qr")
                }
            default: break
            }
        }
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
        case 4:
            performSegue(withIdentifier: "qrcodeSegue", sender: self)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let query = dbc.validaForm250(indice)
        if lang == "es-419"{
            let alert = gen.alert("Verifica", query[indexPath.row], "Aceptar")
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let alert = gen.alert("Verify", query[indexPath.row], "OK")
            self.present(alert, animated: true, completion: nil)
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
        case "qrcodeSegue":
            let destination = segue.destination as? QRCodeViewController
            destination!.indice = indice
        default:
            break
        }
    }

}
