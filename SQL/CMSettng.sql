--Import

SET IDENTITY_INSERT [dbo].[CMSetting]   ON;

INSERT INTO [dbo].[CMSetting]
           ([SettingID]
		   ,[ApplicationID]
           ,[ApplicationName]
           ,[SettingPath]
           ,[APIAlias]
           ,[UpdatedDate]
           ,[AccessLevel]
           ,[Value]
           ,[RuntimeEnvironment]
           ,[VariableName])
select
   c3.value('SettingID[1]','int'),
   c3.value('ApplicationID[1]','int'),
   c3.value('ApplicationName[1]','nvarchar(200)'),
   c3.value('SettingPath[1]','nvarchar(500)'),
   c3.value('APIAlias[1]','nvarchar(200)'),
   c3.value('UpdatedDate[1]','DATETIME'),
   c3.value('AccessLevel[1]','nvarchar(50)'),
   c3.value('Value[1]','nvarchar(max)'),
   c3.value('RuntimeEnvironment[1]','nvarchar(500)'),
   c3.value('VariableName[1]','nvarchar(500)')
from
(
   select 
      cast(c1 as xml)
   from 
      OPENROWSET (BULK 'C:\Users\pravin.sable\Desktop\MASTERCONFIG_636468630009161482.xml',SINGLE_BLOB) as T1(c1)
)as T2(c2)
cross apply c2.nodes('/ArrayOfSetting/Setting') T3(c3);
SET IDENTITY_INSERT [dbo].[CMSetting]  OFF;
SELECT * FROM [dbo].[CMSetting]


--Export

WITH XMLNAMESPACES ('http://www.w3.org/2001/XMLSchema' AS xsd, 'http://www.w3.org/2001/XMLSchema-instance' AS xsi) 
SELECT * FROM [Primordial].[dbo].[CMSetting] FOR XML PATH ('Setting'), ROOT ('ArrayOfSetting')

