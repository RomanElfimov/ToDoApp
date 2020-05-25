//
//  Model.swift
//  ToDo
//
//  Created by Рома on 21.01.2020.
//  Copyright © 2020 Рома. All rights reserved.
//

import Foundation

// MARK: - Public Property

//массив данных - все записи
public var toDoItems: [[String: Any]] {
    //когда пытаемся изменить toDoItems
    set {
        //сохраняием данные
        UserDefaults.standard.set(newValue, forKey: "toDoDataKey")
        UserDefaults.standard.synchronize()
    }
    
    //когда обращаемся к toDoItems
    get {
        //загружаем сохраненные данные
        if let array = UserDefaults.standard.array(forKey: "toDoDataKey") as? [[String: Any]] {
            return array
        } else {
            return []
        }
    }
}

// MARK: - Public Methods

//добавить задачу
func addItem(nameItem: String, isCompleted: Bool = false) {
    toDoItems.append(["Name": nameItem, "isCompleted": false])
}

//удалить задачу
func removeItem(at index: Int){
    toDoItems.remove(at: index)
}

//по нажатию на ячейку меняем состояние isCompeted - выполнено/невыполнено
func changeState(at item: Int) -> Bool {
    toDoItems[item]["isCompleted"] = !(toDoItems[item]["isCompleted"] as? Bool ?? true)
    return toDoItems[item]["isCompleted"] as! Bool
}

func move(fromIndex: Int, toIndex: Int) {
    let from = toDoItems[fromIndex]
    toDoItems.remove(at: fromIndex)
    toDoItems.insert(from, at: toIndex)
}
