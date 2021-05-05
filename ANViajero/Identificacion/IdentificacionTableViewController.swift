//
//  IdentificacionTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 30/4/21.
//

import UIKit

class IdentificacionTableViewController: UITableViewController {

    var indice: Int64 = 0
    var sexSel: String = ""
    var docSel: String = ""
    var nacSel: String = ""
    var fecSel: String = ""
    var dbc: dbController = dbController()
    var valid: validacionController = validacionController()
    let lang = Bundle.main.preferredLocalizations.first
    
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var apellidoText: UITextField!
    @IBOutlet weak var numerodocText: UITextField!
    @IBOutlet weak var ocupacionText: UITextField!
    
    @IBOutlet weak var sexoLabel: UILabel!
    @IBOutlet weak var documentoLabel: UILabel!
    @IBOutlet weak var nacionalidadLabel: UILabel!
    
    @IBOutlet weak var nacimientoDatePicker: UIDatePicker!
    
    @IBAction func nacimientoAction(_ sender: UIDatePicker) {
        let seleccionado = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = seleccionado.day, let month = seleccionado.month, let year = seleccionado.year {
            fecSel = String(day) + "/" + String(month) + "/" + String(year)
            print(fecSel)
            dbc.setCampo("fechanacimiento", indice, fecSel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -120
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        nacimientoDatePicker.minimumDate = minDate
        nacimientoDatePicker.maximumDate = maxDate
        
        nombreText.delegate = self
        apellidoText.delegate = self
        numerodocText.delegate = self
        ocupacionText.delegate = self
        
        nombreText.addTarget(self, action: #selector(textNombre(_:)), for: .editingChanged)
        apellidoText.addTarget(self, action: #selector(textApellido(_:)), for: .editingChanged)
        numerodocText.addTarget(self, action: #selector(textNumerodoc(_:)), for: .editingChanged)
        ocupacionText.addTarget(self, action: #selector(textOcupacion(_:)), for: .editingChanged)
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let query = dbc.getSelect("identificacion", indice)
        nombreText.text = query[0]
        apellidoText.text = query[1]
        numerodocText.text = query[5]
        ocupacionText.text = query[7]
        
        if !query[8].isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date = formatter.date(from: query[8])
            nacimientoDatePicker.setDate(date!, animated: true)
        }
        
        if(query[2].isEmpty){
            if lang == "es-419"{
                sexoLabel.text = "Seleccione"
            }
            else{
                sexoLabel.text = "Select"
            }
            sexSel = ""
        }else{
            if lang == "es-419"{
                switch query[2]{
                    case "M": sexoLabel.text = "Masculino"
                    case "F": sexoLabel.text = "Femenino"
                default: break
                }
            }
            else{
                switch query[2]{
                case "M": sexoLabel.text = "Male"
                case "F": sexoLabel.text = "Female"
                default: break
                }
            }
            sexSel = query[2]
        }
        
        if(query[3].isEmpty){
            if lang == "es-419"{
                documentoLabel.text = "Seleccione"
            }
            else{
                documentoLabel.text = "Select"
            }
            docSel = ""
        }else{
            if lang == "es-419"{
                switch query[3]{
                    case "CI": documentoLabel.text = "CI"
                    case "PAS": documentoLabel.text = "Pasaporte"
                    case "OTRO": documentoLabel.text = query[4]
                default: break
                }
            }
            else{
                switch query[3]{
                    case "CI": documentoLabel.text = "CI"
                    case "PAS": documentoLabel.text = "Passport"
                    case "OTRO": documentoLabel.text = query[4]
                default: break
                }
            }
            docSel = query[3]
        }
        
        if(query[6].isEmpty){
            if lang == "es-419"{
                nacionalidadLabel.text = "Seleccione"
            }
            else{
                nacionalidadLabel.text = "Select"
            }

            nacSel = ""
        }else{
            if lang == "es-419"{
                switch query[6]{
                case "B": nacionalidadLabel.text = "Boliviano"
                default: nacionalidadLabel.text = dbc.getPais("descripcion", query[6])
                }
            }
            else{
                switch query[6]{
                case "B": nacionalidadLabel.text = "Bolivian"
                default: nacionalidadLabel.text = dbc.getPais("descripcion_en", query[6])
                }
            }
            nacSel = query[6]
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            performSegue(withIdentifier: "sexSegue", sender: self)
        case 3:
            performSegue(withIdentifier: "iddocumentSegue", sender: self)
        case 6:
            performSegue(withIdentifier: "nationalitySegue", sender: self)
        default:
            break
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "sexSegue":
            let destination = segue.destination as! SexoTableViewController
            destination.indice = indice
        case "iddocumentSegue":
            let destination = segue.destination as! DocumentoTableViewController
            destination.indice = indice
        case "nationalitySegue":
            let destination = segue.destination as! NacionalidadTableViewController
            destination.indice = indice
        default:
            break
        }
    }
}

extension IdentificacionTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func textNombre(_ textField: UITextField) {
        if valid.esAlfabetico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("nombre", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            nombreText.text = textField.text
        }
    }
    
    @objc func textApellido(_ textField: UITextField) {
        if valid.esAlfabetico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("apellido", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            apellidoText.text = textField.text
        }
    }
    
    @objc func textNumerodoc(_ textField: UITextField) {
        if valid.esDocumento(testStr: textField.text!.uppercased()) {
            dbc.setCampo("numdoc", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            numerodocText.text = textField.text
        }
    }
    
    @objc func textOcupacion(_ textField: UITextField) {
        if valid.esAlfabetico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("ocupacion", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            ocupacionText.text = textField.text
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField{
        case nombreText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 25
        case apellidoText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 25
        case numerodocText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 20
        case ocupacionText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 25
        default:
            return false
        }
    }
}
