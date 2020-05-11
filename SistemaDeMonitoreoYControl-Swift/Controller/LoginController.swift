//
//  LoginController.swift
//  SistemaDeMonitoreoYControl-Swift
//
//  Created by Diseno2 on 1/20/20.
//  Copyright © 2020 GlobalCorporation. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class LoginController: BaseViewController {
    
    // MARK: - Properties
    
    let formContainer = UIView(backgroundColor: #colorLiteral(red: 0.2039999962, green: 0.2269999981, blue: 0.2509999871, alpha: 1))
    let userTextField = IndentedTextField(placeholder: "Usuario", padding: 16, cornerRadius: 20, backgroundColor: .white)
    let passwordTextField = IndentedTextField(placeholder: "Contraseña", padding: 16, cornerRadius: 20, backgroundColor: .white)
    lazy var loginButton = UIButton(title: "Entrar", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: #colorLiteral(red: 0.8549019608, green: 0.1607843137, blue: 0.1098039216, alpha: 1), target: self, action: #selector(handleLogin))
    let errorLabel = UILabel(text: "Usuario y/o contraseña incorrectos", font: .systemFont(ofSize: 14), textColor: .white, textAlignment: .center, numberOfLines: 0)
    var formContainerYAnchor: NSLayoutConstraint!
    lazy var backgroundTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
        registerNotifications()
        
        view.addGestureRecognizer(backgroundTap)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unregisterNotifications()
    }
    
    // MARK: - Helper Functions
    
    fileprivate func setupViewComponents() {
        navigationItem.rightBarButtonItem = .init(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(handleSettings))
        
        view.addSubview(formContainer)
        formContainerYAnchor = formContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        formContainerYAnchor.isActive = true
        formContainer.withSize(.init(width: 500, height: 450))
        formContainer.centerXToSuperview()
        formContainer.layer.cornerRadius = 15
        formContainer.clipsToBounds = true
        
        loginButton.layer.cornerRadius = 20
        userTextField.autocapitalizationType = .none
        userTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        let titleLabel = UILabel(text: "  Sistema de Monitoreo y Control", font: .boldSystemFont(ofSize: 16), textColor: .black, textAlignment: .left)
        titleLabel.backgroundColor = .white
        formContainer.addSubview(titleLabel)
        titleLabel.anchor(top: formContainer.topAnchor, leading: formContainer.leadingAnchor, bottom: nil, trailing: formContainer.trailingAnchor, size: .init(width: 0, height: 50))

        let userLabel = UILabel(text: "Usuario:", font: .boldSystemFont(ofSize: 14), textColor: .white)
        let passwordLabel = UILabel(text: "Contraseña:", font: .boldSystemFont(ofSize: 14), textColor: .white)

        let stackView = UIStackView()
        stackView.stack(userLabel,
                        userTextField.withSize(.init(width: 250, height: 40)),
                        passwordLabel,
                        passwordTextField.withSize(.init(width: 250, height: 40)),
                        loginButton.withSize(.init(width: 150, height: 40)),
                        spacing: 16,
                        alignment: .center)
        
        formContainer.addSubview(stackView)
        stackView.centerInSuperview()
        
        formContainer.addSubview(errorLabel)
        errorLabel.backgroundColor = #colorLiteral(red: 0.9959999919, green: 0.5099999905, blue: 0.00400000019, alpha: 1)
        errorLabel.anchor(top: nil, leading: formContainer.leadingAnchor, bottom: formContainer.bottomAnchor, trailing: formContainer.trailingAnchor, size: .init(width: 0, height: 30))
        
        errorLabel.isHidden = true
    }
    
    fileprivate func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func mostrarDependencias() {
        let controller = DependenciasController()
        controller.loginController = self
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    fileprivate func mostrarAlerta() {
        let alertController = UIAlertController(title: "Dependencia no seleccionada.", message: "Por favor seleccione una dependencia a la que requiere accesar.", preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default, handler: { (_) in
            self.mostrarDependencias()
        }))
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Selectors
    
    @objc fileprivate func handleLogin() {
        let hud = JGProgressHUD(style: .dark)
        if UserDefaults.standard.object(forKey: Constants.dependencia) == nil {
            mostrarAlerta()
        } else {
            hud.textLabel.text = "Iniciando sesión"
            hud.show(in: view)
        }
        
        guard let user = userTextField.text else {
            errorLabel.isHidden = false
            return
        }
        
        guard let password = passwordTextField.text else {
            errorLabel.isHidden = false
            return
        }
        
        Service.shared.login(user: user, password: password) { (res) in
            hud.dismiss()
            
            switch res {
            case .failure:
                self.errorLabel.isHidden = false
            case .success(let user):
                UserDefaults.standard.set(user.id, forKey: Constants.usuario)
                self.navigationController?.pushViewController(AdminController(), animated: true)
            }
        }
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        formContainerYAnchor.constant = view.centerYAnchor.accessibilityFrame.height - 100
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        formContainerYAnchor.constant += 100
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc fileprivate func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc fileprivate func handleSettings(_ sender: UIButton) {
        mostrarDependencias()
    }
}

// MARK: - UITextFieldDelegate

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleLogin()
        return true
    }
}
