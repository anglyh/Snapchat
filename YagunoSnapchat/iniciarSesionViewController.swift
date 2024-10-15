import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleSignIn()
    }

    private func setupGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Configura Google Sign-In con el clientID
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            print("Intentando Iniciar Sesión")
            if let error = error {
                print("Se presentó el siguiente error: \(error.localizedDescription)")
            } else {
                print("Inicio de sesión exitoso")
            }
        }
    }
    
    @IBAction func googleSignInTapped(_ sender: Any) {
        // Inicia el flujo de autenticación de Google
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                print("Error en el inicio de sesión de Google: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                return
            }
            
            // Crea las credenciales de Firebase a partir del token de Google
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            // Autentica con Firebase usando las credenciales de Google
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Error en la autenticación de Firebase con Google: \(error.localizedDescription)")
                    return
                }
                
                print("Inicio de sesión exitoso con Google y Firebase")
            }
        }
    }
}
