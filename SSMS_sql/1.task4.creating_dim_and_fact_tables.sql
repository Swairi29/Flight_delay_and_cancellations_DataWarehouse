USE Flight_DataWarehouse;
GO

-- 1. Create Dim_Airline (Type 1)
CREATE TABLE dbo.Dim_Airline (
    Airline_SK INT IDENTITY(1,1) PRIMARY KEY,
    Airline_Code NVARCHAR(10) NOT NULL, -- Alternate Key
    Airline_Name NVARCHAR(100),
    DOT_Code NVARCHAR(20),
    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);
GO

-- 2. Create Dim_Airport (Type 2 SCD)
CREATE TABLE dbo.Dim_Airport (
    Airport_SK INT IDENTITY(1,1) PRIMARY KEY,
    Airport_Code NVARCHAR(10) NOT NULL, -- Alternate Key
    City NVARCHAR(100),
    -- SCD Type 2 Columns (As per Lab 5 standards)
    StartDate DATETIME,
    EndDate DATETIME NULL,
    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);
GO

-- 3. Create Dim_CancelReason
CREATE TABLE dbo.Dim_CancelReason (
    Cancel_SK INT IDENTITY(1,1) PRIMARY KEY,
    Cancel_Code NVARCHAR(5) NOT NULL, -- Alternate Key
    Cancel_Description NVARCHAR(100),
    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);
GO

-- 4. Create Dim_FlightStatus (Junk Dimension)
CREATE TABLE dbo.Dim_FlightStatus (
    Status_SK INT IDENTITY(1,1) PRIMARY KEY,
    Status_Code NVARCHAR(10) NOT NULL, -- Alternate Key
    Is_Cancelled INT,
    Is_Diverted INT,
    Delay_Category NVARCHAR(50),
    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);
GO

-- dim date later

-- 5. Create Fact_Flight (Accumulating Fact)
CREATE TABLE dbo.Fact_Flight (
    txn_id INT IDENTITY(1,1) PRIMARY KEY, -- Natural Key
    DateKey INT NOT NULL, -- FK to Dim_Date
    Airline_SK INT NOT NULL, -- FK to Dim_Airline
    Origin_Airport_SK INT NOT NULL, -- FK to Dim_Airport
    Dest_Airport_SK INT NOT NULL, -- FK to Dim_Airport
    Cancel_SK INT NOT NULL, -- FK to Dim_CancelReason
    Status_SK INT NOT NULL, -- FK to Dim_FlightStatus
    
    Flight_Number NVARCHAR(20),
    
    -- Measures
    Dep_Delay_Minutes INT,
    Arr_Delay_Minutes INT,
    Distance INT,
    
    -- Accumulating Fact Columns
    accm_txn_create_time DATETIME,
    accm_txn_complete_time DATETIME NULL,
    txn_process_time_hours DECIMAL(10,2) NULL,
    
    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);
GO

-- Add Foreign Key Constraints
ALTER TABLE dbo.Fact_Flight ADD CONSTRAINT FK_Fact_Airline FOREIGN KEY (Airline_SK) REFERENCES dbo.Dim_Airline(Airline_SK);
ALTER TABLE dbo.Fact_Flight ADD CONSTRAINT FK_Fact_OriginAirport FOREIGN KEY (Origin_Airport_SK) REFERENCES dbo.Dim_Airport(Airport_SK);
ALTER TABLE dbo.Fact_Flight ADD CONSTRAINT FK_Fact_DestAirport FOREIGN KEY (Dest_Airport_SK) REFERENCES dbo.Dim_Airport(Airport_SK);
ALTER TABLE dbo.Fact_Flight ADD CONSTRAINT FK_Fact_Cancel FOREIGN KEY (Cancel_SK) REFERENCES dbo.Dim_CancelReason(Cancel_SK);
ALTER TABLE dbo.Fact_Flight ADD CONSTRAINT FK_Fact_Status FOREIGN KEY (Status_SK) REFERENCES dbo.Dim_FlightStatus(Status_SK);
GO