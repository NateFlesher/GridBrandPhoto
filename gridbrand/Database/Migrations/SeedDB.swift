import Foundation
import SQLiteMigrationManager
import SQLite
import Fakery

struct SeedDB: Migration {
  var version: Int64 = 2

  func migrateDatabase(_ db: Connection) throws {
    let faker = Faker(locale:"en")
    
    let userDao = UserDao()
    let cycleDao = CycleDao()
    let savedCycleDao = SavedCycleDao()
    let messageDao = MessageDao()
    let categoryDao = CategoryDao()
    let tagDao = TagDao()
    let cycleTagDao = CycleTagDao()
    let notificationDao = NotificationDao()
    
    (1...20).forEach {
        let user = UserModel(data: [
            "id": Int64($0),
            "email": faker.internet.email(),
            "mobile": faker.phoneNumber.cellPhone(),
            "fullname": faker.name.name(),
            "country": faker.address.country(),
            "profession": faker.company.bs(),
            "skype": faker.internet.username(),
            "location": "\(faker.address.city()), \(faker.address.state()), \(faker.address.country())",
            "web": faker.internet.url(),
            "avatar_url": ["sample_avatar1", "sample_avatar2", "sample_avatar3", "sample_avatar4", "sample_avatar5"].sample(),
            "cover_url": "sample_cover",
            "note": faker.lorem.sentence(wordsAmount: 25),
            "cycle_amount": [0, 50, 100, 150, 200].sample(),
            "created_time": Int64(NSDate().timeIntervalSince1970),
            "updated_time": Int64(NSDate().timeIntervalSince1970)
            ])
        
        let userid = userDao.create(user)
        print("Created user id \(userid!)")
    }
    
    let users = userDao.find()
    
    
    let categories = [
        CategoryModel(data: ["id":Int64(1), "title":"Rest", "icon_url":"category1"]),
        CategoryModel(data: ["id":Int64(2), "title":"Pub/Bar", "icon_url":"category2"]),
        CategoryModel(data: ["id":Int64(3), "title":"Fashion", "icon_url":"category3"]),
        CategoryModel(data: ["id":Int64(4), "title":"Electronics", "icon_url":"category4"]),
        CategoryModel(data: ["id":Int64(5), "title":"Real Estate", "icon_url":"category5"]),
        ]
    for category in categories {
        let categoryId = categoryDao.create(category)
        print("Created category id \(categoryId!)")
    }
    
    (1...50).forEach {
        let magic = [true, false].sample()
        let cycle = CycleModel(data: [
            "id": Int64($0),
            "user_id": Int64([1,2,3,4,5].sample()),
            "title": faker.commerce.productName(),
            "photo_url": ["sample_cycle1", "sample_cycle2", "sample_cycle3", "sample_cycle4"].sample(),
            "note": faker.lorem.sentence(wordsAmount: 25),
            "magic": magic,
            "counting": magic ? [true, false].sample() : false,
            "price_unit": [CyclePriceUnit.dollar.rawValue, CyclePriceUnit.cycle.rawValue].sample(),
            "price": faker.commerce.price(),
            "category_id": categories.sample().id,
            "created_time": Int64(NSDate().timeIntervalSince1970),
            "updated_time": Int64(NSDate().timeIntervalSince1970)
            ])
        
        let cycleid = cycleDao.create(cycle)
        print("Created cycle id \(cycleid!)")
    }
    
    let cycles = cycleDao.find()
    (1...50).forEach {
        let savedCycle = SavedCycleModel(data: [
            "id": Int64($0),
            "user_id": Int64([1,2,3,4,5].sample()),
            "cycle_id": cycles.sample().id,
            "created_time": Int64(NSDate().timeIntervalSince1970),
            "updated_time": Int64(NSDate().timeIntervalSince1970)
            ])
        
        let savedCycleId = savedCycleDao.create(savedCycle)
        print("Created saved cycle id \(savedCycleId!)")
    }
    
    (1...50).forEach {
        let message = MessageModel(data: [
            "id": Int64($0),
            "from_user_id": users.sample().id,
            "to_user_id": Int64([1,2,3,4,5].sample()),
            "message": faker.lorem.sentence(wordsAmount: 25),
            "deleted": false,
            "updated": false,
            "created_time": Int64(NSDate().timeIntervalSince1970),
            "updated_time": Int64(NSDate().timeIntervalSince1970)
            ])
        
        let messageid = messageDao.create(message)
        print("Created message id \(messageid!)")
    }
    
    
    (1...50).forEach {
        let tag = TagModel(data: [
            "id": Int64($0),
            "title": faker.lorem.word(),
            "note": faker.lorem.sentence(wordsAmount: 25),
            "created_time": Int64(NSDate().timeIntervalSince1970),
            "updated_time": Int64(NSDate().timeIntervalSince1970)
            ])
        
        let tagid = tagDao.create(tag)
        print("Created tag id \(tagid!)")
    }
    
    
    let tags = tagDao.find()
    (1...100).forEach {
        let cycleTag = CycleTagModel(data: [
            "id": Int64($0),
            "cycle_id": cycles.sample().id,
            "tag_id": tags.sample().id,
            "created_time": Int64(NSDate().timeIntervalSince1970),
            "updated_time": Int64(NSDate().timeIntervalSince1970)
            ])
        
        let cycleTagId = cycleTagDao.create(cycleTag)
        print("Created cycle tag id \(cycleTagId!)")
    }
    
    (1...50).forEach {
        let notification = NotificationModel(data: [
            "id": Int64($0),
            "from_user_id": users.sample().id,
            "to_user_id": Int64([1,2,3,4,5].sample()),
            "cycle_id": cycles.sample().id,
            "note": faker.lorem.sentence(wordsAmount: 25),
            "type": [NotificationType.recycle.rawValue, NotificationType.buy.rawValue, NotificationType.follow.rawValue].sample(),
            "read": false,
            "created_time": Int64(NSDate().timeIntervalSince1970),
            "updated_time": Int64(NSDate().timeIntervalSince1970)
            ])
        
        let notificationid = notificationDao.create(notification)
        print("Created notification id \(notificationid!)")
    }
  }
}
