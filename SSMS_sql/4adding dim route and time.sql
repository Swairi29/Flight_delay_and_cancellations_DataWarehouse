USE Flight_DataWarehouse;
GO

-- 1. Create Dim_Route
CREATE TABLE dbo.Dim_Route (
    Route_SK INT IDENTITY(1,1) PRIMARY KEY,
    Route_Code NVARCHAR(100) NOT NULL, -- The Business Key (e.g., JFK-LAX)
    Origin_Airport_Code NVARCHAR(10),
    Dest_Airport_Code NVARCHAR(10),
    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);
GO

-- 2. Create Dim_Time
CREATE TABLE dbo.Dim_Time (
    Time_SK INT PRIMARY KEY, -- We will use the Hour (0-23) as the SK
    Hour_of_Day INT NOT NULL,
    Time_Bucket NVARCHAR(50) NOT NULL
);
GO

-- 3. Auto-Populate Dim_Time (0 to 23 hours)
INSERT INTO dbo.Dim_Time (Time_SK, Hour_of_Day, Time_Bucket)
VALUES 
(0, 0, 'Red-Eye'), (1, 1, 'Red-Eye'), (2, 2, 'Red-Eye'), (3, 3, 'Red-Eye'), (4, 4, 'Red-Eye'), (5, 5, 'Early Morning'),
(6, 6, 'Early Morning'), (7, 7, 'Morning'), (8, 8, 'Morning'), (9, 9, 'Morning'), (10, 10, 'Morning'), (11, 11, 'Morning'),
(12, 12, 'Afternoon'), (13, 13, 'Afternoon'), (14, 14, 'Afternoon'), (15, 15, 'Afternoon'), (16, 16, 'Afternoon'), (17, 17, 'Evening'),
(18, 18, 'Evening'), (19, 19, 'Evening'), (20, 20, 'Evening'), (21, 21, 'Night'), (22, 22, 'Night'), (23, 23, 'Night');
GO

-- 4. Alter the Fact Table to add the new Foreign Keys
ALTER TABLE dbo.Fact_Flight ADD Route_SK INT;
ALTER TABLE dbo.Fact_Flight ADD Time_SK INT;
GO

ALTER TABLE dbo.Fact_Flight ADD CONSTRAINT FK_Fact_Route FOREIGN KEY (Route_SK) REFERENCES dbo.Dim_Route(Route_SK);
ALTER TABLE dbo.Fact_Flight ADD CONSTRAINT FK_Fact_Time FOREIGN KEY (Time_SK) REFERENCES dbo.Dim_Time(Time_SK);
GO