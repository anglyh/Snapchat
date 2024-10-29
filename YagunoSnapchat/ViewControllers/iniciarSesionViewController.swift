import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase


class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Por favor, completa todos los campos.")
            return
        }

        // Intentar iniciar sesión
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Se presentó el siguiente error: \(error.localizedDescription)")
                
                // Mostrar alerta si el usuario no existe
                self.mostrarAlertaUsuarioNoRegistrado(email: email)
            } else {
                print("Inicio de sesión exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    private func mostrarAlertaUsuarioNoRegistrado(email: String) {
        let alerta = UIAlertController(title: "Error de Inicio de Sesión", message: "El usuario con el email \(email) no está registrado. ¿Deseas crear una cuenta?", preferredStyle: .alert)
        
        let btnCrear = UIAlertAction(title: "Crear", style: .default) { _ in
            self.performSegue(withIdentifier: "goToRegister", sender: nil) // Cambia el identificador según tu segue
        }
        
        let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(btnCrear)
        alerta.addAction(btnCancelar)
        
        self.present(alerta, animated: true, completion: nil)
    }
}
