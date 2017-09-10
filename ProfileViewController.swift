//
//  ProfileViewController.swift
//  Timo
//
//  Created by Ha on 8/1/17.
//  Copyright © 2017 Ha. All rights reserved.
//

import UIKit
import CoreData
import UICircularProgressRing
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    //Link den Leaderboard
    @IBAction func gimoButton(_ sender: Any) {
        if let url = URL(string: "http://ec2-52-89-58-97.us-west-2.compute.amazonaws.com:8080/") {
            UIApplication.shared.openURL(url)
        }
    }
    
    //Ket noi voi facebook
    let fblogin:FBSDKLoginManager = FBSDKLoginManager()
    
    @IBAction func updateButton(_ sender: Any) {
        update()
    }
    
    var scores:Int64 = 0
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var profileLabel: CardView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var progressView: UICircularProgressRingView!
    @IBOutlet weak var doneLabel: UILabel!
    var done = 0
    @IBOutlet weak var notDoneLabel: UILabel!
    var notdone = 0
    
    
    //Luu bien Position

    var position:Int32 = 0
    
    @IBOutlet weak var tableViewProfile: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    var taskDataProfile = [ListTask]()
    var ListTaskProfile = [ListTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View, lay du lieu
        tableViewProfile.dataSource = self
        fetchProfile()
        taskOfDateSelected()
        
        //Chinh doan o tren
        scoresLabel.text = String(scores)
        doneLabel.text = String(done)
        notDoneLabel.text = String(notdone)
        
        //Lay gia tri position da luu
        if UserDefaults.standard.value(forKey: "position") != nil {
            position = UserDefaults.standard.value(forKey: "position") as! Int32
        }
        positionLabel.text = String(position)
        
        var pt = 100
        if !(done == 0 && notdone == 0) {
            pt = done*100/(done+notdone)
        }
        progressView.setProgress(value: CGFloat(pt), animationDuration: 1)
    
        
        //Dai mau va cap
        if scores <= 5 {
            levelLabel.text = "0"
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0xafafaf) //Xam
        }
        if scores <= 60 && scores > 5{
            levelLabel.text = String(scores/10)
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0x0ac0a1) //Xanh nhat
        }
        if scores <= 150 && scores > 60{
            levelLabel.text = String(scores/10)
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0x21bcce) //Xanh dam
        }
        if scores <= 600 && scores > 150{
            levelLabel.text = String(scores/10)
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0xfeb100) //Cam
        }
        if scores <= 1500 && scores > 600{
            levelLabel.text = String((scores-600)/100 + 600/10)
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0xfffb00) //Vang
        }
        if scores <= 3000 && scores > 1500{
            levelLabel.text = String((scores-600)/100 + 600/10)
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0x7423ab) //Tim
        }
        if scores <= 6000 && scores > 3000{
            levelLabel.text = String((scores-600)/100 + 600/10)
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0x008242) //Xanh duong dam
        }
        if scores <= 12000 && scores > 6000{
            levelLabel.text = String((scores-6000)/1000 + (6000-600)/100 + 600/10)
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0xad3d2b) //Do dam
        }
        if scores <= 24000 && scores > 12000{
            levelLabel.text = String((scores-6000)/1000 + (6000-600)/100 + 600/10)
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0x003120) //Xanh la dam
        }
        if scores <= 48000 && scores > 24000{
            levelLabel.text = String((scores-6000)/1000 + (6000-600)/100 + 600/10)
            profileLabel.backgroundColor = UIColor(colorWithHexValue: 0x1f1a4b) //Tim than
        }
        if scores > 48000{
            levelLabel.text = String((scores-48000)/10000+(48000-6000)/1000 + (6000-600)/100 + 600/10)
            profileLabel.backgroundColor = UIColor.black //Den
        }  
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Phan xu li update thong tin
    //Dang nhap facebook
    func update(){
        fblogin.logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err == nil {
                let fbloginresult:FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    self.getData()
                }
            }else{

            }
        }
    }
    
    //Lay thong tin nguoi dung
    func getData(){
        
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name,location,email"]).start(completionHandler: { (connect, result, err) in
                if err == nil {
                    var dict = result as! Dictionary<String,Any>
                    
                    var location = "Node"
                    if dict["location"] != nil{
                        
                        //Xu li chuoi lay moi country
                        var loc1 = dict["location"] as! String
                        var flag = 0
                        for i in 0..<loc1.characters.count{
                            if loc1[loc1.index(loc1.startIndex, offsetBy: i)] == "," {
                                flag = i
                            }
 
                        }
                        let index = loc1.index(loc1.startIndex, offsetBy: flag+2)
                        location = loc1.substring(from: index)
                        
                    }
                    
                    self.sendjson(email: dict["email"] as! String, name: dict["name"] as! String, scores: self.scores, location: location)
                }
            })
        }
    }
    
    //POST den server
    func sendjson(email: String, name: String, scores: Int64, location: String) {
        //Stuct Member
        let member = ["Name": name, "Scores": scores, "Email": email, "Country": location] as [String : Any]

        //Chuyen sang thanh json
        let jsonMember = try? JSONSerialization.data(withJSONObject: member, options: .prettyPrinted)
        
        //Tao URL
        let urlString = "http://ec2-52-89-58-97.us-west-2.compute.amazonaws.com:8080/member"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonMember
        
        //Tao Session
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])

                    let pos = json as! Dictionary<String,Any>
                    if pos["Position"] != nil {
                        self.position = pos["Position"] as! Int32
                        self.positionLabel.text = String(self.position)
                        
                        //Luu bien position
                        UserDefaults.standard.set(self.position, forKey: "position")
                    }
                    
                    //Tao thong bao
                    let alert = UIAlertController(title: "Update", message: "Your position is " + String(self.position), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancer", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }catch{
                    print(error)
                }
            }
            
        }.resume()
    }
    
    
    
    //Xac dinh thoi gian hien tai sang kieu Int
    func dateCur() -> Int {
        var dateCur = 0
        let calendar = Calendar.current
        let date = Date()
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        var arrMonth:[Int] = [31,28,31,30,31,30,31,31,30,31,30,31]
        var totalDayOfMonth = 0
        for i in 0 ..< month-1 {
            totalDayOfMonth += arrMonth[i]
        }
        
        if year%4==0 && month<=2 {
            dateCur = year*356+(year/4) + totalDayOfMonth + day
        }else{
            dateCur = year*356+(year/4) + 1 + totalDayOfMonth + day
        }
        
        return dateCur
    }
    
    func timeCur() -> Int16 {
        var timeCurr:Int16 = 0
        let calendar = Calendar.current
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        timeCurr = Int16(hour*60+min)
        
        return timeCurr
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListTaskProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellProfile = tableViewProfile.dequeueReusableCell(withIdentifier: "cellProfile", for: indexPath) as! TaskCellProfileTableViewCell
        
        let failTask = ListTaskProfile[indexPath.row]
        
        cellProfile.nameLabelProfile.text = failTask.nameTask!
        cellProfile.commentProfile.text = " " + String(describing: failTask.comment!)
        cellProfile.startLabel.text = "Start: " + String(describing: failTask.timeBeginString!)
        cellProfile.timeLabelProfile.text = "Time: " + String(describing: failTask.timeString!)
        cellProfile.scoresLabelProfile.text = String(Int(failTask.timeInt/10)+1)
        
        if Int32(dateCur()) - failTask.datePickInt == 0 {
            cellProfile.numberDateLabel.text = "To day"
        }else{
            cellProfile.numberDateLabel.text = String(Int32(dateCur()) - failTask.datePickInt)+" day ago"
        }
        return cellProfile
    }
    
    //Lay du lieu
    func fetchProfile() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        do {
            taskDataProfile = try context.fetch(ListTask.fetchRequest())
            for each in taskDataProfile {
                
                if each.nameTask == nil {
                    context.delete(each)
                }
                
            }
            
        } catch {
            
        }
        
    }
    
    
    //Loc lay du lieu trong 7 ngay
    func taskOfDateSelected() {
        
        for each in taskDataProfile {
            
            if each.nameTask == nil {
                continue
            }
            
            if ((each.datePickInt > Int32(dateCur())-7 && each.datePickInt < Int32(dateCur())) || (each.datePickInt == Int32(dateCur()) && (each.timeInt+each.timeBeginInt) < timeCur())) && each.acceptData == false{
                ListTaskProfile.append(each)
            }
            
            if (((each.timeInt+each.timeBeginInt) < timeCur() && each.datePickInt == Int32(dateCur())) || each.datePickInt < Int32(dateCur())){
                
                each.timeOutData = true
                if each.acceptData == true {
                    scores += (Int(each.timeInt)/10+1)
                }else{
                    scores -= (Int(each.timeInt)/10+1)
                }
            }
            
            if each.timeOutData == true {
                if each.acceptData == true {
                    done += 1
                }
                if each.acceptData == false {
                    notdone += 1
                }
            }
        }
        
        ListTaskProfile = ListTaskProfile.sorted { $0.datePickInt > $1.datePickInt }
    }
    
}
