//
//  AddTaskViewController.swift
//  Timo
//
//  Created by Ha on 7/19/17.
//  Copyright © 2017 Ha. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {
    
    //Data
    var dateOfDataInt = 0
    
    //Pass date
    var year = 0
    var month = 0
    var day = 0
    var weekday = 0
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dateSelectedLabel: UILabel!
    
    
    //name
    @IBOutlet weak var nameTask: UITextField!
    //comment
    @IBOutlet weak var comment: UITextField!
    //TimeBegin
    @IBOutlet weak var labelTimeBegin: UILabel!
    @IBOutlet weak var timeBegin: UIDatePicker!
    //Time
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var labelTime: UILabel!
    
    //repeat
    var mondayPick = false
    var tuesdayPick = false
    var wednesdayPick = false
    var thursdayPick = false
    var fridayPick = false
    var saturdayPick = false
    var sundayPick = false
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBAction func monday(_ sender: Any) {
        mondayPick = !mondayPick
        if mondayPick == true {
            mondayButton.backgroundColor = UIColor(colorWithHexValue: 0x0cd1ae)
            mondayButton.layer.cornerRadius = 18
        }else{
            mondayButton.backgroundColor = UIColor.white
        }
            
    }

    @IBOutlet weak var tuesdayButton: UIButton!
    @IBAction func tuesday(_ sender: Any) {
        tuesdayPick = !tuesdayPick
        if tuesdayPick == true {
            tuesdayButton.backgroundColor = UIColor(colorWithHexValue: 0x0cd1ae)
            tuesdayButton.layer.cornerRadius = 18
        }else{
            tuesdayButton.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBAction func wednesday(_ sender: Any) {
        wednesdayPick = !wednesdayPick
        if wednesdayPick == true {
            wednesdayButton.backgroundColor = UIColor(colorWithHexValue: 0x0cd1ae)
            wednesdayButton.layer.cornerRadius = 18
        }else{
            wednesdayButton.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var thursdayButton: UIButton!
    @IBAction func thursday(_ sender: Any) {
        thursdayPick = !thursdayPick
        if thursdayPick == true {
            thursdayButton.backgroundColor = UIColor(colorWithHexValue: 0x0cd1ae)
            thursdayButton.layer.cornerRadius = 18
        }else{
            thursdayButton.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var fridayButton: UIButton!
    @IBAction func friday(_ sender: Any) {
        fridayPick = !fridayPick
        if fridayPick == true {
            fridayButton.backgroundColor = UIColor(colorWithHexValue: 0x0cd1ae)
            fridayButton.layer.cornerRadius = 18
        }else{
            fridayButton.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var saturdayButton: UIButton!
    @IBAction func saturday(_ sender: Any) {
        saturdayPick = !saturdayPick
        if saturdayPick == true {
            saturdayButton.backgroundColor = UIColor(colorWithHexValue: 0x0cd1ae)
            saturdayButton.layer.cornerRadius = 18
        }else{
            saturdayButton.backgroundColor = UIColor.white
        }
    }

    @IBOutlet weak var sundayButton: UIButton!
    @IBAction func sunday(_ sender: Any) {
        sundayPick = !sundayPick
        if sundayPick == true {
            sundayButton.backgroundColor = UIColor(colorWithHexValue: 0x0cd1ae)
            sundayButton.layer.cornerRadius = 18
        }else{
            sundayButton.backgroundColor = UIColor.white
        }
    }
    
    

    @IBAction func time(_ sender: Any) {
        labelTime.text = HandleTimeString()
    }
    
    @IBAction func timeBegin(_ sender: Any) {
        labelTimeBegin.text = HandleTimeBeginString()
    }
    
    //add
    @IBAction func addTask(_ sender: Any) {
        
        if nameTask?.text == ""{
            let alert = UIAlertController(title: "Add Task", message: "What's task's name?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancer", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if HandleTimeInt(x: timeBegin.date) < timeCur() && dateOfDataInt == dateCur(){
            
            let alert = UIAlertController(title: "Add Task", message: "Start time is smaller than current time!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancer", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
            let context = appDelegate.persistentContainer.viewContext
        
            let newTask1 = NSEntityDescription.insertNewObject(forEntityName: "ListTask", into: context)
        
            newTask1.setValue(nameTask.text, forKey: "nameTask")
            newTask1.setValue(comment.text, forKey: "comment")
            newTask1.setValue(HandleTimeInt(x: timeBegin.date), forKey: "timeBeginInt")
            newTask1.setValue(checkTime(), forKey: "timeInt")
            newTask1.setValue(dateOfDataInt, forKey: "datePickInt")
            newTask1.setValue(HandleTimeBeginString(), forKey: "timeBeginString")
            newTask1.setValue(HandleTimeString(), forKey: "timeString")
            newTask1.setValue(false, forKey: "acceptData")
            newTask1.setValue(false, forKey: "timeOutData")
            
            
            //Lap lai vao thu 2 (xu li lap)
            if mondayPick == true {
                let newTask2 = NSEntityDescription.insertNewObject(forEntityName: "ListTask", into: context)
                var a = 0
                if weekday>=2 {
                    a = (8-weekday)+1
                }else {
                    a = 2 - weekday
                }
                newTask2.setValue(nameTask.text, forKey: "nameTask")
                newTask2.setValue(comment.text, forKey: "comment")
                newTask2.setValue(HandleTimeInt(x: timeBegin.date), forKey: "timeBeginInt")
                newTask2.setValue(checkTime(), forKey: "timeInt")
                newTask2.setValue(dateOfDataInt + a, forKey: "datePickInt")
                newTask2.setValue(HandleTimeBeginString(), forKey: "timeBeginString")
                newTask2.setValue(HandleTimeString(), forKey: "timeString")
                newTask2.setValue(false, forKey: "acceptData")
                newTask2.setValue(false, forKey: "timeOutData")
                do {
                    try context.save()
                }catch{
                    print(error)
                }
            }
            
            //thu 3
            if tuesdayPick == true {
                let newTask3 = NSEntityDescription.insertNewObject(forEntityName: "ListTask", into: context)
                var a = 0
                if weekday>=3 {
                    a = (8-weekday)+2
                }else {
                    a = 3 - weekday
                }
                newTask3.setValue(nameTask.text, forKey: "nameTask")
                newTask3.setValue(comment.text, forKey: "comment")
                newTask3.setValue(HandleTimeInt(x: timeBegin.date), forKey: "timeBeginInt")
                newTask3.setValue(checkTime(), forKey: "timeInt")
                newTask3.setValue(dateOfDataInt + a, forKey: "datePickInt")
                newTask3.setValue(HandleTimeBeginString(), forKey: "timeBeginString")
                newTask3.setValue(HandleTimeString(), forKey: "timeString")
                newTask3.setValue(false, forKey: "acceptData")
                newTask3.setValue(false, forKey: "timeOutData")
                do {
                    try context.save()
                }catch{
                    print(error)
                }
            }
            
            //thu 4
            if wednesdayPick == true {
                let newTask4 = NSEntityDescription.insertNewObject(forEntityName: "ListTask", into: context)
                var a = 0
                if weekday>=4 {
                    a = (8-weekday)+3
                }else {
                    a = 4 - weekday
                }
                newTask4.setValue(nameTask.text, forKey: "nameTask")
                newTask4.setValue(comment.text, forKey: "comment")
                newTask4.setValue(HandleTimeInt(x: timeBegin.date), forKey: "timeBeginInt")
                newTask4.setValue(checkTime(), forKey: "timeInt")
                newTask4.setValue(dateOfDataInt + a, forKey: "datePickInt")
                newTask4.setValue(HandleTimeBeginString(), forKey: "timeBeginString")
                newTask4.setValue(HandleTimeString(), forKey: "timeString")
                newTask4.setValue(false, forKey: "acceptData")
                newTask4.setValue(false, forKey: "timeOutData")
                do {
                    try context.save()
                }catch{
                    print(error)
                }
            }
            
            //thu 5
            if thursdayPick == true {
                let newTask5 = NSEntityDescription.insertNewObject(forEntityName: "ListTask", into: context)
                var a = 0
                if weekday>=5 {
                    a = (8-weekday)+4
                }else {
                    a = 5 - weekday
                }
                newTask5.setValue(nameTask.text, forKey: "nameTask")
                newTask5.setValue(comment.text, forKey: "comment")
                newTask5.setValue(HandleTimeInt(x: timeBegin.date), forKey: "timeBeginInt")
                newTask5.setValue(checkTime(), forKey: "timeInt")
                newTask5.setValue(dateOfDataInt + a, forKey: "datePickInt")
                newTask5.setValue(HandleTimeBeginString(), forKey: "timeBeginString")
                newTask5.setValue(HandleTimeString(), forKey: "timeString")
                newTask5.setValue(false, forKey: "acceptData")
                newTask5.setValue(false, forKey: "timeOutData")
                do {
                    try context.save()
                }catch{
                    print(error)
                }
            }
            
            //thu 6
            if fridayPick == true {
                let newTask6 = NSEntityDescription.insertNewObject(forEntityName: "ListTask", into: context)
                var a = 0
                if weekday>=6 {
                    a = (8-weekday)+5
                }else {
                    a = 6 - weekday
                }
                newTask6.setValue(nameTask.text, forKey: "nameTask")
                newTask6.setValue(comment.text, forKey: "comment")
                newTask6.setValue(HandleTimeInt(x: timeBegin.date), forKey: "timeBeginInt")
                newTask6.setValue(checkTime(), forKey: "timeInt")
                newTask6.setValue(dateOfDataInt + a, forKey: "datePickInt")
                newTask6.setValue(HandleTimeBeginString(), forKey: "timeBeginString")
                newTask6.setValue(HandleTimeString(), forKey: "timeString")
                newTask6.setValue(false, forKey: "acceptData")
                newTask6.setValue(false, forKey: "timeOutData")
                do {
                    try context.save()
                }catch{
                    print(error)
                }
            }
            
            //thu 7
            if saturdayPick == true {
                let newTask7 = NSEntityDescription.insertNewObject(forEntityName: "ListTask", into: context)
                var a = 0
                if weekday>=7 {
                    a = (8-weekday)+6
                }else {
                    a = 7 - weekday
                }
                newTask7.setValue(nameTask.text, forKey: "nameTask")
                newTask7.setValue(comment.text, forKey: "comment")
                newTask7.setValue(HandleTimeInt(x: timeBegin.date), forKey: "timeBeginInt")
                newTask7.setValue(checkTime(), forKey: "timeInt")
                newTask7.setValue(dateOfDataInt + a, forKey: "datePickInt")
                newTask7.setValue(HandleTimeBeginString(), forKey: "timeBeginString")
                newTask7.setValue(HandleTimeString(), forKey: "timeString")
                newTask7.setValue(false, forKey: "acceptData")
                newTask7.setValue(false, forKey: "timeOutData")
                do {
                    try context.save()
                }catch{
                    print(error)
                }
            }
            
            //chu nhat
            if sundayPick == true {
                let newTask8 = NSEntityDescription.insertNewObject(forEntityName: "ListTask", into: context)
                var a = 0
                if weekday>=8 {
                    a = (8-weekday)+7
                }else {
                    a = 8 - weekday
                }
                newTask8.setValue(nameTask.text, forKey: "nameTask")
                newTask8.setValue(comment.text, forKey: "comment")
                newTask8.setValue(HandleTimeInt(x: timeBegin.date), forKey: "timeBeginInt")
                newTask8.setValue(checkTime(), forKey: "timeInt")
                newTask8.setValue(dateOfDataInt + a, forKey: "datePickInt")
                newTask8.setValue(HandleTimeBeginString(), forKey: "timeBeginString")
                newTask8.setValue(HandleTimeString(), forKey: "timeString")
                newTask8.setValue(false, forKey: "acceptData")
                newTask8.setValue(false, forKey: "timeOutData")
                do {
                    try context.save()
                }catch{
                    print(error)
                }
            }
            
            
            do {
                try context.save()
            }catch{
                print(error)
            }
            
            let alert = UIAlertController(title: "Add Task", message: "Done!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancer", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Pass date
        let dateSelecteString = String(month) + "-" + String(day) + "-" + String(year)
        dateSelectedLabel.text = "Add task on " + dateSelecteString
        
        //Setup TimeBegin and time
        labelTimeBegin.text = HandleTimeBeginString()
        
        labelTime.text = HandleTimeString()
        
        
        //Data
        var arrMonth:[Int] = [31,28,31,30,31,30,31,31,30,31,30,31]
        var totalDayOfMonth = 0
        for i in 0 ..< month-1 {
            totalDayOfMonth += arrMonth[i]
        }
        
        if year%4==0 && month<=2 {
            dateOfDataInt = year*356+(year/4) + totalDayOfMonth + day
        }else{
            dateOfDataInt = year*356+(year/4) + 1 + totalDayOfMonth + day
        }
        
        //week day label
        let weekdayArr:[String] = ["Monday", "Tuesday", "Wednesday","Thursday","Friday","Saturday","Sunday"]
        weekdayLabel.text = "Selected day is " + weekdayArr[weekday-2]
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Handle TimeBegin and Time
    func HandleTimeInt(x: Date) -> Int{
        var res = 0
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: x)
        let minute = calendar.component(.minute, from: x)
        
        res = hour*60+minute
        return res
    }
    
    func HandleTimeBeginString() -> String {
        var res = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        res = formatter.string(from: timeBegin.date)
        
        return res
    }
    
    func HandleTimeString() -> String {
        var res = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        res = formatter.string(from: time.date)
        
        return res
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
    
    func timeCur() -> Int {
        var timeCurr = 0
        let calendar = Calendar.current
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        timeCurr = hour*60+min
        
        return timeCurr
    }
    
    //Kiem tra co het ngay khong 
    func checkTime() ->Int{
        let res = HandleTimeInt(x: time.date) + HandleTimeInt(x: timeBegin.date)
        if res < 1440 {
            return HandleTimeInt(x: time.date)
        }
        return 1440 - HandleTimeInt(x: timeBegin.date)
    }


}
