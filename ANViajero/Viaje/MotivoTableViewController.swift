//
//  MotivoTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 5/5/21.
//

import UIKit

class MotivoTableViewController: UITableViewController {

    var indice: Int64 = 0
    var seleccionado: String = ""
    var motivoTemp: String = ""
    var dbc: dbController = dbController()
    var valid: validacionController = validacionController()
    let lang = Bundle.main.preferredLocalizations.first
    let motEs = ["T*@*Turismo", "R*@*Retorno", "S*@*Salud", "N*@*Negocio", "O*@*Otros"]
    let motEn = ["T*@*Turism", "R*@*Return", "S*@*Health", "N*@*Business", "O*@*Others"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "es-419"{
            navigationItem.title = "Motivo del viaje"
        }
        else{
            navigationItem.title = "Reason for trip"
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motEs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if lang == "es-419"{
            let split = motEs[indexPath.row].components(separatedBy: "*@*")
            cell.textLabel?.text = split[1]
            if seleccionado == split[0]{
                cell.accessoryType = .checkmark
            }
        }
        else{
            let split = motEn[indexPath.row].components(separatedBy: "*@*")
            cell.textLabel?.text = split[1]
            if seleccionado == split[0]{
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let split = motEs[indexPath.row].components(separatedBy: "*@*")
            if split[0] == "O"{
                if lang == "es-419"{
                    let alert = UIAlertController(title: "Viaje", message: "Describa el motivo de su viaje", preferredStyle: .alert)
                    alert.addTextField{ (textField) in
                        textField.placeholder = "Ejemplo: Visita, trabajo"
                        textField.text = self.motivoTemp
                    }
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { [weak alert] (_) in
                        let textField = alert?.textFields?[0]
                        if(!(textField?.text?.isEmpty)! && (textField?.text?.count)! > 2 && (textField?.text?.count)! < 21){
                            if self.valid.esAlfabetico(testStr: (textField?.text?.uppercased())!) {
                                self.dbc.setCampo("motivo", self.indice, "O")
                                self.dbc.setCampo("motivootro", self.indice, (textField?.text?.uppercased())!)
                                cell.accessoryType = .checkmark
                                self.dismiss(animated: true, completion: nil)
                            }
                            else {
                                self.motivoTemp = (textField?.text)!
                                self.view.makeToast("Debe ingresar solamente caracteres alfabéticos", duration: 3.5, position: .center)
                            }
                        }
                        else{
                            self.motivoTemp = (textField?.text)!
                            self.view.makeToast("Debe describir el motivo de su viaje (entre 3 y 20 caracteres)", duration: 3.5, position: .center)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Travel", message: "Describe the reason of your trip", preferredStyle: .alert)
                    alert.addTextField{ (textField) in
                        textField.placeholder = "Example: Visiting, work"
                        textField.text = self.motivoTemp
                    }
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        let textField = alert?.textFields?[0]
                        if(!(textField?.text?.isEmpty)! && (textField?.text?.count)! > 2 && (textField?.text?.count)! < 21){
                            if self.valid.esAlfabetico(testStr: (textField?.text?.uppercased())!) {
                                self.dbc.setCampo("motivo", self.indice, "O")
                                self.dbc.setCampo("motivootro", self.indice, (textField?.text?.uppercased())!)
                                cell.accessoryType = .checkmark
                                self.dismiss(animated: true, completion: nil)
                            }
                            else{
                                self.motivoTemp = (textField?.text)!
                                self.view.makeToast("You must type only alphabetic characters", duration: 3.5, position: .center)
                            }
                        }
                        else{
                            self.motivoTemp = (textField?.text)!
                            self.view.makeToast("You must describe the reason of your trip (between 3 and 20 characters)", duration: 3.5, position: .center)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                dbc.setCampo("motivo", indice, split[0])
                dbc.setCampo("motivootro", indice, "")
                cell.accessoryType = .checkmark
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
