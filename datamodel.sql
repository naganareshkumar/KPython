CREATE TABLE Customer (
    CustomerID INTEGER PRIMARY KEY,
    FirstName TEXT,
    LastName TEXT,
    Email TEXT,
    Phone TEXT,
    Address TEXT,
    City TEXT,
    State TEXT,
    ZipCode TEXT,
    Country TEXT
);

CREATE TABLE Category (
    CategoryID INTEGER PRIMARY KEY,
    CategoryName TEXT
);

CREATE TABLE Product (
    ProductID INTEGER PRIMARY KEY,
    ProductName TEXT,
    Description TEXT,
    Price REAL,
    StockQuantity INTEGER,
    CategoryID INTEGER,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE "Order" (
    OrderID INTEGER PRIMARY KEY,
    OrderDate TEXT,
    CustomerID INTEGER,
    ShippingAddress TEXT,
    TotalAmount REAL,
    OrderStatus TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE OrderDetail (
    OrderDetailID INTEGER PRIMARY KEY,
    OrderID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    UnitPrice REAL,
    Subtotal REAL,
    FOREIGN KEY (OrderID) REFERENCES "Order"(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Payment (
    PaymentID INTEGER PRIMARY KEY,
    OrderID INTEGER,
    PaymentDate TEXT,
    PaymentMethod TEXT,
    Amount REAL,
    FOREIGN KEY (OrderID) REFERENCES "Order"(OrderID)
);

CREATE TABLE Shipping (
    ShippingID INTEGER PRIMARY KEY,
    OrderID INTEGER,
    ShippingMethod TEXT,
    ShippingDate TEXT,
    TrackingNumber TEXT,
    ShippingCost REAL,
    FOREIGN KEY (OrderID) REFERENCES "Order"(OrderID)
);

CREATE TABLE Supplier (
    SupplierID INTEGER PRIMARY KEY,
    SupplierName TEXT,
    ContactName TEXT,
    Phone TEXT,
    Email TEXT,
    Address TEXT,
    City TEXT,
    State TEXT,
    ZipCode TEXT,
    Country TEXT
);

CREATE TABLE ProductSupplier (
    ProductSupplierID INTEGER PRIMARY KEY,
    ProductID INTEGER,
    SupplierID INTEGER,
    CostPrice REAL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);
