//
//  VistaTablaSeleccion.swift
//  OpenLibraryVistaTabla
//
//  Created by Jose Luis Garcia Dueñas on 4/2/16.
//  Copyright © 2016 Jose Luis Garcia Dueñas. All rights reserved.
//

import UIKit
import CoreData // Imprescindible para Core Data importar su biblioteca



class VistaTablaSeleccion: UITableViewController {
    var TextoISBN: String = ""
    var TextoTitulo: String = ""
    var ISBNArr: String = ""
    var TituloArr: String = ""
    var AutorArr: String = ""
    var ImagenArr: String = ""
    var portada: UIImage!
    
    //var structLibros:[ISBNModelo] = []
    var contexto: NSManagedObjectContext? = nil  //  Core Data - variable contexto que nos permite acceder a la pila de CoreData

    override func viewDidLoad() {
        super.viewDidLoad()
        // ====================
        //  Core Data - SE RECUPERAN LOS DATOS DE LAS ENTIDADES GUARDADAS
        //  Core Data - Se le da valor a contexto
        self.contexto = (UIApplication.sharedApplication().delegate as!AppDelegate).managedObjectContext
        //  Core Data - Declaración de la Entidad "Libro"
        let seccionEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        //  Core Data - Delaración de la busqueda (fetch) de todas las Secciones
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("petISBNs")
 
        do {
            //  Core Data - Ejecución del fetch de busqueda de todas las secciones
            let seccionesEntidad = try self.contexto?.executeFetchRequest(peticion!)
            //  Core Data - Se recorren todas las secciones
            for seccionEntidad2 in seccionesEntidad! {
                //  Core Data - Recuperamos la Entidad "Libro"
                let isbn = seccionEntidad2.valueForKey("isbn") as! String
                let titulo = seccionEntidad2.valueForKey("titulo") as! String
                
                if seccionEntidad2.valueForKey("portada") == nil {
                   
                } else {
                   portada = UIImage(data: seccionEntidad2.valueForKey("portada") as! NSData)
                }
                
                
                //  Core Data - Recuperamos la key de relacion "tiene" para así acceder a los autores asociados (conjunto de objetos)
                let autoresEntidad = seccionEntidad2.valueForKey("tiene") as! Set<NSObject>
                //   Core Data - Como las imagenes las guardamos como datos hay que volver a convertirlas a imagen
                // Se crea un array de autores
                var autores = [String]()
                //  Core Data - Se recorren todas las Entidades "Autor" mediante su "nombre"
                for autoresEntidad2 in autoresEntidad {
                    //  Core Data - Se guardan los datos de la imagen en "contenido" como imagen en la variable "img"
                    let autor = autoresEntidad2.valueForKey("nombre") as! String
                    AutorArr = AutorArr + autor + "\n"
                    //  Core Data - Se añade la imagen al array de imagenes
                    autores.append(autor)
                }
                
                //  Core Data - Se añade al array las Entidades recuperadas

                let isbnM = ISBNModelo(isbn: isbn, nombre: titulo, autores:autores  , imagen: portada)
                structLibros.append(isbnM)

            }
        } catch {
            
        }
        //================

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return ArrayLibros.count
        return structLibros.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

//            cell.textLabel?.text = ArrayLibros[indexPath.row][1]
            cell.textLabel?.text = structLibros[indexPath.row].nombre
        
        // Configure the cell...
       return cell
    }

    
//    // recupera el texto de la fila pulsada en la tabla
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("You selected cell #\(indexPath.row)!")
//        
//        // Get Cell Label
//        let indexPath = self.tableView.indexPathForSelectedRow!;
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
//        
//        print(currentCell.textLabel!.text)
//        TituloArr = buscaTitulo(currentCell.textLabel!.text!)
//        performSegueWithIdentifier("DesdeTableView", sender: UITableView.self)
//    }
    
   
    override func viewWillAppear(animated: Bool) {

        self.tableView.reloadData()
        
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DesdeTableView" {
           let sigVista=segue.destinationViewController as! VistaDetalle
            
            let indice = self.tableView.indexPathForSelectedRow
//            sigVista.ISBNArr = ArrayLibros[indice!.item][0]
//            sigVista.TituloArr = ArrayLibros[indice!.item][1]
//            sigVista.AutorArr = ArrayLibros[indice!.item][2]
//            sigVista.ImagenArr = ArrayLibros[indice!.item][3]
            sigVista.ISBNArr = structLibros[indice!.item].isbn
            sigVista.TituloArr = structLibros[indice!.item].nombre
            sigVista.AutorArr = structLibros[indice!.item].autores.joinWithSeparator(",")
            sigVista.PortadaImg = structLibros[indice!.item].imagen
           
        }
                    
    }


    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
