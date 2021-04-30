//
//  ViajeTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 30/4/21.
//

import UIKit

class ViajeTableViewController: UITableViewController {

    var indice: Int64 = 0
    let dbc: dbController = dbController()
    let lang = Bundle.main.preferredLocalizations.first
    var paiSel: String = ""
    
    @IBOutlet weak var entrySwitch: UISwitch!
    @IBOutlet weak var departureSwitch: UISwitch!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBAction func entryAction(_ sender: UISwitch) {
        if entrySwitch.isOn {
            departureSwitch.isOn = false
            dbc.setCampo("tipo", indice, "I")
        }
    }
    
    @IBAction func departureAction(_ sender: UISwitch) {
        if departureSwitch.isOn {
            entrySwitch.isOn = false
            dbc.setCampo("tipo", indice, "S")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        let query = dbc.getSelect("ingresosalida", indice)
        if query[0].isEmpty {
            entrySwitch.isOn = false
            departureSwitch.isOn = false
        }
        else {
            if query[0] == "I" {
                entrySwitch.isOn = true
            }
            if query[0] == "S" {
                departureSwitch.isOn = true
            }
        }
        
        if query[1].isEmpty {
            if lang == "es-419"{
                countryLabel.text = "Seleccione"
            }
            else{
                countryLabel.text = "Select"
            }
            paiSel = ""
        }
        else{
            if lang == "es-419"{
                countryLabel.text = dbc.getPais("descripcion", query[1])
            }
            else{
                countryLabel.text = dbc.getPais("descripcion_en", query[1])
            }
            paiSel = query[1]
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            performSegue(withIdentifier: "countrySegue", sender: self)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countrySegue" {
            let destination = segue.destination as! PaisViewController
            destination.indice = indice
        }
    }

}
