select * from Person.Person
IF ((SELECT COUNT(FirstName) as FirstNameCnt
    FROM Person.Person
    WHERE FirstName = 'Kim'
    GROUP BY FirstName ) > 1)
    BEGIN
        RAISERROR('There are more than one projects associated with this import.', 18, -1)
    END

PRINT 'SHOULD NOT SEE THIS'

SELECT(
    SELECT COUNT(*)
        FROM [dbo].[es_InputHoursLog]
) AS InputHoursLog,
(SELECT COUNT(*)
    FROM [dbo].[es_ControllerActivityLog]
    ) AS ControllerActivityLog,
(SELECT COUNT(*)
    FROM [dbo].[es_DeviceActivityLog]
    ) AS DeviceActivityLog,
(SELECT COUNT(*)
    FROM es_MonitorHistoryLog
    ) AS MonitorHistoryLog,
(SELECT COUNT(*)
    FROM [dbo].[es_ControllerConnectionLog]
    ) AS ControllerConnectionLog