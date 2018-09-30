SELECT SCHEMA_NAME(schema_id) AS [SchemaName],
[Tables].name AS [TableName],
SUM([Partitions].[rows]) AS [TotalRowCount]
FROM sys.tables AS [Tables]
JOIN sys.partitions AS [Partitions]
ON [Tables].[object_id] = [Partitions].[object_id]
AND [Partitions].index_id IN ( 0, 1 )
-- WHERE [Tables].name = N'name of the table'
GROUP BY SCHEMA_NAME(schema_id), [Tables].name;