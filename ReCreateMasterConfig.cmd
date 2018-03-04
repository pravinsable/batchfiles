cd %~dp0
sqlcmd -S . -E -d Primordial -i .\SQL\CustomMasterConfig.sql 
bcp "WITH XMLNAMESPACES ('http://www.w3.org/2001/XMLSchema' as xsd,'http://www.w3.org/2001/XMLSchema-instance' as xsi ) select * from [Primordial].[dbo].[CMSetting] FOR XML PATH('Setting'),  ROOT('ArrayOfSetting')"  queryout MASTERCONFIG_636540452687764232.xml  -S . -T -w -r
xmllint --format MASTERCONFIG_636540452687764232.xml > C:\PrimordialServer\ConfigManager\MASTERCONFIG_636540452687764232.xml
del MASTERCONFIG_636540452687764232.xml
sed -i "s/D:/C:/g" C:\PrimordialServer\ConfigManager\MASTERCONFIG_636540452687764232.xml

