//
//  DocumentoTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 3/5/21.
//

import UIKit

class DocumentoTableViewController: UITableViewController {

    var indice: Int64 = 0
    var seleccionado: String = ""
    var docTemp: String = ""
    let docEs = ["PAS*@*Pasaporte", "CI*@*CI", "OTRO*@*Otro"]
    let docEn = ["PAS*@*Passport", "CI*@*CI", "OTRO*@*Other"]
    var dbc: dbController = dbController()
    var valid: validacionController = validacionController()
    let lang = Bundle.main.preferredLocalizations.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docEs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if lang == "es-419"{
            let split = docEs[indexPath.row].components(separatedBy: "*@*")
            cell.textLabel?.text = split[1]
            if seleccionado == split[0]{
                cell.accessoryType = .checkmark
            }
        }
        else{
            let split = docEn[indexPath.row].components(separatedBy: "*@*")
            cell.textLabel?.text = split[1]
            if seleccionado == split[0]{
                cell.accessoryType = .checkmark
            }

        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
           
            let split = docEs[indexPath.row].components(separatedBy: "*@*")
            if split[0] == "OTRO"{
                if lang == "es-419"{
                    let alert = UIAlertController(title: "Identificación", message: "Describa su documento de identificación", preferredStyle: .alert)
                    alert.addTextField{ (textField) in
                        textField.placeholder = "Ejemplo: DNI"
                        textField.text = self.docTemp
                    }
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { [weak alert] (_) in
                        let textField = alert?.textFields?[0]
                        if(!(textField?.text?.isEmpty)! && (textField?.text?.count)! > 2 && (textField?.text?.count)! < 21){
                            if self.valid.esAlfabetico(testStr: (textField?.text?.uppercased())!) {
                                self.dbc.setCampo("tipodoc", self.indice, "OTRO")
                                self.dbc.setCampo("otrodoc", self.indice, (textField?.text?.uppercased())!)
                                cell.accessoryType = .checkmark
                                self.dismiss(animated: true, completion: nil)
                            }
                            self.docTemp = (textField?.text)!
                            self.view.makeToast("Debe ingresar solamente caracteres alfabéticos", duration: 3.5, position: .center)
                        }
                        else{
                            self.docTemp = (textField?.text)!
                            self.view.makeToast("Debe describir el tipo de documento que posee (entre 3 y 20 caracteres)", duration: 3.5, position: .center)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Identification", message: "Describe your identification document", preferredStyle: .alert)
                    alert.addTextField{ (textField) in
                        textField.placeholder = "Example: DNI"
                        textField.text = self.docTemp
                    }
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        let textField = alert?.textFields?[0]
                        if(!(textField?.text?.isEmpty)! && (textField?.text?.count)! > 2 && (textField?.text?.count)! < 21){
                            if self.valid.esAlfabetico(testStr: (textField?.text?.uppercased())!) {
                                self.dbc.setCampo("tipodoc", self.indice, "OTRO")
                                self.dbc.setCampo("otrodoc", self.indice, (textField?.text?.uppercased())!)
                                cell.accessoryType = .checkmark
                                self.dismiss(animated: true, completion: nil)
                            }
                            self.docTemp = (textField?.text)!
                            self.view.makeToast("You must type only alphabetic characters", duration: 3.5, position: .center)
                        }
                        else{
                            self.docTemp = (textField?.text)!
                            self.view.makeToast("You must describe the kind of ID documentation you own (between 3 and 20 characters)", duration: 3.5, position: .center)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                dbc.setCampo("tipodoc", indice, split[0])
                dbc.setCampo("otrodoc", indice, "")
                cell.accessoryType = .checkmark
            }
            self.navigationController?.popViewController(animated: true)
        }
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
