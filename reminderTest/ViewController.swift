//
//  ViewController.swift
//  reminderTest
//
//  Created by Yuki Shinohara on 2020/06/08.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var models = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func didTapAdd(_ sender: Any) {
//        移動先の画面を指定
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {return}
//        移動先の変数に代入
        vc.title = "New reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
//        AddViewControllerのdidTapSaveBtnで値が代入されており、その値をここで使う
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.tableView.reloadData()
//                通知の設定
                let content = UNMutableNotificationContent()
                        content.title = title
                        content.sound = .default
                        content.body = body
                        
                //        通知タイミング
                        let targetDate = date
                        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,
                                                                                                                   .month,
                                                                                                                   .day,
                                                                                                                   .hour,
                                                                                                                   .minute,
                                                                                                                   .second],
                                                                                                                  from: targetDate),
                                                                    repeats: false)
                        
                        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
                            error in
                            if error != nil{
                                print(error?.localizedDescription as Any)
                            }
                            //エラーがなければrequestが通る
                        })
            }
        }
//        移動先へプッシュ
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapTest(_ sender: Any) {
//        Notificationの許可を得る
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                self.scheduleTest()
            }else if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
//    Notificationを通知する処理
    func scheduleTest(){
//        表示するところ
        let content = UNMutableNotificationContent()
        content.title = "Test"
        content.sound = .default
        content.body = "This is a notification test"
        
//        通知タイミング
        let targetDate = Date().addingTimeInterval(5)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,
                                                                                                   .month,
                                                                                                   .day,
                                                                                                   .hour,
                                                                                                   .minute,
                                                                                                   .second],
                                                                                                  from: targetDate),
                                                    repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
            if error != nil{
                print(error?.localizedDescription as Any)
            }
            //エラーがなければrequestが通る
        })
    
    }
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
}

struct MyReminder {
    let title: String
    let date: Date
    let identifier: String
}
