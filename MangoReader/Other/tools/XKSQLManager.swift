//
//  XKRealmManager.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/20.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
enum SQLTableType {
    case shelf
    case record
}
class XKSQLManager: NSObject {

    //定义一个单例对象（类对象）
    //系统中shareManager、defaultManager、standerdManager这一类获取的对象一般都是单例对象
    static let shareManager = XKSQLManager()

    //定义管理数据库的对象
    let fmdb:FMDatabase!

    //线程锁,通过加锁和解锁来保证所做操作数据的安全性
    let lock = NSLock()

//1.重写父类的构造方法
    override init() {
        //设置数据库的路径;fmdb.sqlite是由自己随意命名
        let path = NSHomeDirectory().appending("/Documents/fmdb.sqlite")
        //构造管理数据库的对象
        fmdb = FMDatabase(path: path)
        //判断数据库是否打开成功;如果打开失败则需要创建数据库
        if !fmdb.open() {
            print("数据库打开失败")
            return
        }
        //创建数据库
        //student表达表名，由自己命名
        //userName,passWord是需要收藏的模型中的字段，须根模型中保持一致
        //varchar表示字符串，integer表示数字，blob表示二进制数据NSData
        let create_record_sql = "create table if not exists record(bookId varchar(255) primary key,bookName varchar(255),author varchar(128),buyList varchar(2047),coverImg varchar(255),brief varchar(2045),chapterId varchar(255),title varchar(128),chapterNumber int(10),totalNumber int(10),content varchar(8000),currentPage Int(5),words int(5),addTime numeric(15,0),updateTime numeric(15,0))"
        
        //执行sel语句进行数据库的创建
        do {
            try fmdb.executeUpdate(create_record_sql, values: nil)
        }catch {
            print(fmdb.lastErrorMessage())
        }
        
        let create_shelf_sql = "create table if not exists shelf(bookId varchar(255) primary key,bookName varchar(255),author varchar(255),brief varchar(2045),coverImg varchar(255),category varchar(127),catename var(127),keywords varchar(127),words int(8),visitors varchar(127),gender int(2),state var(127),addTime numeric(15,0),updateTime numeric(15,0))"

        //执行sel语句进行数据库的创建
        do {
            try fmdb.executeUpdate(create_shelf_sql, values: nil)
        }catch {
            print(fmdb.lastErrorMessage())
        }

    }
    

    //2.1增
    func insertDataToShelfTableWith(model: BookModel) {

        //加锁操作
        lock.lock()
        //sel语句
        //(?,?)表示需要传的值，对应前面出现几个字段，后面就有几个问号
        let insetSql = "insert or ignore into shelf(bookId, bookName, author, brief, coverImg, category, catename, gender, state, addTime) values(?,?,?,?,?,?,?,?,?,?)"
        //更新数据库
        do {
            let dateStr = Date().timeIntervalSince1970
            try fmdb.executeUpdate(insetSql, values: [model.bookId!, model.bookName!,model.author!, model.brief ?? "", model.coverImg!,model.category ?? "",model.catename ?? "",model.gender ?? "", model.state ?? "", dateStr])
        }catch {
            print(fmdb.lastErrorMessage())
        }
        
        //解锁
        lock.unlock()
    }
    
    //2.2增
    func insertDataTorRecordTableWith(model: XKRecordModel) {

        //加锁操作
        lock.lock()
        //sel语句
        //(?,?)表示需要传的值，对应前面出现几个字段，后面就有几个问号
        let insetSql = "insert or ignore into record(bookId, bookName, author, buyList, coverImg, brief, chapterId, title, chapterNumber, totalNumber, content, currentPage, addTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?)"
        //更新数据库
        do {
            let dateStr = Date().timeIntervalSince1970
            let str = model.buyList?.joined(separator: ",")
            try fmdb.executeUpdate(insetSql, values: [model.bookId!, model.bookName!,model.author!,str ?? "", model.coverImg ?? "", model.brief ?? "" , model.currentChapter!.chapterId!, model.currentChapter?.title ?? "", model.currentChapter!.chapterNumber,model.totalNumber, model.currentChapter?.content ?? "", model.currentChapter!.currentPage, dateStr])
        }catch {
            print(fmdb.lastErrorMessage())
        }
        
        //解锁
        lock.unlock()
    }

    /// 3.删
    func deleteAllOldData(model: BookModel) {

        //加锁操作
        lock.lock()
        //sel语句
        //where表示需要删除的对象的索引，是对应的条件
        let deleteSql = "delete from student where"
        //更新数据库
        do{
            try fmdb.executeUpdate(deleteSql, values: nil)
        }catch {
            print(fmdb.lastErrorMessage())
        }
        //解锁
        lock.unlock()
    }
    
    func deleteAllRecordData() {

        //加锁操作
        lock.lock()
        //sel语句
        //where表示需要删除的对象的索引，是对应的条件
        let deleteSql = "delete * from record"
        //更新数据库
        do{
            try fmdb.executeUpdate(deleteSql, values: nil)
        }catch {
            print(fmdb.lastErrorMessage())
        }
        //解锁
        lock.unlock()
    }


    //4.1改
    // 更新阅读记录
    func updateRecordDataWith(model: XKRecordModel) {
        //加锁
        lock.lock()
        //where id = ?中的id可传可不传
        let updateSql = "update record set chapterId = ?,chapterNumber = ?,title = ?,content = ?,currentPage = ?,updateTime = ? where bookId = ?"
        //更新数据库
        do{
            let dateStr = Date().timeIntervalSince1970
            try fmdb.executeUpdate(updateSql, values: [model.currentChapter!.chapterId!, model.currentChapter!.chapterNumber, model.currentChapter!.title!, model.currentChapter!.content!, model.currentChapter!.currentPage, dateStr, model.bookId!])
        }catch {
            print(fmdb.lastErrorMessage())
        }
        
        //解锁
        lock.unlock()
    }
    
    //4.2改
     // 更新看广告记录
    func updateADRecordDataWith(adStr: String, bookId: String) {
         //加锁
         lock.lock()
         //where id = ?中的id可传可不传
         let updateSql = "update record set buyList = ? where bookId = ?"
         //更新数据库
         do{
             try fmdb.executeUpdate(updateSql, values: [adStr, bookId])
         }catch {
             print(fmdb.lastErrorMessage())
         }
         
         //解锁
         lock.unlock()
     }

    //5.判断数据库中是否有当前数据(查找一条数据)
    func isHasDataInShelfTable(bookId: String) -> Bool {

        let isHas = "select * from shelf where bookId = ?"
        do{
            let set = try fmdb.executeQuery(isHas, values: [bookId])
            //查找当前行，如果数据存在，则接着查找下一行
            if set.next() {
                return true
            }else {
                return false
            }
        }catch {
            print(fmdb.lastErrorMessage())
        }
        return false
    }
    
    /// 查询50tiao阅读记录Model
    func getAllRecordFromTable() -> [XKRecordModel] {

        let fetchSql = "select * from record order by updateTime desc limit 50"
        var tempArray = [XKRecordModel]()
        do {
            let set = try fmdb.executeQuery(fetchSql, values: nil)
            //循环遍历结果
            while set.next() {
                let model = XKRecordModel()
                model.bookId = set.string(forColumn: "bookId")
                model.bookName = set.string(forColumn: "bookName")
                model.author = set.string(forColumn: "author")
                let arrayStr = set.string(forColumn: "buyList")
                model.buyList = arrayStr?.components(separatedBy: ",")
                model.totalNumber = Int(set.int(forColumn: "totalNumber"))
                model.coverImg = set.string(forColumn: "coverImg")
                model.brief = set.string(forColumn: "brief")
                model.currentChapter = ChapterModel()
                model.currentChapter?.chapterId =  set.string(forColumn: "chapterId")
                model.currentChapter?.chapterNumber = Int(set.int(forColumn: "chapterNumber"))
                model.currentChapter?.title = set.string(forColumn: "title")
                model.currentChapter?.content = set.string(forColumn: "content")
                model.currentChapter?.currentPage = Int(set.int(forColumn: "currentPage"))
                tempArray.append(model)
            }
        }catch {
            print(fmdb.lastErrorMessage())
        }
        
        return tempArray
    }
    
    
    /// 查询最新的阅读记录Model
    func getFirstRecordFromTable() -> XKRecordModel? {

        let isHas = "select * from record order by updateTime desc limit 1"
        do{
            let set = try fmdb.executeQuery(isHas, values: nil)
            //查找当前行，如果数据存在，则接着查找下一行
            if set.next() {
                let model = XKRecordModel()
                model.bookId = set.string(forColumn: "bookId")
                model.bookName = set.string(forColumn: "bookName")
                model.author = set.string(forColumn: "author")
                let arrayStr = set.string(forColumn: "buyList")
                model.buyList = arrayStr?.components(separatedBy: ",")
                model.totalNumber = Int(set.int(forColumn: "totalNumber"))
                model.coverImg = set.string(forColumn: "coverImg")
                model.brief = set.string(forColumn: "brief")
                model.currentChapter = ChapterModel()
                model.currentChapter?.chapterId =  set.string(forColumn: "chapterId")
                model.currentChapter?.chapterNumber = Int(set.int(forColumn: "chapterNumber"))
                model.currentChapter?.title = set.string(forColumn: "title")
                model.currentChapter?.content = set.string(forColumn: "content")
                model.currentChapter?.currentPage = Int(set.int(forColumn: "currentPage"))
                return model
            }else {
                return nil
            }
        }catch {
            print(fmdb.lastErrorMessage())
        }
        return nil
    }
    
    /// 查询记录Model
    func getDataInRecordTable(bookId: String) -> XKRecordModel? {

        let isHas = "select * from record where bookId = ?"
//        let model
        do{
            let set = try fmdb.executeQuery(isHas, values: [bookId])
            //查找当前行，如果数据存在，则接着查找下一行
            if set.next() {
                let model = XKRecordModel()
                model.bookId = set.string(forColumn: "bookId")
                model.bookName = set.string(forColumn: "bookName")
                model.author = set.string(forColumn: "author")
                let arrayStr = set.string(forColumn: "buyList")
                model.buyList = arrayStr?.components(separatedBy: ",")
                model.totalNumber = Int(set.int(forColumn: "totalNumber"))
                model.coverImg = set.string(forColumn: "coverImg")
                model.brief = set.string(forColumn: "brief")
                model.currentChapter = ChapterModel()
                model.currentChapter?.chapterId =  set.string(forColumn: "chapterId")
                model.currentChapter?.chapterNumber = Int(set.int(forColumn: "chapterNumber"))
                model.currentChapter?.title = set.string(forColumn: "title")
                model.currentChapter?.content = set.string(forColumn: "content")
                model.currentChapter?.currentPage = Int(set.int(forColumn: "currentPage"))
                return model
            } else {
                return nil
            }
            
        }catch {
            print(fmdb.lastErrorMessage())
        }
        return nil
    }

//6.查找全部数据
func fetchAllDataFromShelf() ->[BookModel] {

    let fetchSql = "select * from shelf"
    //用于承接所有数据的临时数组
    var tempArray = [BookModel]()
    do {
        let set = try fmdb.executeQuery(fetchSql, values: nil)
        //循环遍历结果
        while set.next() {
            let model = BookModel()
            //给字段赋值
            model.bookId = set.string(forColumn: "bookId")
            model.bookName = set.string(forColumn: "bookName")
            model.author = set.string(forColumn: "author")
            model.coverImg = set.string(forColumn: "coverImg")
            model.brief = set.string(forColumn: "brief")
            model.category = set.string(forColumn: "category")
            model.catename = set.string(forColumn: "catename")
            model.gender = set.string(forColumn: "gender")
            model.state = set.string(forColumn: "state")
            tempArray.append(model)
        }
    }catch {
        print(fmdb.lastErrorMessage())
    }
    
    return tempArray
  }
}
