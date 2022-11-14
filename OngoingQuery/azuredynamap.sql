


INSERT INTO metadata
SELECT apiref,'Workers',cref FROM [dbo].[metadata]
WHERE desttable='ZellisPost'


UPDATE  metadata

SET apiref=REPLACE(apiref,'Posts','Workers')


--DELETE  metadata
WHERE desttable='Workers'



UPDATE  metadata

SET cref=
'{                          "type": "TabularTranslator",                          "mappings": [                              {                                  "source": {                                      "path": "[''Surname'']"                                  },                                  "sink": {                                      "name": "Surname",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''AddressId'']"                                  },                                  "sink": {                                      "name": "AddressId",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''WorkerId'']"                                  },                                  "sink": {                                      "name": "WorkerId",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''LeaveDate'']"                                  },                                  "sink": {                                      "name": "LeaveDate",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''FirstForename'']"                                  },                                  "sink": {                                      "name": "FirstForename",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''TitleId'']"                                  },                                  "sink": {                                      "name": "TitleId",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''KnownAs'']"                                  },                                  "sink": {                                      "name": "KnownAs",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''CurrentStartDate'']"                                  },                                  "sink": {                                      "name": "CurrentStartDate",                                      "type": "String"                                  }                              } ],                          "collectionReference": "$[''value'']"                      }'

WHERE desttable='workers'


--'{
--                        "type": "TabularTranslator",
--                        "mappings": [
--                            {
--                                "source": {
--                                    "path": "[''FirstForename'']"
--                                },
--                                "sink": {
--                                    "name": "FirstForename",
--                                    "type": "String"
--                                }
--                            },
--                            {
--                                "source": {
--                                    "path": "[''Surname'']"
--                                },
--                                "sink": {
--                                    "name": "Surname",
--                                    "type": "String"
--                                }
--                            },
--                            {
--                                "source": {
--                                    "path": "[''KnownAs'']"
--                                },
--                                "sink": {
--                                    "name": "KnownAs",
--                                    "type": "String"
--                                }
--                            },
--                            {
--                                "source": {
--                                    "path": "[''TitleId'']"
--                                },
--                                "sink": {
--                                    "name": "TitleId",
--                                    "type": "String"
--                                }
--                            },
--                            {
--                                "source": {
--                                    "path": "[''CurrentStartDate'']"
--                                },
--                                "sink": {
--                                    "name": "CurrentStartDate",
--                                    "type": "String"
--                                }
--                            },
--                            {
--                                "source": {
--                                    "path": "[''WorkerId'']"
--                                },
--                                "sink": {
--                                    "name": "WorkerId",
--                                    "type": "String"
--                                }
--                            } ,
--                            {
--                                "source": {
--                                    "path": "[''AddressId'']"
--                                },
--                                "sink": {
--                                    "name": "AddressId",
--                                    "type": "String"
--                                }
--                            } ,
--                            {
--                                "source": {
--                                    "path": "[''LeaveDate'']"
--                                },
--                                "sink": {
--                                    "name": "LeaveDate",
--                                    "type": "String"
--                                }
--                            }    
--                        ],
--                        "collectionReference": "$[''value'']"

        ---            }'


					



--WHERE desttable='workers'



-------'{                          "type": "TabularTranslator",                          "mappings": [                           
----   {                                  "source": {  "path": "[''AddressId'']"  },   
----                                      "sink": { "name": "AddressId",  "type": "String"   }   },                              
----									  { "source": { "path": "[''WorkerId'']"                                  },                                  "sink": {                                      "name": "WorkerId",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''LeaveDate'']"                                  },                                  "sink": {                                      "name": "LeaveDate",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''FirstForeName'']"                                  },                                  "sink": {                                      "name": "FirstForeName",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''TitleId'']"                                  },                                  "sink": {                                      "name": "TitleId",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''KnownAs'']"                                  },                                  "sink": {                                      "name": "KnownAs",                                      "type": "String"                                  }                              },                              {                                  "source": {                                      "path": "[''CurrentStartDate'']"                                  },                                  "sink": {                                      "name": "CurrentStartDate",                                      "type": "String"                                  }                              } ],                          "collectionReference": "$[''value'']"                      }'


DROP TABLE #cc
 SELECT 'CurrentStartDate' [name] ,IDENTITY(INT,1,1) ID INTO #cc
 INSERT INTO #cc(name) VALUEs ('KnownAs'),('TitleId'),('FirstForename'),('LeaveDate'),('WorkerId'),('AddressId'),('Surname')

DECLARE @JmapSt varchar(100)='''{
                        "type": "TabularTranslator",
                        "mappings": [',
        @JmapEnd  varchar(100)=' ],
                        "collectionReference": "$[''''value'''']"
                    }'''
		
--SELECT @JmapEnd



	DECLARE @cnt INT,
	@JmapQuery nvarchar(max)='',
			@MapCol   VARCHAR(500)='',
					@Colname nVARCHAR(max),
					@Query NVARCHAR(MAX)
					
					

	SELECT @cnt=COUNT(*) FROM #cc
	SELECT @cnt

	WHILE @cnt>0
	begin
	SELECT TOP 1 @MapCol=name FROM #cc
	WHERE id=@cnt
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
WHERE desttable=''Workers'''
EXEC(@finalquery)
