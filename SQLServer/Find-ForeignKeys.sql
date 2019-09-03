SELECT name AS 'Foreign Key Constraint Name', 
	       OBJECT_SCHEMA_NAME(parent_object_id) + '.' + OBJECT_NAME(parent_object_id) AS 'Child Table'
   FROM sys.foreign_keys 
   WHERE OBJECT_SCHEMA_NAME(referenced_object_id) = 'dbo' AND 
              OBJECT_NAME(referenced_object_id) = 'es_Controllers'