IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('AdventureWorks2017.Person.Person') AND NAME ='IX_Person_FirstName')
    DROP INDEX IX_Person_FirstName ON [AdventureWorks2017].[Person].[Person];
GO
CREATE INDEX IX_Person_FirstName ON [AdventureWorks2017].[Person].[Person](FirstName);
GO