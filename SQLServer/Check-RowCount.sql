select * from Person.Person
IF ((SELECT COUNT(FirstName) as FirstNameCnt
    FROM Person.Person
    WHERE FirstName = 'Kim'
    GROUP BY FirstName ) > 1)
    BEGIN
        RAISERROR('There are more than one projects associated with this import.', 18, -1)
    END

PRINT 'SHOULD NOT SEE THIS'