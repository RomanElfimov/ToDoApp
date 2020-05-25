//
//  TableViewController.swift
//  ToDo
//
//  Created by Рома on 21.01.2020.
//  Copyright © 2020 Рома. All rights reserved.
//

import UIKit

final class TableViewController: UITableViewController {
    
    //MARK:- Properties
    
    private let orangeColor = UIColor(red: 1, green: 0.4, blue: 0, alpha: 1)
    private let blueColor = UIColor(red: 0, green: 0.7, blue: 255, alpha: 1)
    private let pinkColor = UIColor(red: 0.9, green: 0.5, blue: 0.9, alpha: 0.5)
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //цвет темы
        var myColor: UIColor = .blue
        //сохраненный цвет
        myColor = UserDefaults.standard.colorForKey(key: "myColor") ?? .blue
        //установим сохраненный цвет
        self.navigationController?.navigationBar.barTintColor = myColor
        tableView.separatorColor = myColor
        
        //убрать пустые ячейки внизу
        tableView.tableFooterView = UIView()
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        //нажимаем 1 секунду, срабатывает
        longPressGestureRecognizer.minimumPressDuration = 1
        tableView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    
    //MARK: - Actions
    
    @IBAction func editColorAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Выберите тему", preferredStyle: .alert)
        
        let darkBlue = UIAlertAction(title: "Синяя", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = .blue
            self.tableView.separatorColor = .blue
            
            UserDefaults.standard.setColor(color: UIColor.blue, forKey: "myColor")
            UserDefaults.standard.synchronize()
        }
        let orange = UIAlertAction(title: "Оранжевая", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = self.orangeColor
            self.tableView.separatorColor = self.orangeColor
            
            UserDefaults.standard.setColor(color: self.orangeColor, forKey: "myColor")
            UserDefaults.standard.synchronize()
        }
        let blue = UIAlertAction(title: "Голубая", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = self.blueColor
            self.tableView.separatorColor = self.blueColor
            
            UserDefaults.standard.setColor(color: self.blueColor, forKey: "myColor")
            UserDefaults.standard.synchronize()
        }
        let green = UIAlertAction(title: "Зеленая", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = .green
            self.tableView.separatorColor = .green
            
            UserDefaults.standard.setColor(color: UIColor.green, forKey: "myColor")
            UserDefaults.standard.synchronize()
        }
        let red = UIAlertAction(title: "Красная", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = .red
            self.tableView.separatorColor = .red
            
            UserDefaults.standard.setColor(color: UIColor.red, forKey: "myColor")
            UserDefaults.standard.synchronize()
        }
        let pink = UIAlertAction(title: "Розовая", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = self.pinkColor
            self.tableView.separatorColor = self.pinkColor
            
            UserDefaults.standard.setColor(color: self.pinkColor, forKey: "myColor")
            UserDefaults.standard.synchronize()
        }
        let purple = UIAlertAction(title: "Фиолетовая", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = .purple
            self.tableView.separatorColor = .purple
            
            UserDefaults.standard.setColor(color: UIColor.purple, forKey: "myColor")
            UserDefaults.standard.synchronize()
        }
        
        alert.addAction(darkBlue)
        alert.addAction(orange)
        alert.addAction(blue)
        alert.addAction(green)
        alert.addAction(red)
        alert.addAction(pink)
        alert.addAction(purple)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pushAddAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Добавить новую задачу", preferredStyle: .alert)
        //кнопка добавить
        let action = UIAlertAction(title: "Добавить", style: .cancel) { (action) in
            //добавить новую запись
            let textFromField = alert.textFields![0].text
            if textFromField != "" {
                //добавить новую запись
                guard let newItem = textFromField else {return}
                addItem(nameItem: newItem)
                self.tableView.reloadData()
            }
        }
        //кнопка отменить
        let cancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        //текстовое поле
        alert.addTextField { (textField) in
            textField.placeholder = "Новая задача"
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pushEditAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        //обновляем таблицу, спустя, как анимация таблицы закончится (через 0.3 сек)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }

    
    //MARK: - Selector
    //отработка долгого нажатия для изменения
    @objc func handleLongPress(longPress: UILongPressGestureRecognizer) {
        
        let pointOfTouch = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: pointOfTouch)
        
        if longPress.state == .began {
            if let indexPath = indexPath {
                let alert = UIAlertController(title: "Изменить", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Писать тут"
                    textField.text = toDoItems[indexPath.row]["Name"] as? String
                }
                
                let alertActionCreate = UIAlertAction(title: "Обновить", style: UIAlertAction.Style.cancel) {  (UIAlertAction) in
                    if alert.textFields![0].text != "" {
                        toDoItems[indexPath.row]["Name"] = alert.textFields![0].text!
                        self.tableView.reloadData()
                    }
                }
                let alertActionCansel = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.destructive) {(UIAlertAction)
                    in
                }
                alert.addAction(alertActionCreate)
                alert.addAction(alertActionCansel)
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    //MARK: - Configure cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentItem = toDoItems[indexPath.row]
        cell.textLabel?.text = currentItem["Name"] as? String
        
        //если задача выполнена
        //получаем значения из словаря по ключу
        if (currentItem["isCompleted"] as? Bool) == true {
            
            cell.imageView?.image = UIImage(named: "check")
            //делаем текст серым
            cell.textLabel?.textColor = .lightGray
            //зачеркиваем
            let attributeString = NSMutableAttributedString(string: (currentItem["Name"] as? String)!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1.5, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        } else {
            cell.imageView?.image = UIImage(named: "uncheck")
            cell.textLabel?.textColor = .black
            let attributeString = NSMutableAttributedString(string: (currentItem["Name"] as? String)!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        }
        
        //затемнение в режиме редактирвания
        if tableView.isEditing {
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
        } else {
            cell.textLabel?.alpha = 1
            cell.imageView?.alpha = 1
        }
        
        return cell
    }
    
    
    //MARK: - Delete
    //Разрешаем редактировать таблицу
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //что происходит при редактирвании таблицы
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //если удалить
        if editingStyle == .delete {
            removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //если вставить
        } else if editingStyle == .insert {
            
        }    
    }
    
    //стиль кнопки удалить
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    //MARK: - Select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //для плавной анимации
        if changeState(at: indexPath.row) {
            
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "check")
            tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .lightGray
            //зачеркиваем
            let attributeString = NSMutableAttributedString(string: (toDoItems[indexPath.row]["Name"] as? String)!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1.5, range: NSMakeRange(0, attributeString.length))
            tableView.cellForRow(at: indexPath)?.textLabel?.attributedText = attributeString
        } else {
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "uncheck")
            tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .darkGray
            let attributeString = NSMutableAttributedString(string: (toDoItems[indexPath.row]["Name"] as? String)!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            tableView.cellForRow(at: indexPath)?.textLabel?.attributedText = attributeString
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Move
    
    //Меняем записи местами
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //fromIndexPath - откуда взяли ячейку
        //to - туда, куда перетащили ячейку
        move(fromIndex: fromIndexPath.row, toIndex: to.row)
        
        tableView.reloadData()
    }
    
    //стиль таблицы в режиме редактирования
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .none
        }
        return .delete
    }
    
    //стоит ли смещать элементы ячейки в режиме редактирования
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

//MARK: - Extension UserDefaults
extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
}
