-- CREATE DATABASE
CREATE DATABASE ClinicDB;
GO

USE ClinicDB;
GO



-- CLINICS
CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

-- CUSTOMERS
CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

-- CLINIC SALES
CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- EXPENSES
CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description VARCHAR(200),
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);



INSERT INTO clinics VALUES
('c1', 'Clinic A', 'Bangalore', 'Karnataka', 'India'),
('c2', 'Clinic B', 'Mysore', 'Karnataka', 'India');

INSERT INTO customer VALUES
('u1', 'John Doe', '9876543210'),
('u2', 'Jane Smith', '9123456780');

INSERT INTO clinic_sales VALUES
('o1', 'u1', 'c1', 2000, '2021-09-10', 'online'),
('o2', 'u2', 'c1', 3000, '2021-09-15', 'offline'),
('o3', 'u1', 'c2', 1500, '2021-09-20', 'online');

INSERT INTO expenses VALUES
('e1', 'c1', 'rent', 1000, '2021-09-05'),
('e2', 'c2', 'supplies', 500, '2021-09-07');



