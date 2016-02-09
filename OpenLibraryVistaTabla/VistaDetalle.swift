//
//  VistaDetalle.swift
//  OpenLibraryVistaTabla
//
//  Created by Jose Luis Garcia Dueñas on 4/2/16.
//  Copyright © 2016 Jose Luis Garcia Dueñas. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode = UIViewContentMode.ScaleAspectFill
                if data == nil {
                    
                } else {
                    self.image = UIImage(data: data!)
                }
            }
            }.resume()
    }
}

class VistaDetalle: UIViewController {
    
    var ISBNArr: String = ""
    var TituloArr: String = ""
    var AutorArr: String = ""
    var ImagenArr: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MostrarDatos() == true {
            
        } else {
            mensaje("Error al mostrar datos")
        }
 
    }

    

    func MostrarDatos() -> Bool {
        Titulo.text = TituloArr
        Autores.text = AutorArr
        ImagenPortada.image = nil
        ImagenPortada.imageFromUrl("")
        ImagenPortada.imageFromUrl(ImagenArr)
//        print("mostrarDatos en VistaDetalle desde Tabla: \(TituloArr) \(AutorArr) \(ImagenArr)")
        return true
    }
    
    
    @IBOutlet weak var Titulo: UILabel!
    @IBOutlet weak var Autores: UILabel!
    @IBOutlet weak var ImagenPortada: UIImageView!
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func mensaje (Texto: String) {
        let alertController = UIAlertController(title: "OpenLibrary JSON", message:
            Texto, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
