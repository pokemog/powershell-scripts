SELECT COUNT(ControllerId)
  FROM dbo.es_ControllerActivityLog AS c
  WHERE NOT EXISTS
  (
    SELECT ControllerId FROM dbo.es_Controllers AS p
    WHERE p.ControllerId = c.ControllerId
  );