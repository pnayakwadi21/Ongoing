
TRUNCATE TABLE Columnmapper
TRUNCATE TABLE #Columnmap

--CREATE TABLE Columnmapper
--(TableId INT IDENTITY(1,1),
--Colname VARCHAR(100)
--)
CREATE TABLE #Columnmap
(
Colname VARCHAR(100)
)

DECLARE @ColumnmapQuery NVARCHAR(MAX)
DECLARE @JsonCol NVARCHAR(MAX)  

SET @JsonCol=' INSERT INTO #Columnmap
(
    Colname
) values (''	"PostJoinReasonId": null,	''),
(''	            "OccupancyTypeId": null,	''),
(''	            "GradeBasicSalary": null,	''),
(''	            "ProjectedEndDate": "1997-11-28",	''),
(''	            "WorkPatternId": 3,	''),
(''	            "WorkPatternStartDay": null,	''),
(''	            "ApprenticeEndDate": null,	''),
(''	            "HesaFlag": false,	''),
(''	            "RecordEndDate": "1995-12-31",	''),
(''	            "ApprenticeStartDate": null,	''),
(''	            "WorkPatternStartDate": null,	''),
(''	            "ContractHoursWeeksPerYear": null,	''),
(''	            "PositionStatusStartDate": "1992-04-06",	''),
(''	            "WorkerId": 1,	''),
(''	            "WorkPatternEndDate": null,	''),
(''	            "PositionStatusId": 10,	''),
(''	            "GradeOverrideReasonId": null,	''),
(''	            "PostId": 2093,	''),
(''	            "GradeOverrideStep": 0,	''),
(''	            "PostStartDate": "1992-04-06",	''),
(''	            "GradeStartDate": "1992-04-06",	''),
(''	            "RecordStartDate": "1992-04-06",	''),
(''	            "ServiceConditionEndDate": null,	''),
(''	            "ContractHours": 6.00,	''),
(''	            "ContractHoursStartDate": "1992-04-06",	''),
(''	            "PostLeaveReasonId": 20,	''),
(''	            "WorkPatternReasonId": null,	''),
(''	            "LocationStartDate": null,	''),
(''	            "PositionStatusEndDate": "1997-11-28",	''),
(''	            "GradeCarryForward": false,	''),
(''	            "ContractHoursEndDate": "1997-11-28",	''),
(''	            "MultiWeeks": null,	''),
(''	            "ContractNo": null,	''),
(''	            "WorkerPostId": 1,	''),
(''	            "GradeCurrentPoint": "        33",	''),
(''	            "GradeEndDate": "1997-09-30",	''),
(''	            "WorkPatternNoTimesFlag": false,	''),
(''	            "ServiceConditionStartDate": null,	''),
(''	            "ContractHoursFTE": 35.00,	''),
(''	            "LocationId": 918,	''),
(''	            "FTE": 0.1714,	''),
(''	            "GradeReasonId": null,	''),
(''	            "GradeId": 61,	''),
(''	            "IsSuspended": false,	''),
(''	            "MultiHours": null,	''),
(''	            "CostCentreSourceId": null,	''),
(''	            "ServiceConditionId": null,	''),
(''	            "GradeOverrideDate": null,	''),
(''	            "LocationReasonId": null,	''),
(''	            "IsMainPost": true,	''),
(''	            "PostEndDate": "1997-11-28",	''),
(''	            "LocationEndDate": null	'')
'--,



exec(@JsonCol)

INSERT INTO Columnmapper(Colname)
SELECT SUBSTRING(colname,CHARINDEX('"',Colname,1)+1,CHARINDEX(':',Colname,1)-CHARINDEX('"',Colname,1)-2)
FROM #Columnmap

DECLARE @JmapSt varchar(100)='''{
                        "type": "TabularTranslator",
                        "mappings": [',
        @JmapEnd  varchar(100)=' ],
                        "collectionReference": "$[''''value'''']"
                    }'''

DECLARE @cnt INT,
	@JmapQuery nvarchar(max)='',
	@MapCol   VARCHAR(500)='',
	@Colname nVARCHAR(max),
	@Query    NVARCHAR(MAX)
					
					

	SELECT @cnt=COUNT(*) FROM Columnmapper
	SELECT @cnt

	WHILE @cnt>0
	begin
	SELECT TOP 1 @MapCol=colname FROM Columnmapper
	WHERE tableid=@cnt
	SET @Colname=',
                            {
                                "source": {
                                    "path": "['''''+@MapCol+''''']"
                                },
                                "sink": {
                                    "name": "'+@MapCol+'",
                                    "type": "String"
                                }
                            }'
	
		set  @JmapQuery=@JmapQuery+@Colname
	SET @cnt=@cnt-1
	END 
set  @JmapQuery=SUBSTRING(@JmapQuery,2,LEN(@JmapQuery)-1)
		SET  @Query=@JmapSt+@JmapQuery+@JmapEnd






		DECLARE @finalquery NVARCHAR(MAX)



SET @finalquery='		UPDATE  metadata

SET cref='+@Query+'


--DELETE  metadata
WHERE desttable=''WorkerPosts'''
EXEC(@finalquery)



DECLARE @table_create nvarchar(MAX)=''
DECLARE @table_final nvarchar(MAX)=''
SELECT  @table_create=@table_create+colname+' varchar(100) , '  FROM columnmapper
SET @table_final='create table WorkerPosts_new  ( '+SUBSTRING(@table_create,1,LEN(@table_create)-1)+' )'
exec (@table_final)



------------------------------------------




 INSERT INTO #Columnmap  (      Colname  ) values ('' "PostJoinReasonId": null, '')


	

--('	            "GradeBasicSalary": null,	'),
--('	            "ProjectedEndDate": "1997-11-28",	'),
--('	            "WorkPatternId": 3,	'),
--('	            "WorkPatternStartDay": null,	'),
--('	            "ApprenticeEndDate": null,	'),
--('	            "HesaFlag": false,	'),
--('	            "RecordEndDate": "1995-12-31",	'),
--('	            "ApprenticeStartDate": null,	'),
--('	            "WorkPatternStartDate": null,	'),
--('	            "ContractHoursWeeksPerYear": null,	'),
--('	            "PositionStatusStartDate": "1992-04-06",	'),
--('	            "WorkerId": 1,	'),
--('	            "WorkPatternEndDate": null,	'),
--('	            "PositionStatusId": 10,	'),
--('	            "GradeOverrideReasonId": null,	'),
--('	            "PostId": 2093,	'),
--('	            "GradeOverrideStep": 0,	'),
--('	            "PostStartDate": "1992-04-06",	'),
--('	            "GradeStartDate": "1992-04-06",	'),
--('	            "RecordStartDate": "1992-04-06",	'),
--('	            "ServiceConditionEndDate": null,	'),
--('	            "ContractHours": 6.00,	'),
--('	            "ContractHoursStartDate": "1992-04-06",	'),
--('	            "PostLeaveReasonId": 20,	'),
--('	            "WorkPatternReasonId": null,	'),
--('	            "LocationStartDate": null,	'),
--('	            "PositionStatusEndDate": "1997-11-28",	'),
--('	            "GradeCarryForward": false,	'),
--('	            "ContractHoursEndDate": "1997-11-28",	'),
--('	            "MultiWeeks": null,	'),
--('	            "ContractNo": null,	'),
--('	            "WorkerPostId": 1,	'),
--('	            "GradeCurrentPoint": "        33",	'),
--('	            "GradeEndDate": "1997-09-30",	'),
--('	            "WorkPatternNoTimesFlag": false,	'),
--('	            "ServiceConditionStartDate": null,	'),
--('	            "ContractHoursFTE": 35.00,	'),
--('	            "LocationId": 918,	'),
--('	            "FTE": 0.1714,	'),
--('	            "GradeReasonId": null,	'),
--('	            "GradeId": 61,	'),
--('	            "IsSuspended": false,	'),
--('	            "MultiHours": null,	'),
--('	            "CostCentreSourceId": null,	'),
--('	            "ServiceConditionId": null,	'),
--('	            "GradeOverrideDate": null,	'),
--('	            "LocationReasonId": null,	'),
--('	            "IsMainPost": true,	'),
--('	            "PostEndDate": "1997-11-28",	'),
--('	            "LocationEndDate": null	')
--		' 




INSERT INTO #Columnmap
(
    Colname
)
VALUES
('	"PostJoinReasonId": null,	'),
('	            "OccupancyTypeId": null,	'),
('	            "GradeBasicSalary": null,	'),
('	            "ProjectedEndDate": "1997-11-28",	'),
('	            "WorkPatternId": 3,	'),
('	            "WorkPatternStartDay": null,	'),
('	            "ApprenticeEndDate": null,	'),
('	            "HesaFlag": false,	'),
('	            "RecordEndDate": "1995-12-31",	'),
('	            "ApprenticeStartDate": null,	'),
('	            "WorkPatternStartDate": null,	'),
('	            "ContractHoursWeeksPerYear": null,	'),
('	            "PositionStatusStartDate": "1992-04-06",	'),
('	            "WorkerId": 1,	'),
('	            "WorkPatternEndDate": null,	'),
('	            "PositionStatusId": 10,	'),
('	            "GradeOverrideReasonId": null,	'),
('	            "PostId": 2093,	'),
('	            "GradeOverrideStep": 0,	'),
('	            "PostStartDate": "1992-04-06",	'),
('	            "GradeStartDate": "1992-04-06",	'),
('	            "RecordStartDate": "1992-04-06",	'),
('	            "ServiceConditionEndDate": null,	'),
('	            "ContractHours": 6.00,	'),
('	            "ContractHoursStartDate": "1992-04-06",	'),
('	            "PostLeaveReasonId": 20,	'),
('	            "WorkPatternReasonId": null,	'),
('	            "LocationStartDate": null,	'),
('	            "PositionStatusEndDate": "1997-11-28",	'),
('	            "GradeCarryForward": false,	'),
('	            "ContractHoursEndDate": "1997-11-28",	'),
('	            "MultiWeeks": null,	'),
('	            "ContractNo": null,	'),
('	            "WorkerPostId": 1,	'),
('	            "GradeCurrentPoint": "        33",	'),
('	            "GradeEndDate": "1997-09-30",	'),
('	            "WorkPatternNoTimesFlag": false,	'),
('	            "ServiceConditionStartDate": null,	'),
('	            "ContractHoursFTE": 35.00,	'),
('	            "LocationId": 918,	'),
('	            "FTE": 0.1714,	'),
('	            "GradeReasonId": null,	'),
('	            "GradeId": 61,	'),
('	            "IsSuspended": false,	'),
('	            "MultiHours": null,	'),
('	            "CostCentreSourceId": null,	'),
('	            "ServiceConditionId": null,	'),
('	            "GradeOverrideDate": null,	'),
('	            "LocationReasonId": null,	'),
('	            "IsMainPost": true,	'),
('	            "PostEndDate": "1997-11-28",	'),
('	            "LocationEndDate": null	')
		
		
		



--UPDATE #cc
--SET Colname=SUBSTRING(colname,CHARINDEX('"',Colname,1))






--DROP TABLE workers








	DECLARE @cnt INT,
	@JmapQuery nvarchar(max)='',
	@MapCol   VARCHAR(500)='',
	@Colname nVARCHAR(max),
	@Query    NVARCHAR(MAX)
					
					

	SELECT @cnt=COUNT(*) FROM Columnmapper
	SELECT @cnt

	WHILE @cnt>0
	begin
	SELECT TOP 1 @MapCol=colname FROM Columnmapper
	WHERE tableid=@cnt
	SET @Colname=',
                            {
                                "source": {
                                    "path": "['''''+@MapCol+''''']"
                                },
                                "sink": {
                                    "name": "'+@MapCol+'",
                                    "type": "String"
                                }
                            }'
	
		set  @JmapQuery=@JmapQuery+@Colname
	SET @cnt=@cnt-1
	END 
set  @JmapQuery=SUBSTRING(@JmapQuery,2,LEN(@JmapQuery)-1)
		SET  @Query=@JmapSt+@JmapQuery+@JmapEnd

		--SELECT @Query


		DECLARE @finalquery NVARCHAR(MAX)


SET @finalquery='		UPDATE  metadata

SET cref='+@Query+'


--DELETE  metadata
WHERE desttable=''WorkerPosts'''
EXEC(@finalquery)



