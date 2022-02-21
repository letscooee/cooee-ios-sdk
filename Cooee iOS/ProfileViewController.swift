//
//  ProfileViewController.swift
//  Cooee iOS
//
//  Created by Ashish Gaikwad on 27/10/21.
//

import UIKit
import CooeeSDK

class ProfileViewController: UIViewController {

    @IBOutlet weak var edtName: UITextField!
    @IBOutlet weak var edtEmail: UITextField!
    @IBOutlet weak var edtMobile: UITextField!

    var cooeeSDK = CooeeSDK.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func saveProfile(_ sender: Any) {
        let name = edtName.text
        let email = edtEmail.text
        let mobile = edtMobile.text

        if name?.isEmpty ?? true {
            showAlert("Name can't be empty", false)
        }

        if email?.isEmpty ?? true {
            showAlert("Email can't be empty", false)
        }

        if mobile?.isEmpty ?? true {
            showAlert("Mobile No. can't be empty", false)
        }

        do {
            try cooeeSDK.updateUserProfile(["name": name!, "email": email!, "mobile": mobile!])
        } catch {
            showAlert("\(error.localizedDescription)", false)
            return
        }

        showAlert("Profile Updated", true)
    }

    private func showAlert(_ msg: String, _ close: Bool) {
        let alert = UIAlertController(title: "Warning", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            if close {
                self.presentingViewController?.dismiss(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
