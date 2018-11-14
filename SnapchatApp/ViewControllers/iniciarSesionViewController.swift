//
//  iniciarSesionViewController.swift
//  SnapchatApp
//
//  Created by Yanela Pachacama Quispe on 31/10/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import  FirebaseDatabase


class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        FIRAuth.auth()!.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in print("Intentamos Iniciar Sesión")
            if error != nil {
                print("Tenemos el siguiente error: \(String(describing: error))")
                FIRAuth.auth()!.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user,error) in
                    print("Intentamos crear un usuario")
                    if error != nil {
                        print("Tenemos el siguiente error \(String(describing: error))")
                    }else{
                        print("El usuario fue creado exitosamente")
                        FIRDatabase.database().reference().child("usuarios").child(user!.uid).child("email").setValue(user!.email)
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })
            }else {
                print("Inicio de Sesión exitosa")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

