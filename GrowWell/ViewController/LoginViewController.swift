//
//  LoginViewController.swift
//  GrowWell
//
//  Created by Guido william on 24/04/23.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var lbError: UILabel!
    
    var registeredEmail: String?
    
    var context:NSManagedObjectContext!
    
    @IBAction func btnLogin(_ sender: Any) {
        
        let email = tfEmail.text
        let password = tfPassword.text

        
        guard let email = tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            let alert = "Email is required!"
            self.lbError.text = alert
            return
        }

        guard isValidEmail(email) else {
            let alert = "Invalid email address!"
            self.lbError.text = alert
            return
        }

        guard let password = tfPassword.text, !password.isEmpty else {
            let alert = "Password is required!"
            self.lbError.text = alert
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "email = %@ AND password = %@", email, password)
        fetchRequest.propertiesToFetch = ["email", "password", "username", "point"]
            
            do {
                let users = try context.fetch(fetchRequest)
                    
                if let user = users.first as? NSManagedObject {
                    if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
                        if let navController = tabBarController.viewControllers?.first as? UINavigationController,
                           let homeViewController = navController.topViewController as? HomeViewController {
                            homeViewController.rUser = user
                            navController.navigationItem.hidesBackButton = true
                            tabBarController.navigationItem.hidesBackButton = true
                        }
                        if let manageNavController = tabBarController.viewControllers?[1] as? UINavigationController,
                           let manageViewController = manageNavController.topViewController as? ManageViewController {
                            manageViewController.rUser = user
                        }
                        navigationController?.pushViewController(tabBarController, animated: true)
                    }


                    
                } else {
                    let alert = "Account Invalid!"
                    self.lbError.text = alert
                }
            } catch {
                let alert = "An error occurred. Please try again later."
                self.lbError.text = alert
            }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfEmail.text = registeredEmail
        self.lbError.text = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
