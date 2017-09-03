//
//  ViewController.swift
//  Timo
//
//  Created by Ha on 7/5/17.
//  Copyright © 2017 Ha. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData
import UserNotifications

class ViewController: UIViewController {
    
    
    //Calendar
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    
    let formatter = DateFormatter()
    
    let outsideMothColor = UIColor(colorWithHexValue: 0x586a66)
    let monthColor = UIColor(colorWithHexValue: 0x0ac0a1)
    let selectedMonthColor = UIColor.white
    
    
    //Pass date
    var time = Timer()
    
    var dateSelected = Date()
    var yearSelected = 0
    var monthSelected = 1
    var daySelected = 1
    var weekdaySelected = 0
    
    @IBAction func addTaskButton(_ sender: Any) {
        
        if ListTaskArrOnDaySelected.count > 15 {
            let alert = UIAlertController(title: "Home", message: "You are too hard on this day!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancer", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        if daySelecte() < Int32(dateCur()){
            let alert = UIAlertController(title: "Home", message: "Selected date is smaller than current date!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancer", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        else{
            
            let calendar = Calendar.current
            yearSelected = calendar.component(.year, from: dateSelected)
            monthSelected = calendar.component(.month, from: dateSelected)
            daySelected = calendar.component(.day, from: dateSelected)
            weekdaySelected = calendar.component(.weekday, from: dateSelected)
            performSegue(withIdentifier: "street1", sender: self)
        }
    }
    

    //Table View
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    var taskData = [ListTask]()
    var ListTaskArrOnDaySelected = [ListTask]()
    
    //thoi gian hien tai doi sang Int
    var timeCurrent:Int16 = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, . sound, .badge], completionHandler: {didAllow, error in})
        
        //Time Current -- kiem tra nhiem vu tung phut 1
        Timer.scheduledTimer(timeInterval: 55, target: self, selector: #selector(ViewController.timeOutHandle), userInfo: nil, repeats: true)
        
        
        //Calendar
        setupCalendarView()
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
        
        
        
        //Table View
        tableView.dataSource = self
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetch()
        
    }
    
    
    //kiem tra tung phut 1
    func timeOutHandle() {
        let calendar = Calendar.current
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        timeCurrent = Int16(hour*60+min)
        for item in taskData {
            
            if item.datePickInt == Int32(dateCur()){
                if item.timeBeginInt == timeCurrent + 3 {
                    let content = UNMutableNotificationContent()
                    content.title = item.nameTask!
                    content.body = "It'll start after 3 minutes!"
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "timeOutHandle", content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { (error) in
                        if let error = error {
                            print("error : \(error)")
                        }
                    }
                }
                if (item.timeBeginInt+item.timeInt) <= timeCurrent+1 {
                    item.timeOutData=true
                }
            }
            
        }
        self.tableView.reloadData()
    }
    
    
    //Calendar
    func setupCalendarView() {
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //Setup labels
        calendarView.visibleDates{ (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
    }
    
    //chinh mau calendar
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {return }

        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        }else{
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            }else {
                validCell.dateLabel.textColor = outsideMothColor
            }
        }
    }
    
    // an hien khi chon 1 ngay
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {return }
        if cellState.isSelected {
            dateSelected = cellState.date
            
            //Xu li thoi gian cua ngay duoc chon
            let calendar = Calendar.current
            yearSelected = calendar.component(.year, from: dateSelected)
            monthSelected = calendar.component(.month, from: dateSelected)
            daySelected = calendar.component(.day, from: dateSelected)
            //Ham xu li loc du lieu cua ngay
            taskOfDateSelected()
            
            validCell.selectedView.isHidden = false
        }else{
            validCell.selectedView.isHidden = true
        }
    }
    
    //thang hien tai
    func setupViewOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Pass date
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "street1" {
            let destVC = segue.destination as! AddTaskViewController
        
            destVC.year = yearSelected
            destVC.month = monthSelected
            destVC.day = daySelected
            destVC.weekday = weekdaySelected
        }
        
    }
    
    //Xac dinh thoi gian duoc chon sang kieu Int
    func daySelecte() -> Int32{
        var res = 0
        var arrMonth:[Int] = [31,28,31,30,31,30,31,31,30,31,30,31]
        var totalDayOfMonth = 0
        for i in 0 ..< monthSelected-1 {
            totalDayOfMonth += arrMonth[i]
        }
        
        if yearSelected%4==0 && monthSelected<=2 {
            res = yearSelected*356+(yearSelected/4) + totalDayOfMonth + daySelected
        }else{
            res = yearSelected*356+(yearSelected/4) + 1 + totalDayOfMonth + daySelected
        }
        return Int32(res)
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


//Table View
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListTaskArrOnDaySelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCellTableViewCell
        
        let task = ListTaskArrOnDaySelected[indexPath.row]
        
        cell.nameTaskLabel.text = task.nameTask!
        cell.commentLabel.text = " " + String(describing: task.comment!)
        cell.timeLabel.text = "Start: " + String(describing: task.timeBeginString!)
        cell.timeBeginLabel.text = "Last: " + String(describing: task.timeString!)
        cell.scoresLabel.text = String((Int(task.timeInt)/10+1))
        
        //To mau ten nhiem vu dang lam trong thoi gian lam
        if ((task.timeInt+task.timeBeginInt) > timeCur() && task.timeBeginInt <= timeCur()) && task.datePickInt == Int32(dateCur()) {
            cell.timeLabel.textColor = UIColor.red
            cell.timeBeginLabel.textColor = UIColor.red
        }else{
            cell.timeLabel.textColor = UIColor(colorWithHexValue: 0x0ac0a1)
            cell.timeBeginLabel.textColor = UIColor(colorWithHexValue: 0x0ac0a1)
        }
        
        
        //Xu li nut accept and give up
        if task.timeOutData == true {
            cell.AcceptOutlet.isHidden = true
            cell.timeOutLabel.isHidden = false
        }else {
            cell.AcceptOutlet.isHidden = false
            cell.timeOutLabel.isHidden = true
        }
        
        if task.acceptData == true {
            cell.ScoresView.backgroundColor = UIColor(colorWithHexValue: 0x0ac0a1)
            cell.timeOutLabel.backgroundColor = UIColor(colorWithHexValue: 0x0ac0a1)
            cell.AcceptOutlet.selectedSegmentIndex = 1
        }else{
            cell.ScoresView.backgroundColor = UIColor(colorWithHexValue: 0x808080)
            cell.timeOutLabel.backgroundColor = UIColor(colorWithHexValue: 0x808080)
            cell.AcceptOutlet.selectedSegmentIndex = 0
        }
        
        cell.AcceptOutlet.tag = indexPath.row
        cell.AcceptOutlet.addTarget(self, action: #selector(AcceptHandle), for: .valueChanged)
        cell.AcceptOutlet.addTarget(self, action: #selector(AcceptHandle), for: .touchUpInside)
        
        return cell
    }
    
    //Xu li accept
    func AcceptHandle(segment: UISegmentedControl) {
        
        if segment.selectedSegmentIndex == 0 {
            ListTaskArrOnDaySelected[segment.tag].acceptData = false
            update(index: segment.tag, accept: false)
        }else{
            ListTaskArrOnDaySelected[segment.tag].acceptData = true
            update(index: segment.tag, accept: true)
        }
        
        self.tableView.reloadData()
    }
    
    
    //Update
    func update(index:Int, accept: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ListTask")
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [ListTask] {
                    
                    if let name = result.value(forKey: "nameTask") as? String, let date = result.value(forKey: "datePickInt") as? Int32 {
                        if name == ListTaskArrOnDaySelected[index].nameTask && date == ListTaskArrOnDaySelected[index].datePickInt{
                            
                            result.setValue(accept, forKey: "acceptData")
                            
                            do {
                                try context.save()
                            }catch{
                                
                            }
                        }
                    }
                    
                }
            }
        }catch {
            
        }
    }
    
    
    //Lay het du lieu ra
    func fetch() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext

        do {
            taskData = try context.fetch(ListTask.fetchRequest())
            for each in taskData {
                if each.nameTask == nil {
                    context.delete(each)
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    //Loc lay du lieu ngay da chon
    func taskOfDateSelected() {
        //Xet lai gia tri
        ListTaskArrOnDaySelected = [ListTask]()
        
        for each in taskData {
            
            if each.nameTask == nil {
                continue
            }
            
            if (((each.timeInt+each.timeBeginInt) < timeCur() && each.datePickInt == Int32(dateCur())) || each.datePickInt < Int32(dateCur())){
                each.timeOutData = true
            }
            
            if each.datePickInt == daySelecte() {
                ListTaskArrOnDaySelected.append(each)
            }
        }
        
        ListTaskArrOnDaySelected = ListTaskArrOnDaySelected.sorted { $0.timeBeginInt+$0.timeInt < $1.timeBeginInt+$1.timeInt }
        self.tableView.reloadData()
    }
    
    
    //Delete (ko cho timeout duoc phep xoa)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if ListTaskArrOnDaySelected[indexPath.row].timeOutData == true || ListTaskArrOnDaySelected[indexPath.row].timeBeginInt <= timeCur() && ListTaskArrOnDaySelected[indexPath.row].datePickInt == Int32(dateCur()){
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if (editingStyle == .delete) {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(self.ListTaskArrOnDaySelected[indexPath.row])
            
            do {
                try context.save()
                self.ListTaskArrOnDaySelected.removeAll()
                self.taskOfDateSelected()
                self.tableView.reloadData()
            }catch {
                print(error)
            }
        }
        
    }

}


//Calendar
extension ViewController: JTAppleCalendarViewDataSource { //setting calendar
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6)
        return parameters
    }
}

extension ViewController: JTAppleCalendarViewDelegate {
    //Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        cell.backgroundColor = UIColor.white
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16)/255.0,
            green: CGFloat((value & 0x00FF00) >> 8)/255.0,
            blue: CGFloat(value & 0x0000FF)/255.0,
            alpha: alpha
        )
    }
}
