import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class RegistrarUsuarioViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registrarUsuarioTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Por favor, completa todos los campos.")
            return
        }

        // Crear un nuevo usuario en Firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Se presentó el siguiente error al crear el usuario: \(error.localizedDescription)")
                // Aquí puedes agregar una alerta para mostrar el error al usuario
                return
            }
            
            // Usuario creado exitosamente
            print("El usuario fue creado exitosamente")
            
            // Guardar el usuario en la base de datos
            if let uid = authResult?.user.uid {
                Database.database().reference().child("usuarios").child(uid).child("email").setValue(email)
            }
            
            // Opcional: Presentar un mensaje de éxito
            let alerta = UIAlertController(title: "Registro Exitoso", message: "El usuario se creó correctamente.", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "Aceptar", style: .default) { _ in
                // Puedes regresar a la pantalla de inicio de sesión o a donde desees
                self.dismiss(animated: true, completion: nil)
            }
            alerta.addAction(btnOK)
            self.present(alerta, animated: true, completion: nil)
        }
    }
}
