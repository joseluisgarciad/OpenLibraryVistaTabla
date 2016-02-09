//
//  VistaTablaSeleccion.swift
//  OpenLibraryVistaTabla
//
//  Created by Jose Luis Garcia Dueñas on 4/2/16.
//  Copyright © 2016 Jose Luis Garcia Dueñas. All rights reserved.
//

import UIKit

class VistaTablaSeleccion: UITableViewController {
    var TextoISBN: String = ""
    var TextoTitulo: String = ""
    var ISBNArr: String = ""
    var TituloArr: String = ""
    var AutorArr: String = ""
    var ImagenArr: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return ArrayLibros.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

            cell.textLabel?.text = ArrayLibros[indexPath.row][1]
        
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
            sigVista.ISBNArr = ArrayLibros[indice!.item][0]
            sigVista.TituloArr = ArrayLibros[indice!.item][1]
            sigVista.AutorArr = ArrayLibros[indice!.item][2]
            sigVista.ImagenArr = ArrayLibros[indice!.item][3]
        }
                    
    }


    
//    func buscaTitulo(Titulo:String) -> String {
//        var resultado: String = ""
//        var indInt: Int = 0
//        for indice in ArrayLibros {
//            if ArrayLibros[indInt][1] == Titulo {
//                ISBNArr = ArrayLibros[indInt][0]
//                TextoISBN = ISBNArr
//                resultado = ArrayLibros[indInt][1]
//                TituloArr = resultado
//                AutorArr =  ArrayLibros[indInt][2]
//                if ArrayLibros[indInt][3] == "" {
//                } else {
//                  ImagenArr = ArrayLibros[indInt][3]
//                }
//                print(indice)
//            }
//            indInt++
//        }
//      //self.tableView.indexPathForSelectedRow
//      return resultado
//    }
    

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
