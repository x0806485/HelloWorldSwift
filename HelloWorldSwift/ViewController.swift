//
//  ViewController.swift
//  HelloWorldSwift
//
//  Created by baihemiyu001 on 16/10/17.
//  Copyright © 2016年 zjc. All rights reserved.
//

import UIKit

class NamedShape {
    var numberOfSides: Double = 0
    var name: String
    init(name: String) {
        self.name = name
    }
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    var perimeter: Double {
        get {
            return 3*numberOfSides
        }
        set  {
            numberOfSides = newValue/3.0
        }
    }
}

class Square: NamedShape {
    var sideLength: Double //如果不是可选类型 必须在初始化中初始化
    init(sideLength: Double ,name: String) {
        self.sideLength = sideLength
        //子类有初始化方法，必须调用弗雷的初始化方法
        super.init(name: "")
        //给父类的属性赋值，必须先调用父类的初始化方法
        numberOfSides = 4
    }
    func area() -> Double {
        return sideLength * sideLength
    }
    override func simpleDescription() -> String {
        return "override super method"
    }
}

class ObserveProperty {
    var mySquare: Square {
        willSet {
            mySquare.sideLength = newValue.sideLength
        }
    }
    init(size: Double) {
        mySquare = Square(sideLength: size, name:"ac")
    }
//    func simpleDescription() -> String {
//        let level: Rank = .ace
//        return String(level)
//    }
}

//枚举和结构体内部都可以定义方法
enum Rank: Int {
    case ace = 1
    case two, three, four, five
    case jack, queen, king
    
    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        default:
            return String(self.rawValue)
        }
    }
}

enum objectEnum{
    case Card
    
}

struct Card {
    var rank: Rank
    func simpleDescription() -> String {
        return "abc"
    }
}

//协议(不仅能在class中实现，还可以在struct、enum)
//属性和方法都要实现
protocol ExampleProtocol {
    //协议里的属性要指定get或者get、set方法
    var simpleDescription: String {
        get
    }
    //mutating：为了能在该方法中修改struct或enum的变量
     mutating func adjust()
}

//扩展
extension Int: ExampleProtocol {
    //扩展内属性只能读
    var simpleDescription: String {
        return "The number \\(self)"
    }
    mutating func adjust() {
        self += 42
    }
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class"
    var anotherProperty :Int = 110
    // 在 class 中实现带有mutating方法的接口时，不用mutating进行修饰。因为对于class来说，类的成员变量和方法都是透明的，所以不必使用 mutating 来进行修饰
    func adjust() {
        simpleDescription += " Now 100% adjusted"
        print(simpleDescription)
    }
    
    enum PrinterError: Error {
        case outOfPaper
        case noToner
        case onFire
    }

}

struct SimpleStruct: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    var abc :String = "init"
    func adjust() {
        
    }
    mutating func abcd() {
        abc = "test"
    }
    
}

/*高级用法*/
//提供值创建枚举
enum ServerResponse {
    case result(String, String)
    case failure(String)
}

//枚举递归
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}

//重新实现swift标准库的可选类型（使用泛型）
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}

//枚举可以继承协议(internal 作用？？？)
protocol Skill {
    mutating func modifyMusic(name: String)
}

enum Type:String,Skill {
    case name = "123"
    mutating internal func modifyMusic(name: String) {
        self = Type(rawValue: "123")!
    }
}

// 枚举不能包含存储属性，但是可以包含静态变量和计算属性
enum SmoeEnumeration: Int {
    case one = 2
    case two = 345
    static var storedTypeproperty = "Smoe value."
    static var computedTypeProperty: Int {
        return 6
    }
    var getRaw: Int {
        return self.rawValue
    }
}

enum Locale {
    case none
    case base
    case language(String)
}

protocol Custom {
    var describe:String{get}
}

extension Int:Custom{
    var describe:String{
        return String(self)
    }
}

//增加一个只能让元素为int是才能使用的扩展
extension Array  where Element : Custom {
    var  lastValue: Element {
        return self[count-1]
    }
}

extension String{
    subscript(n:Int)->Character{
        let index = self.characters.index(self.characters.startIndex, offsetBy:n)
        return  self.characters[index]
    }
}

extension String{
    subscript(range:ClosedRange<Int>)->String{
        let range = self.index(startIndex, offsetBy: range.lowerBound )...self.index(startIndex, offsetBy: range.upperBound)
        return self[range]
    }
}

enum StudentError:Error {
    case nameEmpty
    case ScoreLowZero
}

class Student {
    var name: String = "123"
    var score: Float = 0.0
    var userIcon: UnsafeMutableRawPointer = malloc(40*40*4)// 定义用户图像数据流
    init(name: String)throws {
        if name == "" {
            //调用之前，必须初始化所有的存储属性
            defer {
                free(self.userIcon)
                print("第二步发生异常清理内存")
            }
            print("第一步 抛出异常")
            throw StudentError.nameEmpty
        }
        self.name = name
    }
}

/*unowned用法
 1、解决循环引用的问题时，若引用的对象必须为非可选类型
 2、闭包弱引用自身属性[unowned self]
 */

//对象判等遵循Equatable协议

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //获取类的标识
        let x = Square.init(sideLength: 0.5, name: "abc")
        print(ObjectIdentifier(x))
        
        //检测API
        if #available(iOS 10, *) {
            print("支持10")
        } else {
            print("不支持10，支持10之前的版本")
        }
        if #available(iOS 9, macOS 10.12, *) {
            print("abc")
        }
        
        do {
            let student = try Student(name: "")
        } catch  {
            print(error)
        }
        
        let string = "你好,我是酷走天涯"
       
        let cc = string[1...3] // 是不是简便很多
 
//        func getCharacterByIndex(n: Int, string: String) -> Character? {
//            let index = string.characters.index(string.characters.startIndex, offsetBy: n)
//            return string.characters[index]
//        }
//        let c = getCharacterByIndex(n: 2, string: "你过得好吗")
        func getCharacterByIndex(n:Int,string:String)-> Character?{
            let index = string.characters.index(string.characters.startIndex, offsetBy:n)
            return  string.characters[index]
        }
        let c = getCharacterByIndex(n: 2, string: "你好吗")
        
        let nums = [1,2,3,4,5]
        print(nums.lastValue)
//        let nums: [Any] = ["abc", 2, "def", 3]
//        print(nums.lastva)
        
        let locale = Locale.language("english")
        
        var possibleInteger: OptionalValue<Int> = .none
        possibleInteger = .some(100)
    
        let success = ServerResponse.result("", "")
        
        let ace: Rank = Rank.ace
        let aceRawValue = ace.rawValue
        print(aceRawValue)

        func abc () {
            
            final class Person{
                
                static var describe:String = " 这是一个人类"
                class var score:Int{
                    return 0
                }
                // class 修饰的类方法可以被子类重写,static 修饰的静态方法不能被重写
                static func  getScore()->Int{
                    return score
                }
            }
            let _  = Person.getScore()
            
        }
        let a:[String] = ["hello", "world"]
        print(a)
       
        var array1 = Array(1...5)
        array1.removeFirst()
        
        var array:[Int] = [1,2]
        array.append(3)
        for number in array {
            print("\(number)abc")
        }
     
        let greeting = "Guten Tag!"
        // 截取单个
//        greeting[greeting.startIndex]
        // 截取一段
        let _:[String:Int] = [:]
        let _ = [String:Int]()
        let _:NSDictionary = NSDictionary()
        let _:Dictionary = [String:Int]()
        
        let _: Dictionary = [String:Int]()
        
        let _ = UInt8.min
        let _ = UInt8.max
        
        typealias ABC = Int
        
        let apples = 3
        let oranges = 5
        let fruitSummary = "I have \(apples + oranges) pieces of fruit."
        print(fruitSummary)
    
        let nickName: String? = nil
        let fullName: String = "XUJIE"
        let _ = "Hi \(nickName ?? fullName)"
        
        var nickName1: String? = nil
        if let b = nickName1 {
            print(nickName1!)
        }
        
        var aaa: Int? = nil
        aaa = 1
        let b = 4
        print((aaa ?? 0) + b)

        let aSquare = Square.init(sideLength: 0.5, name: "abc")
        aSquare.numberOfSides = 5
        let _ = aSquare.simpleDescription()
        
        let simpleClass = SimpleClass()
        simpleClass.adjust()
        
        func send(_ job: Int, toPrinter printerName: String) throws -> String {
            if printerName == "Never Has Toner" {
                throw SimpleClass.PrinterError.noToner
            }
            return "Job sent"
        }
        do {
            let printerResponse = try send(1440, toPrinter: "Gutenberg")
            print(printerResponse)
        } catch SimpleClass.PrinterError.onFire {
            print("rest of the fire.")
        } catch {
            print(error)
        }
        
        var list2:[String] = ["你好","2","3","4"]
        // 清空数组
//        list2.removeAll() //  如果定义为var
//        list2 = [] // 如果定义为var
        list2.insert("abc", at: 2)
        print(list2)
        let _ = [String]()
        let _: [String] = []
        let _: NSArray = NSArray()
        let _: NSArray = []
        let _: NSMutableArray = []
        let _: NSMutableArray = NSMutableArray()
        let _: Array = [String]()
        var _ = "abcdefghijklmnopqrstuvwxyz"
        //截取一段,2.3没有此api
        var subGreeting = ""
        subGreeting = greeting[greeting.index(greeting.startIndex, offsetBy: 2)..<greeting.index(greeting.endIndex, offsetBy: -3)]
       print(subGreeting)
//        let num1 = 30.0
//        let str = "\(num1)"
//        let str1 = "abc"
//        let num2 = Int(num1)
//        let num3 = Int(str1)
//        let num4 = Double(str1)
//        print(num4 ?? str1)
        //遍历数组
        let list1:[Any] = ["你好","2","3",4]
        for (index, value) in list1.enumerated() {
            print("Item \(index+1):\(value)")
        }
        
        //map的用法
        self.mapTest()
    
        //集合set
        let favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
        print(favoriteGenres)
    
        var start:Int = 0
        let final = 1000
        whileLabel: while start != final {
            start += Int(arc4random_uniform(100)) // 随机增加一个数字
            print(start)
            switch start {
            case final:  // 如果== 最终值结束循环
                break whileLabel
            case let x where x > final: //如果值大于1000 则初始化为0 继续开始循环
                start = 0
                continue whileLabel
            default:
                break
                
            }
        }
        
//        let str = "abc"
//        let str1 = "azyw"
//        if str < str1 {
//            print("\(str)")
//        }
        
        class Circle{
            lazy var area: Double = 0.0
            var r:Double = 0.0 {
                willSet{
                    print("有新值")
                    area = Double.pi*newValue*newValue
                }
                didSet {
                    print("已经有了")
                }
            }
        }
        let circle = Circle()
        func calcalate(r1:inout Double){
            print("函数执行开始")
            r1 = 2.0
            print("函数执行结束")
        }
        calcalate(r1: &circle.r)
        
        
        //属性包含存储属性和计算属性
        /*存储属性
         1、类和结构体中，不能在枚举中使用
         2、不能被子类重写，但可以在子类中给他添加监测功能
         */
        /*计算属性
         1、如果计算属性只有getter方法，那么这个get可以被忽略
         2、setter可以设置新值名字，如果没有设置默认为newValue
         3、let不能修饰计算属性
         4、willSet监测新值，didSet监测旧值
         */
        //inout修饰的参数，值拷贝
        /*lazy
         1、只能用于存储属性
         2、修饰的属性必须有初始化
         3、在结构体中使用lazy修饰的属性，访问的方法必须加mutating修饰
         4、不能用于全局属性或者静态变量
         5、存储属性被lazy修饰，只被初始化一次，在多线程访问时，不需要lazy修饰
         */
        
        /* static和class
         * 相同点
         1、可以修饰方法
         2、都可以修饰计算属性
         * 异同点
         1、class不能修饰存储属性
         2、class修饰的计算属性可以被重写，static不能
         3、static可以修饰存储属性，成为静态变量（常量）
         4、static修饰的静态方法不能重写，class此时的类方法可以被重写
         5、class 修饰的类方法被重写时,可以使用static 让方法变为静态方法
         6、class 修饰的计算属性被重写时,可以使用static 让其变为静态属性,但它的子类就不能被重写了
         7、class只能在类中使用，但是static可以咋类、结构体、枚举中使用
         */
        //discardableResult
//        @discardableResult
//        func defaultValue(a:Int = 5) -> Int {
//            return a;
//        }
//        defaultValue()
      
        //escaping
//        var downloadComplate:((Bool)->())!
//        func downloadResource(asiname url:String,complate:@escaping (Bool)->())  {
//            downloadComplate = complate
//            // 异步下载,下载完成调动
//            downloadComplate(true)
//            // 下载失败
//            downloadComplate(false)
//        }
//     
//        downloadResource(asiname: "www.baidu.com") { (true) in
//            print(true)
//        }
//       //如何解包？？？？？？
//        func somefunction(closure:()->Void) {
//            closure()
//        }
//        somefunction {
//            print("yes")
//        }
//        //autoclosure
//        func serve(customer customerProvider: () -> String) {
//            print(customerProvider())
//        }
//        serve { () -> String in
//            return "没加@autoclosure"
//        }
////        func serve(customer customerProvider: @autoclosure () -> String)     {
////            print (customerProvider())
////        }
////        serve(customer: "加了@autoclosure") // 调用
//        @discardableResult
//        func greet(_ person: String, on day: String) -> String {
//            return "Hello \\\\(person), today is \\\\(day)."
//        }
//        greet("abc", on: "def")
//
//        //onescape、noescape(不能被引用、不能异步执行)
//        func calculate(fun :@noescape ()->()){
//       
//        }
        
        /* 类初始化顺序(没有啊)
         1、首先在自己的初始化方法中给自己的属性初始化
         2、然后调用父类的初始化
         3、最后修改父类的属性
         */
        /* 类初始化的过程
         第一阶段
         1、调用指定初始化方法或者方便初始化方法
         2、给新的实例分配内存，当内存还没有初始化
         3、指定初始化方法确定所有存储属性都被初始化，内存这个时候被初始化
         4、然后去调用父类的指定初始化方法，任务和调用自己指定初始化方法相同
         5、继续在类继承链中指定上述过程，知道达到链的顶部为止
         6、当到完成积累的初始化的时候，实例的初始化算是完成了
         第二阶段
         1、可以对属性值进行修改
         2、可以调用对象方法
         */
        
        /* 子类初始化方法使用的总结
         1、创建新的指定初始化方法，必须调用父类的指定初始化方法（Designated）
         2、创建新的方便初始化方法，必须调用自己的初始化方法
         3、重写父类的指定初始化方法，需要加override，然后调用父类的指定初始化方法
         4、重写父类的方便初始化方法，不需要加override，然后调用父类的指定初始化方法
         5、如果子类没有初始化时，系统会自动继承父类的初始化方法
         6、初始化调用父类初始化时，需要先初始化子类的存储属性，但是如果是convenience修饰的初始化
         方法，要先调用其他初始化方法，然后再给自己的存储属性赋值
         */
        
        /* 创建一个可能失败的初始化
         1、不能将重写的初始化方法改为可能失败的初始化方法
         2、不能使用相同的参数定义一个可能失败的和不会失败的初始化方法
         3、可能失败的类型可以重写为不会失败类型
         */
        
//        let bbbbb :Document! = Document.init(name: "abccc")
//        print(bbbbb.name as Any)
        let _: Document = Document.init()
        let _: Document? = Document(name: nil)
    }
    
    func mapTest() {
        //给一组数组大于20的数字乘以3
        let numbers = [21, 19, 7, 12]
        let closure = {(number:Int) -> Int in
            var result = number
            if number > 20 {
                result *= 3
            }
            return result
        }
        print(numbers.map(closure))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class Document {
    var name: String?
    init() {} // 专门初始化name为 nil的情况
    init?(name: String?) { // 传入名字 ,肯定不为nil ,只需要判断是否为空即可
        if name != nil {
            self.name = name
        }
        return nil
    }
}

//class Document {
//    var name:String?
//    init?(name:String?){
//        if name != nil && name!.isEmpty{
//            return nil
//        }
//        self.name = name
//    }
//}

class Person {
    var name:String
    var age:Int = 0
    var height:Double = 0.0
    
    init(name:String) {
        self.name = name
    }
    required convenience init(name:String, age:Int) {
        self.init(name:name, age:age)
        self.age = age
    }
    init?(name:String, age:Int, height:Double) {
        if name == "" {
            return nil
        }
        
        self.name = name
        self.age = age;
//        self.init(name:name, age:age)
        self.height = height
    }
}

class Man: Person {
    var address:String = ""
    //重写父类指定初始化方法
    override init(name: String, age: Int, height: Double) {
        //子类只能调用父类的初始化方法，不能调用convenience修饰的方便修饰方法
        super.init(name: name)
        
    }
    //重写父类方便初始化方法，不需要添加override
    required init(name: String, age:Int) {
        self.address = "my address"
        super.init(name: name)
    }
    
//    init(name: String, age: Int, height: Double, address:String) {
//        
//        //方便初始化方法内，只能调用本类初始化方法，且只能调用一个
//        //要先调用初始化方法，然后给属性赋值
//        super.init(name: name, age: age, height: height)
//        self.address = address
//    }
    
    convenience init?(name: String, age: Int, height: Double, address:String) {
        if name == "" {
            return nil
        }
        //方便初始化方法内，只能调用本类初始化方法，且只能调用一个
        //要先调用初始化方法，然后给属性赋值
        self.init(name: name, age: age, height: height)
        self.address = address
    }
    
   
}






















