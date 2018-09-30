INSERT INTO aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, MobileAlias, IsAnonymous, LastActivityDate)
VALUES ('E731641A-C649-4774-A2FB-65A54F3E9321', 'F204120B-8E9B-491D-8B6E-227C0D3C9D2B', 'mtrang',	'mtrang',	NULL, 0, '2017-10-23 17:28:33.707')

INSERT INTO aspnet_Profile (UserId, PropertyNames, PropertyValuesString, PropertyValuesBinary, LastUpdatedDate)
VALUES ('F204120B-8E9B-491D-8B6E-227C0D3C9D2B',	'AdEmail:S:0:18:HDView:S:18:1:FirstName:S:19:4:LastName:S:23:5:', 'mtrang@gve-eng.com1MinhTrang', 0x, '2017-10-23 17:26:10.420')

INSERT INTO aspnet_UsersInRoles (UserId, RoleId)
VALUES ('F204120B-8E9B-491D-8B6E-227C0D3C9D2B', '52125EE0-34C6-4977-A22D-FF0AE52F0224')

-- DOMAIN - GVE-ENG
INSERT INTO es_AdUsers (AdObjectGuid, AdUserName, AspnetUserId)
VALUES ('8689d966-dc29-4b08-a899-8ff4985a3e15', 'mtrang', 'F204120B-8E9B-491D-8B6E-227C0D3C9D2B')

-- DOMAIN - EXTRON
INSERT INTO es_AdUsers (AdObjectGuid, AdUserName, AspnetUserId)
VALUES ('73642748-517e-40ff-85d8-6f845e8b69dd', 'mtrang', 'F204120B-8E9B-491D-8B6E-227C0D3C9D2B')