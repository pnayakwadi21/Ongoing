

IF OBJECT_ID('tempdb..#date') IS NOT NULL DROP  TABLE #date

IF OBJECT_ID('tempdb..#bankholidays') IS NOT NULL DROP  TABLE #bankholidays


DECLARE @START_DATE  DATE ='1900/01/01' ,
        @END_DATE    DATE='2028/12/02' ,
		@CalenderYear Int,
		@CalenderMonth INT


CREATE TABLE #DATE (Calender_Date DATE,Caleder_Week INT,Fiscal_Date DATE,Fiscal_Week INT ,
DayOfMonth INT,Weekday INT,Month INT,Year int,
WeekDayName VARCHAR(50),MonthName VARCHAR(20))
WHILE @START_DATE<@END_DATE
BEGIN
INSERT INTO #DATE (Calender_Date,Caleder_Week,Fiscal_Date,Fiscal_Week, DayOfMonth,WeekDay,Month,year,WeekDayName,MonthName)
SELECT @START_DATE Calendar_Date,DatePart(wk,@START_DATE) CalenderWeek
---,DATEADD(Month,3,@START_DATE)
, DATEADD(Month,-3,@START_DATE) Fiscal_Date,
  DATEPART(WEEK,DATEADD(Month,-3,@START_DATE))  FiscalWeek
 
 ,DATEPART(DAY,@START_DATE) [DayOfFMonth]
  ,DATEPART(WEEKDAY,@START_DATE) [DayOfFMonth]
 ,DATEPART(Month,@START_DATE) [Month]
  ,DATEPART(Year,@START_DATE) [Month]
  ,DATENAME(WEEKDAY,@START_DATE)
  , DATENAME(MONTH,@START_DATE)
  
SET @START_DATE=DATEADD(DD,1,@START_DATE)
END 



--SELECT * FROM #DATE
--ORDER BY Calender_Date DESC





--IF OBJECT_ID(N'dbo.PBI_DATE',N'U') IS NOT NULL
--DROP TABLE dbo.PBI_DATE

-- bank holidays till 2023

-------'29-08-2022','26-12-2022','02-01-2023','07-04-2023','10-04-2023','01-05-2023','29-05-2023','28-08-2023','25-12-2023','26-12-2023'



CREATE TABLE #bankholidays
(HolidayDt Date)

INSERT INTO #bankholidays
(
    HolidayDt
)
VALUES
('2022/01/03'),('2022/04/15'),('2022/04/18'),('2022/06/02'),('2022/06/03'),('2022/08/29'),('2022/12/26'),('01-02-2023'),('2023/04/07'),('2023/04/10'),('2023/05/01'),('2023/05/29'),('2023/08/28'),('2023/12/25'),('2023/12/26')





--SELECT * INTO dbo.PBI_DATE FROM #DATE
--ORDER BY Calender_Date DESC

--DROP  TABLE #DATE



  ALTER TABLE #DATE
ADD   IsWorkingDay int


UPDATE r
SET  isworkingday=0

FROM #date r
WHERE  WeekDayName IN ('Saturday','Sunday')

UPDATE r
SET  IsWorkingDay=0

FROM #DATE r
INNER JOIN  #bankholidays e
ON r.Calender_Date=e.HolidayDt

UPDATE r
SET  IsWorkingDay=1

FROM #date r
WHERE IsWorkingDay  IS NULL

IF EXISTS(SELECT 1 FROM dbo.ReportsDate) DROP TABLE dbo.ReportsDate

SELECT * 

INTO  ReportsDate
FROM #DATE


SELECT * FROM dbo.ReportsDate