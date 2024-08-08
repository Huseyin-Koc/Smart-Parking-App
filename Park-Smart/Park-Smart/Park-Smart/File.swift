import CoreData

func createParkingSpotModel() -> NSManagedObjectModel {
    let model = NSManagedObjectModel()
    let parkingSpotEntity = NSEntityDescription()
    parkingSpotEntity.name = "ParkingSpot"
    parkingSpotEntity.managedObjectClassName = NSStringFromClass(ParkingSpot.self)

    // Attribute tanımlamaları
    let idAttribute = NSAttributeDescription()
    idAttribute.name = "id"
    idAttribute.attributeType = .UUIDAttributeType
    idAttribute.isOptional = false
    idAttribute.defaultValue = UUID()

    let coordinateLatAttribute = NSAttributeDescription()
    coordinateLatAttribute.name = "coordinateLat"
    coordinateLatAttribute.attributeType = .doubleAttributeType
    coordinateLatAttribute.isOptional = false

    let coordinateLonAttribute = NSAttributeDescription()
    coordinateLonAttribute.name = "coordinateLon"
    coordinateLonAttribute.attributeType = .doubleAttributeType
    coordinateLonAttribute.isOptional = false

    let nameAttribute = NSAttributeDescription()
    nameAttribute.name = "name"
    nameAttribute.attributeType = .stringAttributeType
    nameAttribute.isOptional = true

    let isOccupiedAttribute = NSAttributeDescription()
    isOccupiedAttribute.name = "isOccupied"
    isOccupiedAttribute.attributeType = .booleanAttributeType
    isOccupiedAttribute.isOptional = false

    let qrCodeAttribute = NSAttributeDescription()
    qrCodeAttribute.name = "qrCode"
    qrCodeAttribute.attributeType = .stringAttributeType
    qrCodeAttribute.isOptional = true

    let vehicleTypeAttribute = NSAttributeDescription()
    vehicleTypeAttribute.name = "vehicleType"
    vehicleTypeAttribute.attributeType = .stringAttributeType
    vehicleTypeAttribute.isOptional = true

    let parkedTimeAttribute = NSAttributeDescription()
    parkedTimeAttribute.name = "parkedTime"
    parkedTimeAttribute.attributeType = .dateAttributeType
    parkedTimeAttribute.isOptional = true

    let pricePerHourAttribute = NSAttributeDescription()
    pricePerHourAttribute.name = "pricePerHour"
    pricePerHourAttribute.attributeType = .doubleAttributeType
    pricePerHourAttribute.isOptional = false

    let startDateAttribute = NSAttributeDescription()
    startDateAttribute.name = "startDate"
    startDateAttribute.attributeType = .dateAttributeType
    startDateAttribute.isOptional = true

    parkingSpotEntity.properties = [idAttribute, coordinateLatAttribute, coordinateLonAttribute, nameAttribute, isOccupiedAttribute, qrCodeAttribute, vehicleTypeAttribute, parkedTimeAttribute, pricePerHourAttribute, startDateAttribute]

    model.entities = [parkingSpotEntity]
    return model
}
