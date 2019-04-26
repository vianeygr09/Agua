//
//  ViewController.swift
//  RutinaGymApp
//
//  Created by Mike on 4/24/19.
//  Copyright © 2019 UTNG. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        //the artist object
        let water: Water
    
        //getting the artist of selected position
        water = waterList[indexPath.row]
        
        //adding values to labels
        cell.lblMarca.text = water.marca
        cell.lblPrecio.text = water.precio
        cell.lblCantidad.text = water.cantidad
        cell.lblPreferencia.text = water.preferencia
       
        //returning cell
        return cell
    }
     var waterList = [Water]()
    
    @IBOutlet weak var textFieldMarca: UITextField!
    @IBOutlet weak var textFieldPrecio: UITextField!
    @IBOutlet weak var textFieldCantidad: UITextField!
    @IBOutlet weak var textFieldPreferencia: UITextField!
    
    @IBOutlet weak var tblWaters: UITableView!
    
    @IBAction func buAdd(_ sender: UIButton) {
        addWater()
    }
    
    @IBOutlet weak var labelMessage: UILabel!
    
    //this function will be called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the selected artist
        let water = waterList[indexPath.row]
        
        //building an alert
        let alertController = UIAlertController(title: water.marca, message: "Dame los valores a Actualizar", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Actualizar", style: .default) { (_) in
            
            //getting artist id
            let id = water.id
            
            //getting new values
            let marca = alertController.textFields?[0].text
            let precio = alertController.textFields?[1].text
            let cantidad = alertController.textFields?[2].text
            let preferencia = alertController.textFields?[3].text
    
            //calling the update method to update artist
        
            
            self.updateWater(id: id!, marca: marca!, precio: precio!, cantidad: cantidad!, preferencia: preferencia!)
        }
        
        let cancelAction = UIAlertAction(title: "Eliminar", style: .cancel) { (_) in
            //deleting artist
            self.deleteWater(id: water.id!)
        }
        //adding two textfields to alert
        alertController.addTextField { (textField) in
            textField.text = water.marca
        }
        alertController.addTextField { (textField) in
            textField.text = water.precio
        }
        alertController.addTextField { (textField) in
            textField.text = water.cantidad
        }
        alertController.addTextField { (textField) in
            textField.text = water.preferencia
        }
      
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
    }
    
    func updateWater(id:String, marca:String, precio:String, cantidad:String, preferencia: String){
        //creating artist with the new given values
        let water =     ["id":id,
                      "marca": marca,
                      "precio": precio,
                      "cantidad": cantidad,
                      "preferencia":preferencia
        ]
        
        //updating the artist using the key of the artist
        refWater.child(id).setValue(water)
        
    }
    
    func deleteWater(id:String){
        refWater.child(id).setValue(nil)
        
    }
    
    
    var refWater: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FirebaseApp.configure()
        
        //getting a reference to the node artists
        refWater = Database.database().reference().child("Waters");
        
        //observing the data changes
        refWater.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.waterList.removeAll()
                
                //iterating through all the values
                for waters in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let waterObject = waters.value as? [String: AnyObject]
                    let id  = waterObject?["id"]
                    let marca  = waterObject?["marca"]
                    let precio = waterObject?["precio"]
                    let cantidad = waterObject?["cantidad"]
                    let preferencia = waterObject?["preferencia"]
                    
                    //creating artist object with model and fetched values
                    let water =    Water(id: id as! String,
                                     marca: marca as! String,
                                     precio: precio as! String,
                                     cantidad: cantidad as! String,
                                     preferencia: preferencia as! String)
                    
                    //appending it to list
                    self.waterList.append(water)
                }
                //reloading the tableview
                self.tblWaters.reloadData()
            }
        })
    }
    
    func addWater(){
        let key = refWater.childByAutoId().key
    
        let water =     ["id":key,
                      "marca": textFieldMarca.text! as String,
                      "precio": textFieldPrecio.text! as String,
                      "cantidad": textFieldCantidad.text! as String,
                      "preferencia": textFieldPreferencia.text! as String
                      ]
        
        refWater.child(key ?? "oilo").setValue(water)
    }
}
