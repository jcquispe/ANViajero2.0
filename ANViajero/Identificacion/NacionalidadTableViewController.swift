//
//  NacionalidadTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 3/5/21.
//

import UIKit

class NacionalidadTableViewController: UITableViewController {

    var indice: Int64 = 0
    var seleccionado: String = ""
    let nacEs = ["B*@*Boliviano(a)", "E*@*Extranjero(a)"]
    let nacEn = ["B*@*Bolivian", "E*@*Foreign"]
    var dbc: dbController = dbController()
    let lang = Bundle.main.preferredLocalizations.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "es-419"{
            navigationItem.title = "Nacionalidad"
        }
        else{
            navigationItem.title = "Nationality"
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nacEs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if lang == "es-419"{
            let split = nacEs[indexPath.row].components(separatedBy: "*@*")
            cell.textLabel?.text = split[1]
            if seleccionado == split[0]{
                cell.accessoryType = .checkmark
            }
        }
        else{
            let split = nacEn[indexPath.row].components(separatedBy: "*@*")
            cell.textLabel?.text = split[1]
            if seleccionado == split[0]{
                cell.accessoryType = .checkmark
            }

        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            let split = nacEs[indexPath.row].components(separatedBy: "*@*")
            if split[0] == "E" {
                performSegue(withIdentifier: "foreignSegue", sender: self)
            }
            else {
                dbc.setCampo("nacionalidad", indice, split[0])
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "foreignSegue" {
            let destination = segue.destination as! ExtranjeroViewController
            destination.indice = indice
        }
    }

}
