
//
//  DrawerViewController.swift
//  Tuseva
//
//  Created by Praveen Khare on 02/08/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {

    @IBOutlet var imgProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if UserDefaults.standard.value(forKey: "image") != nil
        {
            let imgURL = UserDefaults.standard.value(forKey: "image") as? String
            self.imgProfile.setImageFromURl(stringImageUrl: imgURL!)
        }
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2;
        imgProfile.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension DrawerViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if UserDefaults.standard.value(forKey: "ID") != nil
        {
            return 9
        }
        else
        {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "My Profile"
            cell.imageView?.image = UIImage(named: "Slide_Profile")
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = "Service Provider"
            cell.imageView?.image = UIImage(named: "Slide_ServiceProvider")
        }
        else if indexPath.row == 2 {
            cell.textLabel?.text = "Service / Modify Your Vehicle"
            cell.imageView?.image = UIImage(named: "Slider_ServiceModify")
        }
        else if indexPath.row == 3 {
            cell.textLabel?.text = "Buy New Wheels"
            cell.imageView?.image = UIImage(named: "Slider_Buy")
        }
        else if indexPath.row == 4 {
            cell.textLabel?.text = "My Queries"
            cell.imageView?.image = UIImage(named: "Slider_MyQuery")
        }
        else if indexPath.row == 5 {
            cell.textLabel?.text = "Service Reminder"
            cell.imageView?.image = UIImage(named: "Slider_ServiceReminder")
        }
        else if indexPath.row == 6 {
            cell.textLabel?.text = "Join Tuseva"
            cell.imageView?.image = UIImage(named: "Slider_Join")
        }
        else if indexPath.row == 7 {
            cell.textLabel?.text = "Contact Us"
            cell.imageView?.image = UIImage(named: "Slider_Contact")
        }
        else {
//            if UserDefaults.standard.value(forKey: "ID") != nil
//            {
                cell.textLabel?.text = "Logout"
                cell.imageView?.image = UIImage(named: "logout")
//            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealController: SWRevealViewController? = revealViewController()

        if indexPath.row == 0 {
            
            if UserDefaults.standard.value(forKey: "ID") != nil
            {

                let profile = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                
                profile.isReveal = "1"
                
                let navigationController = UINavigationController(rootViewController: profile)
                
                revealController?.pushFrontViewController(navigationController, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            
//            let dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
//
//            let navigationController = UINavigationController(rootViewController: dashVC)
//            
//            revealController?.pushFrontViewController(navigationController, animated: true)

        }
        else if indexPath.row == 1 {
            
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let serviceProvider = self.storyboard?.instantiateViewController(withIdentifier: "ListOfServiceProviderVC") as! ListOfServiceProviderVC
                
                serviceProvider.isReveal = "1"
                let navigationController = UINavigationController(rootViewController: serviceProvider)
                
                revealController?.pushFrontViewController(navigationController, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 2 {
//            if UserDefaults.standard.value(forKey: "ID") != nil
//            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "serviceVC") as! ServiceAndModifyVC
                serviceVC.strClick = "service"
                serviceVC.isReveal = "1"
                let navigationController = UINavigationController(rootViewController: serviceVC)
                
                revealController?.pushFrontViewController(navigationController, animated: true)
//            }
//            else
//            {
//                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                    self.gotoNextVC()
//                }))
//                self.present(alert, animated: true, completion: nil)
//            }
            
        }
        else if indexPath.row == 3 {
            
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "serviceVC") as! ServiceAndModifyVC
                serviceVC.strClick = "buy"
                serviceVC.isReveal = "1"
                let navigationController = UINavigationController(rootViewController: serviceVC)
                
                revealController?.pushFrontViewController(navigationController, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else if indexPath.row == 4 {
            
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviousQueryVC") as! PreviousQueryVC
                serviceVC.isReveal = "1"
                let navigationController = UINavigationController(rootViewController: serviceVC)
                
                revealController?.pushFrontViewController(navigationController, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else if indexPath.row == 5 {
            
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceReminderListViewController") as! ServiceReminderListViewController
                serviceVC.isReveal = "1"
                let navigationController = UINavigationController(rootViewController: serviceVC)
                
                revealController?.pushFrontViewController(navigationController, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else if indexPath.row == 6 {
            
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "JoinUSViewController") as! JoinUSViewController
                serviceVC.isReveal = "1"
                let navigationController = UINavigationController(rootViewController: serviceVC)
                
                revealController?.pushFrontViewController(navigationController, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else if indexPath.row == 7 {
            
            if UserDefaults.standard.value(forKey: "ID") != nil
            {
                let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                serviceVC.isReveal = "1"
                let navigationController = UINavigationController(rootViewController: serviceVC)
                
                revealController?.pushFrontViewController(navigationController, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Tuseva", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.gotoNextVC()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else  {
            
//            if UserDefaults.standard.value(forKey: "ID") != nil
//            {
                User.logOutUser { (status) in
                    if status == true {
                        
                        let domain = Bundle.main.bundleIdentifier!
                        
                        UserDefaults.standard.removePersistentDomain(forName: domain)
                        
                        UserDefaults.standard.synchronize()
                        
                        self.dismiss(animated: true, completion: nil)
                        
                        let serviceHistVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        let navVC = UINavigationController(rootViewController: serviceHistVC)
                        self.present(navVC, animated: true, completion: nil)
                    }
//                }        

            }
            
        }

    }
    
    func gotoNextVC()
    {
        if currentReachabilityStatus != .notReachable
        {
            let revealController: SWRevealViewController? = revealViewController()
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navigationController = UINavigationController(rootViewController: loginVC)
            
            revealController?.pushFrontViewController(navigationController, animated: true)
            
//            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        else
        {
            print("Internet connection FAILED")
            alert()
        }
    }

}
