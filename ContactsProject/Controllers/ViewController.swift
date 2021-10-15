//
//  ViewController.swift
//  ContactsProject
//
//  Created by Ömer Faruk KÖSE on 15.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var firstNameArray = [String]()
    var lastNameArray = [String]()
    var numberArray = [String]()
    
    var chosenFirstName = " "
    var chosenLastName = ""
    var chosenNumber = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
        navigationItem.title = "Contacts"
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(firstNameArray[indexPath.row]) \(lastNameArray[indexPath.row])"
        // " \(firstNameArray[indexPath.row] + lastNameArray[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenFirstName = firstNameArray[indexPath.row]
        chosenLastName = lastNameArray[indexPath.row]
        chosenNumber = numberArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Persons")
            
            let number = numberArray[indexPath.row]
            fetchRequest.predicate = NSPredicate(format: "number =%@", number)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let getNumber = result.value(forKey: "number") as? String {
                            if getNumber ==  numberArray[indexPath.row]{
                                context.delete(result)
                                numberArray.remove(at: indexPath.row)
                                firstNameArray.remove(at: indexPath.row)
                                lastNameArray.remove(at: indexPath.row)
                                tableView.reloadData()
                                do{
                                    try context.save()
                                }catch{
                                    print("Error !")
                                }
                                break
                            }
                        }
                    }
                }
                    
            }catch{
                print("Error !")
            }
            
            
        }
    }
    
    @objc func addPerson(){
        chosenFirstName = " "
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as? DetailsViewController
            destinationVC?.chosenFirstName = chosenFirstName
            destinationVC?.chosenLastName = chosenLastName
            destinationVC?.chosenNumber = chosenNumber
        }
    }
    
    func removePersons(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Persons")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                }
                do{
                    try context.save()
                    print("Save Succes !")
                }catch{
                    print("Save Error !")
                }
            }
            
        }catch{
            print("Error !")
        }
        
    }
    
    func getData(){
        firstNameArray.removeAll(keepingCapacity: true)
        lastNameArray.removeAll(keepingCapacity: true)
        numberArray.removeAll(keepingCapacity: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Persons")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let firstName = result.value(forKey: "firstname") as? String {
                        firstNameArray.append(firstName)
                    }
                    
                    if let lastName = result.value(forKey: "lastname") as? String {
                        lastNameArray.append(lastName)
                    }
                    
                    if let number = result.value(forKey: "number") as? String {
                        numberArray.append(number)
                    }
                    
                }
            }
            
        }catch{
            print("Error !")
        }
        tableView.reloadData()
    }
    
    

}

