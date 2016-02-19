//
//  VistaSeleccion.swift
//  OpenLibraryVistaTabla
//
//  Created by Jose Luis Garcia Dueñas on 4/2/16.
//  Copyright © 2016 Jose Luis Garcia Dueñas. All rights reserved.
//

import UIKit
import CoreData

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
    var PortadaImg: UIImage?
    var AutoresArray:[String] = []
    var contexto: NSManagedObjectContext? = nil  //  Core Data - variable contexto que nos permite acceder a la pila de CoreData

    
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
        //ArrayLibros.append([ISBNArr, ISBNArr,AutorArr,ImagenArr])
        let Imagen:UIImage?
        Imagen = ImgPortada.image
        let isbnM = ISBNModelo(isbn: ISBNArr, nombre: TituloArr, autores:AutoresArray  , imagen: Imagen)
        structLibros.append(isbnM)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CajaTextoISBN(sender: AnyObject) {
        CodigoISBN = TextoISBN.text!
        self.contexto = (UIApplication.sharedApplication().delegate as!AppDelegate).managedObjectContext
        // Core Data - Interceptamos la busqueda para comprobar si ya fue realizada con anterioridad
        // Core Data - Se declara la Entidad "Seccion"
        let seccionEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        // Core Data - Se declara la Peticion de busqueda "pedSeccion" con su variable indicada "nombre
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petISBN", substitutionVariables: ["isbn": CodigoISBN])
        do {
            // Core Data - Se ejecuta la petición "peticion" y se comprueba si ya se habia buscado anteriormente lo que trae sender
            let seccionEntidad2 = try self.contexto?.executeFetchRequest(peticion!)
            if(seccionEntidad2?.count > 0) {
                // Core Data - si count > 0 es que hay datos ya guardados de esa busqueda y como no es necesario recuperarlos de nuevo se sale de la función
                TextoISBN.text = nil
                return
            }
        }
        catch {
            
        }
        //======== se buscan los datos =========
        if recuperarJSON() == false {
            //print("falso")

            mensaje("No existe el ISBN indicado", viewController: self)
        } else {

            TxtTitulo.text = TituloArr
            TxtAutores.text = AutoresArray.joinWithSeparator(",")
            ImgPortada.imageFromUrl(ImagenArr)
            PortadaImg = ImgPortada.image
            ImgPortada.sizeToFit()
            var Imagen: UIImage?
            //Imagen = ImgPortada.image
            //  Core Data - Se guardan en Core Data los datos recuperados de la busquedaGoogle
            //  Core Data - Creacion de nueva entidad "Seccion" dentro de contexto para almacenar busqueda
            let nuevaseccionEntidad = NSEntityDescription.insertNewObjectForEntityForName("Libro", inManagedObjectContext: self.contexto!)
            // Core Data - Creación de todas las claces dentro de "Libro"
            nuevaseccionEntidad.setValue(CodigoISBN, forKey: "isbn")
            nuevaseccionEntidad.setValue(TituloArr, forKey: "titulo")
            if ImagenArr == "" {
                ImgPortada.image = UIImage(named: "noimagen.jpg")
                Imagen = UIImage(named: "noimagen.jpg")
                nuevaseccionEntidad.setValue(UIImagePNGRepresentation(Imagen!), forKey: "portada")
            } else {
                let img_url = NSURL(string: ImagenArr)
                let img_datos = NSData(contentsOfURL: img_url!)
                if  UIImage(data: img_datos!) == nil {
                    Imagen = UIImage(data: img_datos!)!
                    nuevaseccionEntidad.setValue(UIImagePNGRepresentation(Imagen!), forKey: "portada")
                }
            }
        

                        //  Core Data - Se rellena la entidad "Autor" con el contenido de "AutoresArray" dentro de la funcion "creaAutoresEntidad"
            nuevaseccionEntidad.setValue(creaAutoresEntidad(AutoresArray, contexto2: contexto), forKey: "tiene")
            do {
                // Core Data - Se guardan fisicamente todas las entidades y claves que hemos ido guardado en contexto
                try self.contexto?.save()
            } catch {
                
            }

        }
    }
    
    func recuperarJSON() -> Bool {
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
                            AutoresArray.append(name)
                        }
                    }
                }
                
                if let _ = dico2["cover"] as? NSDictionary {
                    let cover = dico2["cover"]
                    if cover != nil && cover is NSDictionary {
                        let covers = dico2["cover"] as!NSDictionary

                        ImagenArr = (covers["medium"] as! NSString as String)
                    }
                }
                
                //self.Titulo.text = dico2["title"] as! NSString as String
                TituloArr = dico2["title"] as! NSString as String
                AutorArr = AutoresArray.joinWithSeparator(",")
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

func creaAutoresEntidad(Autores: [String], contexto2: NSManagedObjectContext?) -> Set<NSObject> {
    //  Core Data - se declaran un conjunto de entidades que serán las que se devuelvan
    var entidades = Set<NSObject>()
    //  Core Data - se recorren las imagenes dadas por parametros
    for autor in Autores {
        //  Core Data - Creación de entidad "Autor" clave "nombre" por cada autor leido en el bucle de autores recuperados
        let imagenEntidad = NSEntityDescription.insertNewObjectForEntityForName("Autor", inManagedObjectContext: contexto2!)
        // Core Data - Se establecen los datos en la entidad 
        imagenEntidad.setValue(autor, forKey: "nombre")
        // Core Data - Insertar la entidad en el objeto "entidades"
        entidades.insert(imagenEntidad)
    }
    
    return entidades
}
