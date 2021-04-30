//
//  DeclaracionTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 28/4/21.
//

import UIKit

class DeclaracionTableViewController: UITableViewController {

    var listadec: [String] = [String]()
    var dbc: dbController = dbController();
    let gen: AlertController = AlertController()
    let lang = Bundle.main.preferredLocalizations.first
    var version:Int = 0
    var versionActual:Int = 2
    var indice: Int64 = 0
    
    @IBAction func addButton(_ sender: Any) {
        let fechaHoy = getFecha()
        let nombre = getNombre()
        let res = dbc.setCabecera(nombre, "", fechaHoy)
        if (res > 0){
            indice = res
            performSegue(withIdentifier: "newSegue", sender: self)
        }
        else{
            let alerta = gen.alert("Error", "Ocurrió un error, intentelo nuevamente", "Aceptar")
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbc.checkDB("divisas.sqlite")
        version = dbc.getVersionDB()
        print("Version \(version)")
        while version<versionActual{
            switch version{
                case 0:
                    self.view.makeToast("Ha ocurrido un error con la Base de Datos", duration: 3.5, position: ToastPosition.center)
                case 1:
                    let re:Bool = dbc.dbVersion2()
                    if re == true{
                        version = version + 1
                        print("Base de datos actualizada!")
                    }
                    else{
                        self.view.makeToast("Ha ocurrido un error al actualizar la Base de Datos", duration: 3.5, position: ToastPosition.center)
                    }
                default:
                    print("Default version DB")
            }
            version = dbc.getVersionDB()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listadec = dbc.getDeclaraciones() as! [String]
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listadec.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let splitDeclaracion = listadec[indexPath.row].components(separatedBy: "*@*")
        cell.textLabel?.text = splitDeclaracion[1]
        var tipodec: String = ""
        if splitDeclaracion[3] == "I"{
            if lang == "es-419"{
                tipodec = "Ingreso a Bolivia (250)"
            } else{
                tipodec = "Entry to Bolivia (250)"
            }
        }
        else{
            if lang == "es-419"{
                tipodec = "Salida de Bolivia (251)"
            } else{
                tipodec = "Departure from Bolivia (251)"
            }
            
        }
        
        cell.detailTextLabel?.text = splitDeclaracion[2] + "     Form: " + tipodec
        cell.detailTextLabel?.textColor = UIColor(red: 104.0/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1.0)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let splitDeclaracion = listadec[indexPath.row].components(separatedBy: "*@*")
        indice = Int64(splitDeclaracion[0])!
        performSegue(withIdentifier: "swornSegue", sender: self)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if lang == "es-419"{
            return "Eliminar"
        }
        else{
            return "Delete"
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let splitDeclaracion = listadec[indexPath.row].components(separatedBy: "*@*")
            let listaId = splitDeclaracion[0]
            if dbc.borraRegistro(listaId){
                if lang == "es-419"{
                    self.view.makeToast("Declaración Juarada eliminada.", duration: 3.5, position: ToastPosition.center)
                }
                else{
                    self.view.makeToast("Affidavit removed.", duration: 3.5, position: ToastPosition.center)
                }
                //self.view.makeToast("Declaración Juarada eliminada.", duration: 3.5, position: ToastPosition.center)
                viewDidAppear(true)
            }
            else{
                self.view.makeToast("No se pudo completar la operación solicitada.", duration: 3.5, position: ToastPosition.center)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newSegue" {
            if let destination = segue.destination as? DetalleTableViewController {
                destination.indice = indice
            }
        }
        
        if segue.identifier == "swornSegue" {
            let destination = segue.destination as! DetalleTableViewController
            destination.indice = indice
        }
    }

    func getFecha() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    func getNombre() -> String{
        var nombre: String = ""
        var copia = 1
        _ = Bundle.main.preferredLocalizations.first
        let date = Date()
        let monthString = date.getMonthName()
        nombre = monthString
        //if (lang == "es-419"){
            //let meses [String] : {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto"}
        //}
        while (dbc.hayNombre(nombre.capitalized)){
            nombre = monthString + "-" + String(copia)
            copia += 1
        }
        return nombre.capitalized
    }
    
}

extension Date {
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
}
