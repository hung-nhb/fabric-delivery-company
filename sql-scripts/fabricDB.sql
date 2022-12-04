SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS; 
SET FOREIGN_KEY_CHECKS=0;
DROP SCHEMA IF EXISTS fabric_delivery_company;
CREATE SCHEMA fabric_delivery_company;
USE fabric_delivery_company;

-- Mapping of strong entities
CREATE TABLE `User`(
	UID char(6),
    `First and Middle Name` varchar(30),
    `Name` varchar(10),
    Phone char(10),
    Address varchar(50),
    PRIMARY KEY(UID)
);

CREATE TABLE Customer(
	CID char(6),
    Debt float CHECK(Debt >= 0),
    Debt_limit float CHECK(Debt_limit > 0),
    PRIMARY KEY(CID),
    FOREIGN KEY(CID) references `User`(UID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Employee(
	EID char(6),
    PRIMARY KEY(EID)
);

CREATE TABLE Accountant(
	AID char(6),
    PRIMARY KEY(AID),
    FOREIGN KEY(AID) references Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Worker(
	WID char(6),
    PRIMARY KEY(WID),
    FOREIGN KEY(WID) references Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Saler(
	SID char(6),
    PRIMARY KEY(SID),
    FOREIGN KEY(SID) references Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Cashier(
	CaID char(6),
    PRIMARY KEY(CaID),
    FOREIGN KEY(CaID) references Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Warehouse_Staff(
	WsID char(6),
    PRIMARY KEY(WsID),
    FOREIGN KEY(WsID) references Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Driver(
	DID char(6),
    PRIMARY KEY(DID),
    FOREIGN KEY(DID) references Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Manager(
	`MID` char(6),
    PRIMARY KEY(`MID`),
    FOREIGN KEY(`MID`) references Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `Account`(
	Username varchar(30),
    `Type` varchar(20),
    `Password` varchar(20),
    PRIMARY KEY(Username)
);

CREATE TABLE Customer_Type(
	`Type` varchar(20),
    Debt_limit float CHECK(Debt_limit > 0),
    PRIMARY KEY(`Type`)
);

CREATE TABLE `Order`(
	OID int AUTO_INCREMENT,
    `Date` date,
    `Status` varchar(30),
	`Note` varchar(50),
    PRIMARY KEY(OID)
);

ALTER TABLE `Order` AUTO_INCREMENT = 100001;

CREATE TABLE Product(
	PID int AUTO_INCREMENT,
    `Name` varchar(30),
    `Type` varchar(20),
    `Color` varchar(10),
    Image LONGBLOB,
    Detail varchar(50),
    Supplier varchar(30),
    Inventory_on_hand int CHECK(Inventory_on_hand > 0),
    PRIMARY KEY(PID)
);

ALTER TABLE Product AUTO_INCREMENT = 200001;

CREATE TABLE Delivery_Unit(
	DuID int AUTO_INCREMENT,
    PRIMARY KEY(DuID)
);

ALTER TABLE Delivery_Unit AUTO_INCREMENT = 300001;

CREATE TABLE Company_Delivery_Unit(
	CDuID int AUTO_INCREMENT,
    DuID int,
    PRIMARY KEY(CDuID), 
    FOREIGN KEY(DuID) references Delivery_Unit(DuID) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE Company_Delivery_Unit AUTO_INCREMENT = 400001;

CREATE TABLE Outside_Delivery_Unit(
	ODuID int AUTO_INCREMENT,
    `Name` varchar(30),
    Driver_Name varchar(30),
    License_plate char(10),
    DuID int,
    PRIMARY KEY(ODuID),
    FOREIGN KEY(DuID) references Delivery_Unit(DuID) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE Outside_Delivery_Unit AUTO_INCREMENT = 500001;

CREATE TABLE Vehicle(
	License_plate char(10),
    PRIMARY KEY(License_plate)
);

CREATE TABLE Delivery_Trip(
	DtID int AUTO_INCREMENT,
    `Date` date,
    Current_location varchar(50),
    `Status` varchar(20),
    PRIMARY KEY(DtID)
);

ALTER TABLE Delivery_Trip AUTO_INCREMENT = 600001;

CREATE TABLE Sales_Time(
	StID int AUTO_INCREMENT,
    Price int CHECK(Price > 0),
    VAT float DEFAULT 0.08,
    Sale_date date,
	PRIMARY KEY(StID)
);

ALTER TABLE Sales_Time AUTO_INCREMENT = 700001;

CREATE TABLE Receipt(
	RID int AUTO_INCREMENT,
    `Date` date,
    PRIMARY KEY(RID)
);

ALTER TABLE Receipt AUTO_INCREMENT = 800001;

CREATE TABLE Bill(
	BID int AUTO_INCREMENT,
    `Date` date,
    Price int CHECK(Price > 0),
    PRIMARY KEY(BID)
);

ALTER TABLE Bill AUTO_INCREMENT = 900001;

-- Mapping of weak entities
CREATE TABLE Package(
	PaID int AUTO_INCREMENT,
    OID int,
    Kg int CHECK(Kg > 0),
    PRIMARY KEY(PaID, OID),
    FOREIGN KEY(OID) references `Order`(OID) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE Package AUTO_INCREMENT = 110001;

-- Mapping of 1:1 or 1:N relationship (foreign key approach)
ALTER TABLE `User` ADD (Username varchar(30) not null);
ALTER TABLE `User` ADD FOREIGN KEY(Username) references `Account`(Username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Customer ADD (`Type` varchar(20));
ALTER TABLE Customer ADD FOREIGN KEY(`Type`) references Customer_Type(`Type`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Employee ADD (`MID` char(6));
ALTER TABLE Employee ADD FOREIGN KEY(`MID`) references Manager(`MID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Vehicle ADD (CDuID int not null);
ALTER TABLE Vehicle ADD FOREIGN KEY(CDuID) references Company_Delivery_Unit(CDuID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Driver ADD (CDuID int);
ALTER TABLE Driver ADD FOREIGN KEY(CDuID) references Company_Delivery_Unit(CDuID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Delivery_Unit ADD (WsID char(6));
ALTER TABLE Delivery_Unit ADD FOREIGN KEY(WsID) references Warehouse_Staff(WsID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Delivery_Trip ADD (DuID int);
ALTER TABLE Delivery_Trip ADD FOREIGN KEY(DuID) references Delivery_Unit(DuID) ON DELETE CASCADE ON UPDATE CASCADE;

-- Mapping of N:M or 3 - ary relationship (relationship relation approach)
CREATE TABLE Contain(
	OID int,
    PID int,
    Quantity int,
    Meters float,
    PRIMARY KEY(OID, PID),
    FOREIGN KEY(OID) references `Order`(OID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(PID) references Product(PID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Has_Package(
	DtID int,
    PaID int,
    OID int,
    PRIMARY KEY(DtID, PaID, OID),
    FOREIGN KEY(DtID) references Delivery_Trip(DtID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(PaID, OID)references Package(PaID, OID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Sale(
	StID int,
    OID int,
    SID char(6),
    Unique(StID, SID), 
    PRIMARY KEY(StID, OID),
    FOREIGN KEY(StID)references Sales_Time(StID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(OID)references `Order`(OID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(SID)references Saler(SID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Make_Order(
	OID int,
    SID char(6),
    CID char(6) not null,
    Unique(OID, CID),
    PRIMARY KEY(OID, SID),
    FOREIGN KEY (OID)references `Order`(OID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(SID)references Saler(SID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(CID)references Customer(CID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Has_Product(
	PaID int,
    OID int,
    PID int,
    Quantity int,
    Meters float,
	PRIMARY KEY(PaID, OID, PID),
    FOREIGN KEY(PaID, OID)references Package(PaID, OID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(PID)references Product(PID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Do_Receipt(
	RID int,
    OID int,
    AID char(6) not null,
    Unique(RID, AID),
    PRIMARY KEY(RID, OID),
    FOREIGN KEY(RID)references Receipt(RID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (OID)references `Order`(OID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (AID)references Accountant(AID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Pay_Bill(
	BID int,
	DuID int,
    AID char(6) not null,
    Unique(BID, AID),
    PRIMARY KEY(BID, DuID),
    FOREIGN KEY(BID)references Bill(BID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (DuID)references Delivery_Unit(DuID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (AID)references Accountant(AID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Type_of_authority(
	EID char(6),
    Type_of_authority varchar(30),
    PRIMARY KEY(EID,Type_of_authority),
    FOREIGN KEY(EID)references Employee(EID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Address(
	DtID int,
    Address varchar(30),
    PRIMARY KEY(DtID, Address),
    FOREIGN KEY(DtID)references Delivery_Trip(DtID) ON DELETE CASCADE ON UPDATE CASCADE
);
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

