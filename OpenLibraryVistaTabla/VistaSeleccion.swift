//
//  VistaSeleccion.swift
//  OpenLibraryVistaTabla
//
//  Created by Jose Luis Garcia Dueñas on 4/2/16.
//  Copyright © 2016 Jose Luis Garcia Dueñas. All rights reserved.
//

import UIKit


class VistaSeleccion: UIViewController, UITextFieldDelegate {
    var Seleccion:Bool = true
    var volver:Bool = false
    var CodigoISBN: String = ""
    var DireccionPortadas: String = "https://covers.openlibrary.org/b/id/"
    var Autores: String = ""
    var ISBNArr: String = ""
    var TituloArr: String = ""
    var AutorArr: String = ""
    var ImagenArr: String = ""

    
    @IBOutlet weak var TextoISBN: UITextField!
    @IBOutlet weak var TxtTitulo: UILabel!
    @IBOutlet weak var TxtAutores: UILabel!
    @IBOutlet weak var ImgPortada: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        TextoISBN.delegate = self
        TextoISBN.returnKeyType = UIReturnKeyType.Search
        if TextoISBN.text == "" {
            TxtTitulo.text = ""
            TxtAutores.text = ""
            ImgPortada.image = nil
        }
    }
    // Then handle the button selection
    
    
    @IBAction func textFieldDoneEditing(sender:UITextField)
    {
        sender.resignFirstResponder() // desaparece el teclado
    }
    
    @IBAction func CancelarBusqueda(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func SalvarBusqueda(sender: UIBarButtonItem) {
        ArrayLibros.append([ISBNArr, TituloArr,AutorArr,ImagenArr])
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CajaTextoISBN(sender: AnyObject) {
        CodigoISBN = TextoISBN.text!
        if recuperarJSON() == false {
            print("falso")
            //navigationController?.popToRootViewControllerAnimated(true)
            mensaje("No existe el ISBN indicado", viewController: self)
        } else {

            TxtTitulo.text = TituloArr
            TxtAutores.text = AutorArr
            ImgPortada.imageFromUrl(ImagenArr)
            ImgPortada.sizeToFit()
        }
    }
    
    func recuperarJSON() -> Bool {
        var listaAutores = [String]()
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let url = NSURL(string: urls + CodigoISBN)
        let datos = NSData(contentsOfURL: url!)
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
            
            let dico1 = json as! NSDictionary
            if let _ = dico1["ISBN:" + CodigoISBN] as? NSDictionary { //existe isbn??
                let dico2 = dico1["ISBN:" + CodigoISBN] as! NSDictionary
                ISBNArr = CodigoISBN
                if let aut = dico2["authors"] as? [[String: AnyObject]] {
                    for a in aut {
                        if let name = a["name"] as? String {
                            listaAutores.append(name)
                        }
                    }
                }
                
                if let _ = dico2["cover"] as? NSDictionary {
                    let cover = dico2["cover"]
                    if cover != nil && cover is NSDictionary {
                        let covers = dico2["cover"] as!NSDictionary
                        //ImagenPortada.imageFromUrl(covers["medium"] as! NSString as String)
                        ImagenArr = (covers["medium"] as! NSString as String)
                    }
                }
                
                //self.Titulo.text = dico2["title"] as! NSString as String
                TituloArr = dico2["title"] as! NSString as String
                
                for b in listaAutores {
                    Autores = Autores + " " + b + "\n"
                    AutorArr = Autores
                }
                
            } else {
                //mensaje("No existe el ISBN indicado")
                volver = true
                return false
            }
            
            return true
        }
        catch _ {
            //mensaje("Error al Recuperar ISBN")
            volver = true
            return false
        }
    }

}

//func mensaje (Texto: String) {
//    let alertController = UIAlertController(title: "OpenLibrary JSON", message:
//        Texto, preferredStyle: UIAlertControllerStyle.Alert)
//    alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default,handler: nil))
//    
//    self.presentViewController(alertController, animated: true, completion: nil)
//}

func mensaje(Texto : String, viewController : UIViewController) -> Void {
    let pleaseAssessAlert = UIAlertController(title: "OpenLibrary", message: Texto, preferredStyle: .Alert)
    //ok button
    let okButtonOnAlertAction = UIAlertAction(title: "Cerrar", style: .Default)
        { (action) -> Void in
                //what happens when "ok" is pressed
        }
    pleaseAssessAlert.addAction(okButtonOnAlertAction)
    viewController.presentViewController(pleaseAssessAlert, animated: true, completion: nil)
}
