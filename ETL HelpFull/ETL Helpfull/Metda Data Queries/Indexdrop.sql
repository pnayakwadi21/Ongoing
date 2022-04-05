IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('#JT')---table name
 AND NAME ='NIX_#JT') ---index name
 DROP INDEX NIX_#JT ON #JT;