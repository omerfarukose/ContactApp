//
//  DetailsViewController.swift
//  ContactsProject
//
//  Created by Ömer Faruk KÖSE on 15.10.2021.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    var chosenName = " "
    var chosenNumber = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CHOSEN NAME: \(chosenName)")
        print("CHOSEN NUMBER: \(chosenNumber)")
        
        if chosenName != " "{
            firstNameField.text = chosenName
            numberField.text = chosenNumber
        }
        
        navigationItem.title = "Create Person"
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Persons", into: context)
        
        newPerson.setValue(firstNameField.text, forKey: "firstname")
        newPerson.setValue(lastNameField.text, forKey: "lastname")
        newPerson.setValue(numberField.text, forKey: "number")
        newPerson.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("Succes!")
        }catch{
            print("Error !")
        }
        
        navigationController?.popViewController(animated: true)
    }
}
