//
//  arrLibros.swift
//  OpenLibraryVistaTabla
//
//  Created by Jose Luis Garcia Dueñas on 4/2/16.
//  Copyright © 2016 Jose Luis Garcia Dueñas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var ArrayLibros: Array<Array<String>>  = Array<Array<String>>()

var AutoresArray:[String] = []
var structLibros:[ISBNModelo] = []
public var contexto: NSManagedObjectContext? = nil  //  Core Data - variable contexto que nos permite acceder a la pila de CoreData

struct ISBNModelo {
    var isbn:String
    var nombre:String
    var autores:[String]
    var imagen:UIImage?
    
    init(isbn:String,nombre:String, autores:[String],imagen:UIImage?) {
        self.isbn = isbn
        self.nombre = nombre
        self.autores = autores
        if let hayImagen = imagen {
            self.imagen = hayImagen
        } else {
            self.imagen = nil
        }
    }
}



