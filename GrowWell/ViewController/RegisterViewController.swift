//
//  RegisterViewController.swift
//  GrowWell
//
//  Created by Guido william on 24/04/23.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfConfirm: UITextField!
    
    @IBOutlet weak var lbError: UILabel!
    
    @IBOutlet weak var tfUsername: UITextField!
    
    var context:NSManagedObjectContext!
    
    @IBAction func btnRegister(_ sender: Any) {
        let email = tfEmail.text
        let password = tfPassword.text
        let confirm = tfConfirm.text
        let username = tfUsername.text
        
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

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)

        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                let alert = "Email is already registered"
                self.lbError.text = alert
                return
            } else {
                guard let username = tfUsername.text, !username.isEmpty else {
                    let alert = "Username is required!"
                    self.lbError.text = alert
                    return
                }
                
                guard let password = tfPassword.text, !password.isEmpty else {
                    let alert = "Password is required!"
                    self.lbError.text = alert
                    return
                }

                guard let confirm = tfConfirm.text, !confirm.isEmpty, password == confirm else {
                    let alert = "Confirm Password do not match!"
                    self.lbError.text = alert
                    return
                }

                let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(email, forKey: "email")
                newUser.setValue(password, forKey: "password")
                newUser.setValue(0, forKey: "point")
                newUser.setValue(username, forKey: "username")
                
                try context.save()
                
                if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    loginViewController.registeredEmail = tfEmail.text
                    navigationController?.pushViewController(loginViewController, animated: true)
                }

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
