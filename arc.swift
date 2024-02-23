// Описать несколько структур – любой легковой автомобиль и любой грузовик. Структуры должны содержать марку авто, год выпуска, объем багажника/кузова, запущен ли двигатель, открыты ли окна, заполненный объем багажника
// Описать перечисление с возможными действиями с автомобилем: запустить/заглушить двигатель, открыть/закрыть окна, погрузить/выгрузить из кузова/багажника груз определенного объема
// Добавить в структуры метод с одним аргументом типа перечисления, который будет менять свойства структуры в зависимости от действия
// Инициализировать несколько экземпляров структур. Применить к ним различные действия. Положить объекты структур в словарь как ключи, а их названия как строки например var dict = [structCar: 'structCar']
struct Car: Hashable 
{
    var brand: String
    var year: Int
    var trunk_capacity: Double
    var is_engine_on: Bool
    var are_windows_open: Bool
    var trunk_load: Double
    
    mutating func performAction(action: CarAction) 
    {
        switch action 
        {
            case .startEngine:
                is_engine_on = true
            case .stopEngine:
                is_engine_on = false
            case .openWindows:
                are_windows_open = true
            case .closeWindows:
                are_windows_open = false
            case let .loadTrunk(volume):
                trunk_load += volume
        }
    }
}


struct Truck: Hashable 
{
    var brand: String
    var year: Int
    var truck_capacity: Double
    var is_engine_on: Bool
    var are_windows_open: Bool
    var truck_load: Double
    
    mutating func performAction(action: TruckAction) 
    {
        switch action 
        {
            case .startEngine:
                is_engine_on = true
            case .stopEngine:
                is_engine_on = false
            case .openWindows:
                are_windows_open = true
            case .closeWindows:
                are_windows_open = false
            case let .loadTruck(volume):
                truck_load += volume
            case let .unloadTruck(volume):
                truck_load -= volume
        }
    }
}

enum CarAction 
{
    case startEngine
    case stopEngine
    case openWindows
    case closeWindows
    case loadTrunk(Double)
}

enum TruckAction 
{
    case startEngine
    case stopEngine
    case openWindows
    case closeWindows
    case loadTruck(Double)
    case unloadTruck(Double)
}

var car = Car(brand: "Ford", year: 2017, trunk_capacity: 300, is_engine_on: false, are_windows_open: false, trunk_load: 0)
var truck = Truck(brand: "Kamaz", year: 2008, truck_capacity: 1000, is_engine_on: false, are_windows_open: false, truck_load: 0)

car.performAction(action: CarAction.startEngine)
car.performAction(action: CarAction.openWindows)
car.performAction(action: CarAction.loadTrunk(100))

truck.performAction(action: TruckAction.startEngine)
truck.performAction(action: TruckAction.loadTruck(800))
truck.performAction(action: TruckAction.openWindows)

// Помещение объектов структур в словарь
var dict: [AnyHashable: String] = [:]
dict[car] = "car"
dict[truck] = "truck"
print(dict)

// Почитать о Capture List (см ссылку ниже) - и описать своими словами и сделать скрин своего примера и объяснения Capture
// Сapture lists используются для захвата значений в замыканиях и могут быть объявлены как strong, weak или unowned. 

// 1.Strong References: Используются по умолчанию. Замыкание будет удерживать любые внешние значения, используемые внутри замыкания, и гарантировать, что они не будут уничтожены.

// Пример:
// var closure: (() -> Void)?

// func someFunction() {
//     let message = "Hello"
//     closure = {
//         print(message)
//     }
// }

// 2. Weak References: При Weak захвате значениям могут быть уничтожены или установленны в nil. 
// Пример:
// var closure: (() -> Void)?

// func someFunction() {
//     let message = "Hello"
//     closure = { [weak message] in
//         print(message)
//     }
// }

// 3. Unowned References: Значения могут стать nil в любой момент, но их можно продолжать использовать, как если бы они всегда были доступны.

// Пример:
// var closure: (() -> Void)?

// func someFunction() {
//     let message = "Hello"
//     closure = { [unowned message] in
//         print(message)
//     }
// }

// Набрать код который на скриншоте понять в чем там проблема и решить эту проблему
//Изменим "var driver: Man?" на "weak var driver: Man?".
class Car {

    weak var driver: Man?
    deinit{
      print("машина удалена из памяти")   
    }
}

class Man {  
    var myCar: Car? 
    deinit{
        print("мужчина удален из памяти")  
    }
    
}

var car: Car? = Car()
var man: Man? = Man()
car?.driver=man
man?.myCar=car

car = nil
man = nil

//У нас есть класс мужчины и его паспорта. Мужчина может родиться и не иметь паспорта, но паспорт выдается конкретному мужчине и не может выдаваться без указания владельца. Чтобы разрешить эту проблему, ссылку на паспорт у мужчины сделаем опциональной, а ссылку на владельца у паспорта – константой. Также добавим паспорту конструктор, чтобы сразу определить его владельца. Таким образом, человек сможет существовать без паспорта, сможет его поменять или выкинуть, но паспорт может быть создан только с конкретным владельцем и никогда не может его сменить. Повторить все что на черном скрине и решить проблему соблюдая все правила!

class Man {
  var pasport: (() -> Passport?)? 
  deinit {
    print("мужчина удален из памяти")
  }
}

class Passport {
  let man: Man
  init(man: Man){
      self.man = man
  }
  deinit {
      print("паспорт удален из памяти")
  }
}

var man: Man? = Man()
var passport: Passport? = Passport(man: man!)
man?.pasport = { [weak passport] in
  return passport 
}
passport = nil
man = nil
