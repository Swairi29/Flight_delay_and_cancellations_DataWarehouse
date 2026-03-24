USE Flight_DataWarehouse;
GO

-- 1. Create the Table
CREATE TABLE dbo.Dim_Date (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    [Year] INT NOT NULL,
    [Quarter] INT NOT NULL,
    [Month] INT NOT NULL,
    MonthName NVARCHAR(15) NOT NULL,
    [DayOfMonth] INT NOT NULL,
    DayOfWeekName NVARCHAR(15) NOT NULL,
    IsWeekend BIT NOT NULL
);
GO

-- 2. Populate the Table using a loop (2019 to 2025)
DECLARE @StartDate DATE = '2019-01-01';
DECLARE @EndDate DATE = '2025-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO dbo.Dim_Date (
        DateKey, FullDate, [Year], [Quarter], [Month], 
        MonthName, [DayOfMonth], DayOfWeekName, IsWeekend
    )
    VALUES (
        CAST(FORMAT(@StartDate, 'yyyyMMdd') AS INT), -- e.g., 20190101
        @StartDate,
        YEAR(@StartDate),
        DATEPART(qq, @StartDate),
        MONTH(@StartDate),
        DATENAME(month, @StartDate),
        DAY(@StartDate),
        DATENAME(weekday, @StartDate),
        CASE WHEN DATEPART(weekday, @StartDate) IN (1, 7) THEN 1 ELSE 0 END -- 1=Sunday, 7=Saturday
    );

    SET @StartDate = DATEADD(day, 1, @StartDate);
END;
GO