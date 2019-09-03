IF (OBJECT_ID('dbo.FK_es_ControllerActivityLog_es_Controllers', 'F') IS NOT NULL)
BEGIN
    ALTER TABLE dbo.es_ControllerActivityLog DROP CONSTRAINT FK_es_ControllerActivityLog_es_Controllers
    RAISERROR (N'Dropping constraint', -- Message text.  
           10, -- Severity,  
           1 -- State,  
           -- N'number', -- First argument.  
           -- 5); -- Second argument. 
    );
END