//
//  dbController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 28/4/21.
//

import UIKit
import SQLite

class dbController: UIViewController {

    let path = Bundle.main.path(forResource: "divisas", ofType: ".sqlite")
    var db : Connection?
    let lang = Bundle.main.preferredLocalizations.first
    
    //Tablas
    let formulario = Table("formulario")
    let paises = Table("p_paises")
    let sistema = Table("sistema")
    
    //Campos
    let id = Expression<String>("id")
    let descripcion = Expression<String>("descripcion")
    let descripcion_en = Expression<String>("descripcion_en")
    let idform = Expression<Int64>("id_form")
    let declaracion = Expression<String>("declaracion")
    let fechaform = Expression<String>("fecha")
    let tipoform = Expression<String>("tipo")
    let nombre = Expression<String>("nombres")
    let apellido = Expression<String>("apellidos")
    let sexo = Expression<String>("sexo")
    let tipodoc = Expression<String>("tipo_doc")
    let tipootro = Expression<String>("tipo_otro")
    let numdoc = Expression<String>("num_doc")
    let nacionalidad = Expression<String>("nacionalidad")
    let pais = Expression<String>("pais_origen_dest")
    let equipajemen = Expression<String>("equipaje_menores")
    let nummiembros = Expression<Int64>("num_miembros")
    let aeropuerto = Expression<String>("frontera_aeropuerto")
    let mediotransporte = Expression<String>("medio_transporte")
    let motivoviaje = Expression<String>("motivo_viaje")
    let motivootros = Expression<String>("motivo_otros")
    let transportadora = Expression<String>("transportadora")
    let numviaje = Expression<String>("num_viaje")
    let numequipaje = Expression<String>("num_equipaje")
    let articulosno = Expression<String>("articulos_no_comp")
    let mayor = Expression<String>("mayor_10000")
    let montousd = Expression<String>("monto_usd")
    let importe1 = Expression<String>("divisa_importe1")
    let moneda1 = Expression<String>("divisa_moneda1")
    let importe2 = Expression<String>("divisa_importe2")
    let moneda2 = Expression<String>("divisa_moneda2")
    let fechasalent = Expression<String>("fecha_sal_ent")
    let numtramite = Expression<String>("num_tramite")
    let app = Expression<String>("app")
    let version = Expression<String>("version")
    let base = Expression<String>("base")
    let inicio = Expression<String>("inicio")
    let auxiliar = Expression<String>("auxiliar")
    //
    let origen = Expression<String>("origen")
    //
    let ocupacion = Expression<String>("ocupacion")
    let fechanacimiento = Expression<String>("fecha_nacimiento")
    let destino = Expression<String>("destino")
    
    func checkDB(_ database: String){
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent(database)
        if fileManager.fileExists(atPath: fullDestPath.path){
            print("Base de datos existente")
            print(fileManager.fileExists(atPath: path!))
        }else{
            do{
                try fileManager.copyItem(atPath: path!, toPath: fullDestPath.path)
            }catch{
                print("Error 6000: ",error)
            }
        }
    }
    
    func connect() ->Bool{
        //Conexion con la Base de Datos
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            self.db = try Connection("\(path)/divisas.sqlite")
            return true
        } catch {
            print("Error 6001: \(error)")
            return false
        }
    }
    
    func getNewId(_ parametro: String) -> Int64{
        var idNuevo: Int64 = 0
        do{
            switch parametro{
            case "formulario":
                let max = try db?.scalar(formulario.select(idform.max))
                if(max != nil){
                    idNuevo = Int64(max!) + 1
                }else{
                    idNuevo = 1
                }
            default:
                idNuevo = 0
            }
            
        }catch{
            print("Error 6002: \(error)")
        }
        return idNuevo
    }

    func setCabecera(_ nombre: String, _ tipo: String, _ fecha: String) -> Int64{
        var res: Int64 = 0
        if(connect()){
            do{
                res = try db!.run(formulario.insert(idform <- getNewId("formulario"), declaracion <- nombre, tipoform <- tipo, fechaform <- fecha))
            }catch{
                print("Error 6003: \(error)")
            }
        }
        return res
    }
    
    func hayNombre(_ nombre: String) -> Bool{
        var cantidad = 0
        if(connect()){
            do{
                let nombres = formulario.filter(declaracion == nombre)
                cantidad = try db!.scalar(nombres.count)
            }catch{
                print("Error 6004: \(error)")
            }
        }
        if (cantidad > 0){
            return true
        } else{
            return false
        }
    }
    
    func getDeclaraciones() -> Array<Any>{
        var arrayDeclaraciones: [String] = [String]()
        if(connect()){
            do{
                for form in try db!.prepare(formulario) {
                    arrayDeclaraciones.append(String(form[idform])+"*@*"+form[declaracion]+"*@*"+form[fechaform]+"*@*"+form[tipoform])
                }
                /*all = Array(try db!.prepare(declaraciones))
                 print(all)*/
            }catch{
                print("Error 6005: \(error)")
            }
            
        }
        return arrayDeclaraciones
    }
    
    func getDescripcion(_ parametro: String, _ ide: Int64) -> String{
        var resultado: String = ""
        if(connect()){
            do{
                switch parametro{
                case "titulo":
                    let form = formulario.select(declaracion).filter(idform == Int64(ide))
                    for res in try db!.prepare(form){
                        resultado = res[declaracion]
                    }
                default:
                    print("Default getDescripcion")
                }
            }catch{
                print("Error 6006: \(error)")
            }
        }
        return resultado
    }
    
    func setCampo(_ parametro: String, _ idi: Int64, _ valor: String){
        let val: String = valor.trimmingCharacters(in: .whitespacesAndNewlines)
        if(connect()){
            do{
                switch parametro{
                case "sexo":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(sexo <- val))
                case "nombre":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(nombre <- val))
                case "numdoc":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(numdoc <- val))
                case "apellido":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(apellido <- val))
                case "transportadora":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(transportadora <- val))
                case "vuelo":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(numviaje <- val))
                case "tipodoc":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(tipodoc <- val))
                case "otrodoc":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(tipootro <- val))
                case "nacionalidad":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(nacionalidad <- val))
                case "motivo":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(motivoviaje <- val))
                case "motivootro":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(motivootros <- val))
                case "pais":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(pais <- val))
                case "equipaje":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(numequipaje <- val))
                case "equipajeMenores":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(equipajemen <- val))
                case "articulosNo":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(articulosno <- val))
                case "mayor":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(mayor <- val))
                case "montousd":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(montousd <- val))
                case "moneda1":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(moneda1 <- val))
                case "importe1":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(importe1 <- val))
                case "moneda2":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(moneda2 <- val))
                case "importe2":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(importe2 <- val))
                case "origen":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(origen <- val))
                case "tipo":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(tipoform <- val))
                case "ocupacion":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(ocupacion <- val))
                case "fechanacimiento":
                    let form = formulario.filter(idform ==  Int64(idi))
                    try db!.run(form.update(fechanacimiento <- val))
                case "destino":
                    let form = formulario.filter(idform == Int64(idi))
                    try db!.run(form.update(destino <- val))
                default:
                    print("Default setCampo")
                }
            }catch{
                print("Error 6007: \(error)")
            }
        }
    }
    
    func getSelect(_ parametro: String, _ idi: Int64) -> Array<String>{
        var lista: [String] = [String]()
        if(connect()){
            do{
                switch parametro{
                case "identificacion":
                    let form = formulario.select(nombre, apellido, sexo, tipodoc, tipootro, numdoc, nacionalidad, ocupacion, fechanacimiento).filter(idform == Int64(idi))
                    for res in try db!.prepare(form){
                        lista.append(res[nombre])
                        lista.append(res[apellido])
                        lista.append(res[sexo])
                        lista.append(res[tipodoc])
                        lista.append(res[tipootro])
                        lista.append(res[numdoc])
                        lista.append(res[nacionalidad])
                        lista.append(res[ocupacion])
                        lista.append(res[fechanacimiento])
                    }
                case "paises":
                    let paisesAsc = paises.select(descripcion).order(descripcion.asc)
                    for pais in try db!.prepare(paisesAsc) {
                        lista.append(pais[descripcion])
                    }
                case "paises_en":
                    let paisesEnAsc = paises.select(descripcion_en).order(descripcion_en.asc)
                    for pais in try db!.prepare(paisesEnAsc) {
                        lista.append(pais[descripcion_en])
                    }
                case "viaje":
                    let form = formulario.select(pais, motivoviaje, motivootros, transportadora, numviaje).filter(idform == Int64(idi))
                    for res in try db!.prepare(form){
                        lista.append(res[pais])
                        lista.append(res[motivoviaje])
                        lista.append(res[motivootros])
                        lista.append(res[transportadora])
                        lista.append(res[numviaje])
                    }
                case "equipaje":
                    let form = formulario.select(numequipaje, equipajemen, articulosno).filter(idform == Int64(idi))
                    for res in try db!.prepare(form){
                        lista.append(String(res[numequipaje]))
                        lista.append(res[equipajemen])
                        lista.append(res[articulosno])
                    }
                case "divisas":
                    let form = formulario.select(mayor, montousd, importe1, moneda1, importe2, moneda2, origen, destino).filter(idform == Int64(idi))
                    for res in try db!.prepare(form){
                        lista.append(res[mayor])
                        lista.append(res[montousd])
                        lista.append(res[importe1])
                        lista.append(res[moneda1])
                        lista.append(res[importe2])
                        lista.append(res[moneda2])
                        lista.append(res[origen])
                        lista.append(res[destino])
                    }
                case "ddjj":
                    
                    let form = formulario.filter(idform == Int64(idi))
                    for res in try db!.prepare(form){
                        lista.append(res[tipoform])
                        lista.append(res[pais])
                        lista.append(res[nombre])
                        lista.append(res[apellido])
                        lista.append(res[sexo])
                        if res[tipodoc] == "OTRO" {
                            lista.append(res[tipootro])
                        } else{
                            lista.append(res[tipodoc])
                        }
                        lista.append(res[numdoc])
                        lista.append(res[ocupacion])
                        lista.append(res[nacionalidad])
                        lista.append(res[fechanacimiento])
                        lista.append("*FRONTERA*")
                        lista.append(res[transportadora])
                        lista.append(res[numviaje])
                        lista.append(res[motivoviaje])
                        lista.append(res[motivootros])
                        lista.append(res[articulosno])
                        lista.append(String(res[numequipaje]))
                        lista.append(res[mayor])
                        lista.append(res[montousd])
                        lista.append(res[importe1])
                        lista.append(res[moneda1])
                        lista.append(res[importe2])
                        lista.append(res[moneda2])
                        lista.append(res[origen])
                        lista.append(res[destino])
                    }
                case "ingresosalida":
                    let form = formulario.select(tipoform, pais, transportadora, numviaje, motivoviaje, motivootros).filter(idform == Int64(idi))
                    for res in try db!.prepare(form) {
                        lista.append(res[tipoform])
                        lista.append(res[pais])
                        lista.append(res[transportadora])
                        lista.append(res[numviaje])
                        lista.append(res[motivoviaje])
                        lista.append(res[motivootros])
                    }
                default:
                    print("Default getSelect")
                }
            }catch{
                print("Error 6008: \(error)")
            }
        }
        return lista
    }
    
    func getPais(_ parametro: String, _ ide: String) -> String{
        var resultado: String = ""
        if(connect()){
            do{
                switch parametro{
                case "pais":
                    let form = paises.select(id).filter(descripcion == ide)
                    for res in try db!.prepare(form){
                        resultado = res[id]
                    }
                case "pais_en":
                    let form = paises.select(id).filter(descripcion_en == ide)
                    for res in try db!.prepare(form){
                        resultado = res[id]
                    }
                case "descripcion":
                    let form = paises.select(descripcion).filter(id == ide)
                    for res in try db!.prepare(form){
                        resultado = res[descripcion]
                    }
                case "descripcion_en":
                    let form = paises.select(descripcion_en).filter(id == ide)
                    for res in try db!.prepare(form){
                        resultado = res[descripcion_en]
                    }
                default:
                    print("Default getDescripcion")
                }
            }catch{
                print("Error 6009: \(error)")
            }
        }
        return resultado
    }
    
    func validaForm250(_ ide: Int64) -> Array<String>{
        var lista: [String] = [String]()
        var mensaje: String = ""
        var errores = 0
        
        if connect(){
            do{
                let form = formulario.select(tipoform, pais, nombre, apellido, sexo, tipodoc, tipootro, numdoc, ocupacion, nacionalidad, fechanacimiento, transportadora, numviaje, motivoviaje, motivootros, articulosno, numequipaje, mayor, montousd, importe1, moneda1, importe2, moneda2, origen, destino).filter(idform == Int64(ide))
                for res in try db!.prepare(form){
                    mensaje = ""
                    if res[tipoform] == "" {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Ingreso/Salida\n"
                        } else{
                            mensaje = mensaje + "- Entry/Departure\n"
                        }
                    }
                    if res[pais] == "" {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Pais de procedencia/destino\n"
                        } else{
                            mensaje = mensaje + "- Country of provenance/destination\n"
                        }
                    }
                    if res[transportadora].count < 2 {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Empresa de transporte\n"
                        } else{
                            mensaje = mensaje + "- Transportation company\n"
                        }
                    }
                    if res[numviaje].count < 3{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Número de vuelo o placa\n"
                        } else{
                            mensaje = mensaje + "- Flight or plate number\n"
                        }
                    }
                    if res[motivoviaje]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Motivo del viaje\n"
                        } else{
                            mensaje = mensaje + "- Reason for trip\n"
                        }
                    } else if res[motivoviaje] == "O" && res[motivootros] == ""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Otro motivo del viaje\n"
                        } else{
                            mensaje = mensaje + "- Another reason of your trip\n"
                        }
                    }
                    lista.append(mensaje)
                    if mensaje != "" {
                        errores = errores + 1
                    }
                    
                    mensaje = ""
                    if res[nombre].count < 3 {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Nombre(s)\n"
                        } else{
                            mensaje = mensaje + "- Name(s)\n"
                        }
                    }
                    if res[apellido].count < 3 {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Apellido(s)\n"
                        } else{
                            mensaje = mensaje + "- Surname(s)\n"
                        }
                    }
                    if res[sexo]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Sexo\n"
                        } else{
                            mensaje = mensaje + "- Sex\n"
                        }
                    }
                    if res[tipodoc]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Tipo de documento de identificación\n"
                        } else{
                            mensaje = mensaje + "- ID Document type\n"
                        }
                    } else if res[tipodoc] == "OTRO" && res[tipootro] == ""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Otro tipo de documento de identificación\n"
                        } else{
                            mensaje = mensaje + "- Another ID Document type\n"
                        }
                    }
                    if res[numdoc].count < 5 {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Número de identificación\n"
                        } else{
                            mensaje = mensaje + "- ID Number\n"
                        }
                    }
                    if res[ocupacion].count < 3 {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Ocupación\n"
                        } else{
                            mensaje = mensaje + "- Ocupation\n"
                        }
                    }
                    if res[nacionalidad]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Nacionalidad\n"
                        } else{
                            mensaje = mensaje + "- Nationality\n"
                        }
                    }
                    if res[fechanacimiento].count < 3 {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Fecha de nacimiento\n"
                        } else{
                            mensaje = mensaje + "- Birth date\n"
                        }
                    }
                    lista.append(mensaje)
                    if mensaje != "" {
                        errores = errores + 1
                    }
                    
                    mensaje = ""
                    if res[articulosno]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- ¿Artículos sujetos al pago de tributos aduaneros?\n"
                        } else{
                            mensaje = mensaje + "- Articles subject to custom taxes payment?\n"
                        }
                    }
                    if res[numequipaje]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Cantidad de equipaje\n"
                        } else{
                            mensaje = mensaje + "- Quantity of baggage\n"
                        }
                    }
                    lista.append(mensaje)
                    if mensaje != "" {
                        errores = errores + 1
                    }
                    
                    mensaje = ""
                    if res[mayor]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- ¿Efectivo entre 10.000 a 20.000 USD?\n"
                        } else{
                            mensaje = mensaje + "- Cash between USD 10.000 and 20.000?\n"
                        }
                    } else if res[mayor] == "S" {
                        if res[montousd] == ""{
                            if res[importe1] == "" && res[importe2] == "" {
                                if lang == "es-419"{
                                    mensaje = mensaje + "- Monto USD u otra moneda\n"
                                } else{
                                    mensaje = mensaje + "- USD or other currency amount\n"
                                }
                            }
                        }
                        else {
                            if Int(res[montousd])! < 10000 && res[moneda1].count == 0 && res[moneda2].count == 0{
                                if lang == "es-419"{
                                    mensaje = mensaje + "- Monto USD u otra moneda\n"
                                } else{
                                    mensaje = mensaje + "- USD or other currency amount\n"
                                }
                            }
                        }
                        if res[origen].count < 3{
                            if lang == "es-419"{
                                mensaje = mensaje + "- Origen de las divisas\n"
                            } else{
                                mensaje = mensaje + "- Currency origin\n"
                            }
                        }
                        if res[destino].count < 3{
                            if lang == "es-419"{
                                mensaje = mensaje + "- Destino de las divisas\n"
                            } else{
                                mensaje = mensaje + "- Currency destination\n"
                            }
                        }
                    }
                    if res[importe1] != "" && res[moneda1].count < 3{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Moneda para importe 1\n"
                        } else{
                            mensaje = mensaje + "- Currency for amount 1\n"
                        }
                    }
                    if res[importe2] != "" && res[moneda2].count < 3{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Moneda para importe 2\n"
                        } else{
                            mensaje = mensaje + "- Currency for amount 2\n"
                        }
                    }
                    lista.append(mensaje)
                    if mensaje != "" {
                        errores = errores + 1
                    }
                    
                    mensaje = ""
                    if errores > 0 {
                        if lang == "es-419"{
                            mensaje = "Para generar el código debe llenar correctamente todo el formulario"
                        }
                        else{
                            mensaje = "In order to generate the code you have to fill correctly the entire form"
                        }
                    }
                    lista.append(mensaje)
                }
            }catch{
                print("Error 6010: \(error)")
            }
        }
        return lista
    }
    
    func validaForm251(_ ide: Int) -> Array<String>{
        var lista: [String] = [String]()
        var mensaje: String = ""
        var errores = 0
        
        if connect(){
            do{
                let form = formulario.select(nombre, apellido, sexo, tipodoc, tipootro, numdoc, nacionalidad, pais, motivoviaje, motivootros, transportadora, numviaje, mayor, montousd, importe1, moneda1, importe2, moneda2, origen).filter(idform == Int64(ide))
                for res in try db!.prepare(form){
                    mensaje = ""
                    if res[nombre].count < 3{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Nombre(s)\n"
                        } else{
                            mensaje = mensaje + "- Name(s)\n"
                        }
                    }
                    if res[apellido].count < 3{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Apellido(s)\n"
                        } else{
                            mensaje = mensaje + "- Lastname(s)\n"
                        }
                    }
                    if res[sexo]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Sexo\n"
                        } else{
                            mensaje = mensaje + "- Sex\n"
                        }
                    }
                    if res[tipodoc]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Tipo de documento de identificación\n"
                        } else{
                            mensaje = mensaje + "- ID Document type\n"
                        }
                    } else if res[tipodoc] == "OTRO" && res[tipootro] == ""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Otro tipo de documento de identificación\n"
                        } else{
                            mensaje = mensaje + "- Another ID Document type\n"
                        }
                    }
                    if res[numdoc].count < 5{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Número de documento de identificación\n"
                        } else{
                            mensaje = mensaje + "- ID Number\n"
                        }
                    }
                    if res[nacionalidad]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Nacionalidad\n"
                        } else{
                            mensaje = mensaje + "- Nationality\n"
                        }
                    }
                    lista.append(mensaje)
                    if mensaje != "" {
                        errores = errores + 1
                    }
                    
                    mensaje = ""
                    if res[pais]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Pais de origen/destino\n"
                        } else{
                            mensaje = mensaje + "- Country of origin/destination\n"
                        }
                    }
                    if res[motivoviaje]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Motivo del viaje\n"
                        } else{
                            mensaje = mensaje + "- Reason for trip\n"
                        }
                    } else if res[motivoviaje] == "O" && res[motivootros] == ""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Otro motivo del viaje\n"
                        } else{
                            mensaje = mensaje + "- Another reason of your trip\n"
                        }
                    }
                    if res[transportadora].count < 2 {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Empresa de transporte\n"
                        } else{
                            mensaje = mensaje + "- Transportation company\n"
                        }
                    }
                    if res[numviaje].count < 3 {
                        if lang == "es-419"{
                            mensaje = mensaje + "- Número de vuelo o placa\n"
                        } else{
                            mensaje = mensaje + "- Flight or plate number\n"
                        }
                    }
                    lista.append(mensaje)
                    if mensaje != "" {
                        errores = errores + 1
                    }
                    
                    mensaje = ""
                    if res[mayor]==""{
                        if lang == "es-419"{
                            mensaje = mensaje + "- ¿Efectivo por un monto superior a 10.000 $us?\n"
                        } else{
                            mensaje = mensaje + "- Cash money for an amount upper than $ 10.000?\n"
                        }
                    } else if res[mayor] == "S" {
                        if res[montousd] == ""{
                            if res[importe1] == "" && res[importe2] == "" {
                                if lang == "es-419"{
                                    mensaje = mensaje + "- Monto USD u otra moneda\n"
                                } else{
                                    mensaje = mensaje + "- USD or other currency amount\n"
                                }
                            }
                        }
                        if res[origen].count < 3{
                            if lang == "es-419"{
                                mensaje = mensaje + "- Origen de las divisas\n"
                            } else{
                                mensaje = mensaje + "- Origin of the currencies\n"
                            }
                        }
                    }
                    if res[importe1] != "" && res[moneda1].count < 3{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Moneda para importe 1\n"
                        } else{
                            mensaje = mensaje + "- Currency for amount 1\n"
                        }
                    }
                    if res[importe2] != "" && res[moneda2].count < 3{
                        if lang == "es-419"{
                            mensaje = mensaje + "- Moneda para importe 2\n"
                        } else{
                            mensaje = mensaje + "- Currency for amount 2\n"
                        }
                    }
                    lista.append(mensaje)
                    if mensaje != "" {
                        errores = errores + 1
                    }
                    
                    mensaje = ""
                    if errores > 0 {
                        if lang == "es-419"{
                            mensaje = "Para generar el código debe llenar correctamente todo el formulario"
                        }
                        else{
                            mensaje = "In order to generate the code you have to fill correctly all the form"
                        }
                    }
                    lista.append(mensaje)
                }
            }catch{
                print("Error 6011: \(error)")
            }
        }
        return lista
    }

    func borraRegistro(_ ide: String) -> Bool{
        var res: Bool = false
        let borrado = formulario.filter(idform == Int64(ide)!)
        do{
            if try db!.run(borrado.delete()) > 0 {
                res = true
            }
        }catch{
            print("Error 6012: \(error)")
        }
        return res
    }
    
    func muestraAyuda() -> Bool{
        var resultado: String = ""
        if connect(){
            do{
                let form = sistema.select(inicio).filter(app == "VIAJEROS")
                for res in try db!.prepare(form){
                    resultado = res[inicio]
                }
            }catch{
                print("Error 6013: \(error)")
            }
            if resultado == "SI"{
                return false
            }
            else{
                return true
            }
        }
        else{
            return true
        }
    }
    
    func setMostrar(_ valor: String){
        if(connect()){
            do{
                let form = sistema.filter(app == "VIAJEROS")
                try db!.run(form.update(inicio <- valor))
            }catch{
                print("Error 6014: \(error)")
            }
        }
    }
    
    func setAuxiliar(_ valor: String){
        if(connect()){
            do{
                let form = sistema.filter(app == "VIAJEROS")
                try db!.run(form.update(auxiliar <- valor))
            }catch{
                print("Error 6015: \(error)")
            }
        }
    }
    
    func getAuxiliar() -> Bool{
        var resultado:String = ""
        if connect(){
            do{
                let form = sistema.select(auxiliar).filter(app == "VIAJEROS")
                for res in try db!.prepare(form){
                    resultado = res[auxiliar]
                }
            }catch{
                print("Error 6013: \(error)")
            }
            if resultado == "SI"{
                return false
            }
            else{
                return true
            }
        }
        else{
            return true
        }
    }
    
    //Funciones aumentadas 14/03/2019
    func getVersionDB() -> Int{
        var resultado:Int = 0
        if connect(){
            do{
                let form = sistema.select(version).filter(app == "VIAJEROS")
                for res in try db!.prepare(form){
                    resultado = Int(res[version])!
                }
            }catch{
                print("Error 6016: \(error)")
            }
        }
        return resultado
    }
    
    func dbVersion2() -> Bool {
        var resultado:Bool = false
        if connect(){
            do{
                try db!.run(formulario.addColumn(Expression<String?>(origen), defaultValue: ""))
                
                let form = sistema.filter(app == "VIAJEROS")
                try db!.run(form.update(version <- "2"))
                resultado = true
            }catch{
                resultado = false
                print("Error 6017: \(error)")
            }
        }
        return resultado
    }
    
    func dbVersion3() -> Bool {
        var resultado: Bool = false
        if connect() {
            do {
                try db!.run(formulario.delete())
                
                try db!.run(formulario.addColumn(Expression<String?>(ocupacion), defaultValue: ""))
                try db!.run(formulario.addColumn(Expression<String?>(fechanacimiento), defaultValue: ""))
                try db!.run(formulario.addColumn(Expression<String?>(destino), defaultValue: ""))
                
                let form = sistema.filter(app == "VIAJEROS")
                try db!.run(form.update(version <- "3"))
                resultado = true
            } catch {
                resultado = false
                print("Error 6018: \(error)")
            }
        }
        return resultado
    }

}
