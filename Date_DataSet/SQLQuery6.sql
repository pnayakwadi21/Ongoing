DECLARE @START_DATE  DATE ='1900/01/01' ,
        @END_DATE    DATE='2021/12/02' ,
		@CalenderYear Int,
		@CalenderMonth INT


CREATE TABLE #DATE (Calender_Date DATE,Caleder_Week INT,Fiscal_Date DATE,Fiscal_Week INT ,
DayOfMonth INT,Weekday INT,Month INT,
WeekDayName VARCHAR(50),MonthName VARCHAR(20))
WHILE @START_DATE<@END_DATE
BEGIN
INSERT INTO #DATE (Calender_Date,Caleder_Week,Fiscal_Date,Fiscal_Week, DayOfMonth,WeekDay,Month,WeekDayName,MonthName)
SELECT @START_DATE Calendar_Date,DatePart(wk,@START_DATE) CalenderWeek
---,DATEADD(Month,3,@START_DATE)
, DATEADD(Month,-3,@START_DATE) Fiscal_Date,
  DATEPART(WEEK,DATEADD(Month,-3,@START_DATE))  FiscalWeek
 
 ,DATEPART(DAY,@START_DATE) [DayOfFMonth]
  ,DATEPART(WEEKDAY,@START_DATE) [DayOfFMonth]
 ,DATEPART(Month,@START_DATE) [Month]
  ,DATENAME(WEEKDAY,@START_DATE)
  , DATENAME(MONTH,@START_DATE)
  
SET @START_DATE=DATEADD(DD,1,@START_DATE)
END 



SELECT * FROM #DATE
ORDER BY Calender_Date DESC





IF OBJECT_ID(N'dbo.PBI_DATE',N'U') IS NOT NULL
DROP TABLE dbo.PBI_DATE


SELECT * INTO dbo.PBI_DATE FROM #DATE
ORDER BY Calender_Date DESC

DROP  TABLE #DATE



  ALTER TABLE dbo.PBI_DATE
ADD   IsWorkingDay bit


UPDATE r
SET  IsWorkingDay=1

FROM dbo.PBI_DATE r
WHERE  WeekDayName IN ('Saturday','Sunday')

UPDATE r
SET  IsWorkingDay=0

FROM dbo.PBI_DATE r
INNER JOIN  [dbo].[BankHolidays] e
ON r.Calender_Date=e.[uk bank holidays]

UPDATE r
SET  IsWorkingDay=1

FROM dbo.PBI_DATE r
WHERE IsWorkingDay  IS null
