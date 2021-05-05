//
//  SexoTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 3/5/21.
//

import UIKit

class SexoTableViewController: UITableViewController {

    var indice: Int64 = 0
    let sexEs = ["M*@*Masculino", "F*@*Femenino"]
    let sexEn = ["M*@*Male", "F*@*Female"]
    var seleccionado: String = ""
    var dbc: dbController = dbController()
    let lang = Bundle.main.preferredLocalizations.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "es-419"{
            navigationItem.title = "Sexo"
        }
        else{
            navigationItem.title = "Sex"
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sexEs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if lang == "es-419"{
            let split = sexEs[indexPath.row].components(separatedBy: "*@*")
            cell.textLabel?.text = split[1]
            if seleccionado == split[0]{
                cell.accessoryType = .checkmark
            }
        }
        else{
            let split = sexEn[indexPath.row].components(separatedBy: "*@*")
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
            let split = sexEs[indexPath.row].components(separatedBy: "*@*")
            dbc.setCampo("sexo", indice, split[0])
        }
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
