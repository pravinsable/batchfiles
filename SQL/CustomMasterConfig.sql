SET NOCOUNT ON


 UPDATE [Primordial].[dbo].[CMSetting] SET value = replace(value, 'D:\', 'C:\') where value like 'D:\%'

IF NOT EXISTS(SELECT [SettingID] FROM [CMSetting] WHERE  Apialias='LungScreening.ALERT_WORKER_EXAM_QUERY' AND ApplicationID = 1002 and  RuntimeEnvironment = 'Prod')
    INSERT [dbo].[CMSetting] ([ApplicationID], [ApplicationName], [SettingPath], [APIAlias], [UpdatedDate], [AccessLevel], [Value], [RuntimeEnvironment], [VariableName])  
    VALUES (1002, N'Lung Screening', N'LungScreening.ALERT_WORKER_EXAM_QUERY', N'LungScreening.ALERT_WORKER_EXAM_QUERY', getDate(), N'Internal', N'
      SELECT TOP {BATCHSIZE} * FROM ExamList WITH (NOLOCK)
      WHERE
      ExamList.mrn IN
      (
      SELECT PatientScreening.MRN
      FROM PatientScreening WITH (NOLOCK)
      WHERE
      (PatientScreening.ScreeningStatus = ''Qualified'')
      AND -- 1 year back
      ((
      ExamList.procedureCode IN (''IMG-CTANG'',''IMG-CTCHST'',''CTANGCAP'',''CTANGCHABD'',''CTANGCHEST'',''CTHRCT'', ''CTTHORAX-'', ''CTTHORAXPE'', ''CTTHORAXW'', ''CTTHORAXW-'', ''CTTPEVENLE'', ''NMPCTE'', ''XRCHEST2'')
      AND ExamList.examDt >= DATEADD(YEAR, -1, GETDATE())
      )
      AND -- not already alerted
      (ExamList.accession NOT IN (SELECT accession from PatientScreeningAlert WITH (NOLOCK) WHERE PatientScreeningType = ''LUNG''))))
    ', N'Prod', N'ALERT_WORKER_EXAM_QUERY'); 
ELSE
	UPDATE [CMSetting] SET 
	[Value] =  N'
      SELECT TOP {BATCHSIZE} * FROM ExamList WITH (NOLOCK)
      WHERE
      ExamList.mrn IN
      (
      SELECT PatientScreening.MRN
      FROM PatientScreening WITH (NOLOCK)
      WHERE
      (PatientScreening.ScreeningStatus = ''Qualified'')
      AND -- 1 year back
      ((
      ExamList.procedureCode IN (''IMG-CTANG'',''IMG-CTCHST'',''CTANGCAP'',''CTANGCHABD'',''CTANGCHEST'',''CTHRCT'', ''CTTHORAX-'', ''CTTHORAXPE'', ''CTTHORAXW'', ''CTTHORAXW-'', ''CTTPEVENLE'', ''NMPCTE'', ''XRCHEST2'')
      AND ExamList.examDt >= DATEADD(YEAR, -1, GETDATE())
      )
      AND -- not already alerted
      (ExamList.accession NOT IN (SELECT accession from PatientScreeningAlert WITH (NOLOCK) WHERE PatientScreeningType = ''LUNG''))))
    '
	WHERE  Apialias='LungScreening.ALERT_WORKER_EXAM_QUERY' AND ApplicationID = 1002 and  RuntimeEnvironment = 'Prod';

--1
IF NOT EXISTS(SELECT [SettingID] FROM [CMSetting] WHERE  Apialias='Default.ConnectionStrings.PrimordialConnectionString' AND ApplicationID = 1012 and  RuntimeEnvironment = 'Prod')
    INSERT [dbo].[CMSetting] ([ApplicationID], [ApplicationName], [SettingPath], [APIAlias], [UpdatedDate], [AccessLevel], [Value], [RuntimeEnvironment], [VariableName])  
    VALUES (1012, N'Empericus', N'Default.ConnectionStrings.PrimordialConnectionString', N'Default.ConnectionStrings.PrimordialConnectionString', getDate(), N'Internal',
	 N'K7fBy4eGorVkAZ7acYg+5DVKyaba769resTL/RPWuy54ZBkxud7889xYPdHypglPO6iALUQ6BlGGvKUzgvlQNdHy+Bk8MiCbc4/90/qx0Cbe2fXIhtLAKylUst/JVVIfJbpm+POJrOB/A9XbmWLjKwJQPAQawGRhmXok6qENGAk1gb9gPuSFCL7ytOAaeNyv'
	 , N'Prod', N'PrimordialConnectionString'); 
ELSE
	UPDATE [CMSetting] SET 
	[Value] = N'K7fBy4eGorVkAZ7acYg+5DVKyaba769resTL/RPWuy54ZBkxud7889xYPdHypglPO6iALUQ6BlGGvKUzgvlQNdHy+Bk8MiCbc4/90/qx0Cbe2fXIhtLAKylUst/JVVIfJbpm+POJrOB/A9XbmWLjKwJQPAQawGRhmXok6qENGAk1gb9gPuSFCL7ytOAaeNyv'
	 WHERE  Apialias='Default.ConnectionStrings.PrimordialConnectionString' AND ApplicationID = 1012 and  RuntimeEnvironment = 'Prod';

--2
IF NOT EXISTS(SELECT [SettingID] FROM [CMSetting] WHERE  Apialias='Default.ConnectionStrings.ExamListConnectionString' AND ApplicationID = 1012 and  RuntimeEnvironment = 'Prod')
    INSERT [dbo].[CMSetting] ([ApplicationID], [ApplicationName], [SettingPath], [APIAlias], [UpdatedDate], [AccessLevel], [Value], [RuntimeEnvironment], [VariableName])  
    VALUES (1012, N'Empericus', N'Default.ConnectionStrings.ExamListConnectionString', N'Default.ConnectionStrings.ExamListConnectionString', getDate(), N'Internal', 
	N'S+k/gZ2KkXqxRvlV9oOm+AGBQij/5Brb7uT1PB3w9R0YX52BU9BzljNT7XwCIb9fEUHQq7CT8r2c+g3JkC/SbOlhVXGR7Nz1ybyy18vNhXEieBOejzSRadZISing40JxD9E8WdGGaHmOmo0M8ruqJED22fgavXLyUUzF/U5qtI/NyPo2aQidKCKo6dn74xxW'
	, N'Prod', N'ExamListConnectionString'); 
ELSE
	UPDATE [CMSetting] SET 
	[Value] = N'S+k/gZ2KkXqxRvlV9oOm+AGBQij/5Brb7uT1PB3w9R0YX52BU9BzljNT7XwCIb9fEUHQq7CT8r2c+g3JkC/SbOlhVXGR7Nz1ybyy18vNhXEieBOejzSRadZISing40JxD9E8WdGGaHmOmo0M8ruqJED22fgavXLyUUzF/U5qtI/NyPo2aQidKCKo6dn74xxW'
	WHERE  Apialias='Default.ConnectionStrings.ExamListConnectionString' AND ApplicationID = 1012 and  RuntimeEnvironment = 'Prod';

--3
IF NOT EXISTS(SELECT [SettingID] FROM [CMSetting] WHERE  Apialias='Default.ConnectionStrings.HL7ProcessingConnectionString' AND ApplicationID = 1012 and  RuntimeEnvironment = 'Prod')
    INSERT [dbo].[CMSetting] ([ApplicationID], [ApplicationName], [SettingPath], [APIAlias], [UpdatedDate], [AccessLevel], [Value], [RuntimeEnvironment], [VariableName])  
    VALUES (1012, N'Empericus', N'Default.ConnectionStrings.HL7ProcessingConnectionString', N'Default.ConnectionStrings.HL7ProcessingConnectionString', getDate(), N'Internal',
	 N'K7fBy4eGorVkAZ7acYg+5DVKyaba769resTL/RPWuy54ZBkxud7889xYPdHypglPO6iALUQ6BlGGvKUzgvlQNdHy+Bk8MiCbc4/90/qx0Cbe2fXIhtLAKylUst/JVVIfJbpm+POJrOB/A9XbmWLjKwJQPAQawGRhmXok6qENGAk1gb9gPuSFCL7ytOAaeNyv'
	 , N'Prod', N'HL7ProcessingConnectionString'); 
ELSE
	UPDATE [CMSetting] SET 
	[Value] = N'K7fBy4eGorVkAZ7acYg+5DVKyaba769resTL/RPWuy54ZBkxud7889xYPdHypglPO6iALUQ6BlGGvKUzgvlQNdHy+Bk8MiCbc4/90/qx0Cbe2fXIhtLAKylUst/JVVIfJbpm+POJrOB/A9XbmWLjKwJQPAQawGRhmXok6qENGAk1gb9gPuSFCL7ytOAaeNyv'
	WHERE  Apialias='Default.ConnectionStrings.HL7ProcessingConnectionString' AND ApplicationID = 1012 and  RuntimeEnvironment = 'Prod';

--4
IF NOT EXISTS(SELECT [SettingID] FROM [CMSetting] WHERE  Apialias='Default.ConnectionStrings.PrimordialAuditConnectionString' AND ApplicationID = 1012 and  RuntimeEnvironment = 'Prod')
    INSERT [dbo].[CMSetting] ([ApplicationID], [ApplicationName], [SettingPath], [APIAlias], [UpdatedDate], [AccessLevel], [Value], [RuntimeEnvironment], [VariableName])  
    VALUES (1012, N'Empericus', N'Default.ConnectionStrings.PrimordialAuditConnectionString', N'Default.ConnectionStrings.PrimordialAuditConnectionString', getDate(), N'Internal',  
	N'oL/H14Lg1Uu2fbgAsEvogvle5p4e8styFPEsG2+uwqjBbcNI1rDpW+lQulBq/r98yqXrOnW1jMWFh/XOB9crj/YsbXbHClqNGORMGqefZg1n6V8LAchGnfN8mM0g/uODPgMU0pR0aRw+nLtF+xt6l0Od4pnrf6iZjG3Q+bgg3wo='
	, N'Prod', N'PrimordialAuditConnectionString'); 
ELSE
	UPDATE [CMSetting] SET 
	[Value] = N'oL/H14Lg1Uu2fbgAsEvogvle5p4e8styFPEsG2+uwqjBbcNI1rDpW+lQulBq/r98yqXrOnW1jMWFh/XOB9crj/YsbXbHClqNGORMGqefZg1n6V8LAchGnfN8mM0g/uODPgMU0pR0aRw+nLtF+xt6l0Od4pnrf6iZjG3Q+bgg3wo='
	WHERE  Apialias='Default.ConnectionStrings.PrimordialAuditConnectionString' AND ApplicationID = 1012 and  RuntimeEnvironment = 'Prod';


--5	
IF NOT EXISTS(SELECT [SettingID] FROM [CMSetting] WHERE  Apialias='dbPrimordial' AND ApplicationID = 1008 and  RuntimeEnvironment = 'Prod')
    INSERT [dbo].[CMSetting] ([ApplicationID], [ApplicationName], [SettingPath], [APIAlias], [UpdatedDate], [AccessLevel], [Value], [RuntimeEnvironment], [VariableName])  
    VALUES (1008, N'General', N'dbPrimordial', N'dbPrimordial', getDate(), N'Internal', 
	N'TV9Q2J14y0zRDLfX56tejqX1URRsKrhdmvgWb03AiUB50EeOwYUsDosADu9+IW+2YPHWI1tMncnFFK3o04Y+JLtR7kXRxQvPHGUq66Tilrf87lRga5Di5OB4o4n9U+sWNTL+7pRZsoKUp36CHBnODzpuJ6FL/dLCFsYyjHxoUAkUewksp+fzk37Pp4kplWIf'
	, N'Prod', N'dbPrimordial'); 
ELSE
	UPDATE [CMSetting] SET 
	[Value] = N'TV9Q2J14y0zRDLfX56tejqX1URRsKrhdmvgWb03AiUB50EeOwYUsDosADu9+IW+2YPHWI1tMncnFFK3o04Y+JLtR7kXRxQvPHGUq66Tilrf87lRga5Di5OB4o4n9U+sWNTL+7pRZsoKUp36CHBnODzpuJ6FL/dLCFsYyjHxoUAkUewksp+fzk37Pp4kplWIf'
	WHERE  Apialias='dbPrimordial' AND ApplicationID = 1008 and  RuntimeEnvironment = 'Prod';

--6
IF NOT EXISTS(SELECT [SettingID] FROM [CMSetting] WHERE  Apialias='dbRadFlow2' AND ApplicationID = 1008 and  RuntimeEnvironment = 'Prod')
    INSERT [dbo].[CMSetting] ([ApplicationID], [ApplicationName], [SettingPath], [APIAlias], [UpdatedDate], [AccessLevel], [Value], [RuntimeEnvironment], [VariableName])  
    VALUES (1008, N'General', N'dbRadFlow2', N'dbRadFlow2', getDate(), N'Internal', 
	N'TV9Q2J14y0zRDLfX56tejqX1URRsKrhdmvgWb03AiUB50EeOwYUsDosADu9+IW+2YPHWI1tMncnFFK3o04Y+JLtR7kXRxQvPHGUq66Tilrf87lRga5Di5OB4o4n9U+sWNTL+7pRZsoKUp36CHBnODzpuJ6FL/dLCFsYyjHxoUAkUewksp+fzk37Pp4kplWIf'
	, N'Prod', N'dbRadFlow2'); 
ELSE
	UPDATE [CMSetting] SET 
	[Value] = N'TV9Q2J14y0zRDLfX56tejqX1URRsKrhdmvgWb03AiUB50EeOwYUsDosADu9+IW+2YPHWI1tMncnFFK3o04Y+JLtR7kXRxQvPHGUq66Tilrf87lRga5Di5OB4o4n9U+sWNTL+7pRZsoKUp36CHBnODzpuJ6FL/dLCFsYyjHxoUAkUewksp+fzk37Pp4kplWIf '
	WHERE  Apialias='dbRadFlow2' AND ApplicationID = 1008 and  RuntimeEnvironment = 'Prod'  ;	

--7
IF NOT EXISTS(SELECT [SettingID] FROM [CMSetting] WHERE  Apialias='LungScreening.ACR_CONSTANT_REDIRECT_URL' AND ApplicationID = 1002 and  RuntimeEnvironment = 'Prod')
    INSERT [dbo].[CMSetting] ([ApplicationID], [ApplicationName], [SettingPath], [APIAlias], [UpdatedDate], [AccessLevel], [Value], [RuntimeEnvironment], [VariableName])  
    VALUES (1002, N'Lung Screening', N'LungScreening.ACR_CONSTANT_REDIRECT_URL', N'LungScreening.ACR_CONSTANT_REDIRECT_URL', getDate(), N'Internal', N'http://mysite.com/redirect', N'Prod', N'ACR_CONSTANT_REDIRECT_URL'); 
ELSE
	UPDATE [CMSetting] SET 
	[Value] =  N'http://mysite.com/redirect'
	WHERE  Apialias='LungScreening.ACR_CONSTANT_REDIRECT_URL' AND ApplicationID = 1002 and  RuntimeEnvironment = 'Prod';


--USERS
USE [Primordial]
GO
IF NOT EXISTS(SELECT * FROM [dbo].[Users] WHERE [loginID]=N'nuance\pravin.sable')
INSERT [dbo].[Users] ([loginID], [loginID2], [loginID3], [fullName], [providerID], [providerID2], [providerID3], [providerID4], [providerID5], [providerID6], [password], [title], [phone1], [phone2], [other], [cellPhone], [smsText], [voiceMail], [pager], [email], [fax], [workstation], [enabled], [roles], [groups], [isSuperUser], [officeLocation], [department], [active], [isImageXUser], [imageXUserName], [imageXPassword], [defaultWorkflowLocationDBColum], [defaultWorkflowLocationDBValue], [providerType], [subSpecialty], [specialty], [internalMD], [lastName], [firstName], [state], [zip1], [zip2], [RadPeerID], [npiID], [upinID], [risID], [sex], [middleName], [isPeerReviewManager], [section], [updatedDt], [isLibraryManager], [RadPeerGroupID], [RadGroup], [isEnterprisePeerReviewManager], [IsResident], [isAddressActive], [isAttending], [canOrderExam], [canBePerforming], [canBeContributing], [canBeResponsible], [autoReportDistribution], [printReportDistribution], [faxReportDistribution], [providerDegree], [street1], [street2], [city], [phoneAreaCode], [providerInternalGEID], [canImpersonate], [CanAccessToNotifier], [HasNotifierGroup], [organization], [lastLoginDt], [npID], [refMdId], [providerIdOrg], [address], [isFellow], [updatedBy], [disabledDt], [suffix], [linkedProviderIds]) VALUES ( N'nuance\pravin.sable', NULL, NULL, N'Pravin Sable', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'000', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
IF NOT EXISTS(SELECT * FROM [dbo].[Users] WHERE [loginID]=N'pravin.sable@nuance.com')
INSERT [dbo].[Users] ([loginID], [loginID2], [loginID3], [fullName], [providerID], [providerID2], [providerID3], [providerID4], [providerID5], [providerID6], [password], [title], [phone1], [phone2], [other], [cellPhone], [smsText], [voiceMail], [pager], [email], [fax], [workstation], [enabled], [roles], [groups], [isSuperUser], [officeLocation], [department], [active], [isImageXUser], [imageXUserName], [imageXPassword], [defaultWorkflowLocationDBColum], [defaultWorkflowLocationDBValue], [providerType], [subSpecialty], [specialty], [internalMD], [lastName], [firstName], [state], [zip1], [zip2], [RadPeerID], [npiID], [upinID], [risID], [sex], [middleName], [isPeerReviewManager], [section], [updatedDt], [isLibraryManager], [RadPeerGroupID], [RadGroup], [isEnterprisePeerReviewManager], [IsResident], [isAddressActive], [isAttending], [canOrderExam], [canBePerforming], [canBeContributing], [canBeResponsible], [autoReportDistribution], [printReportDistribution], [faxReportDistribution], [providerDegree], [street1], [street2], [city], [phoneAreaCode], [providerInternalGEID], [canImpersonate], [CanAccessToNotifier], [HasNotifierGroup], [organization], [lastLoginDt], [npID], [refMdId], [providerIdOrg], [address], [isFellow], [updatedBy], [disabledDt], [suffix], [linkedProviderIds]) VALUES ( N'pravin.sable@nuance.com', NULL, NULL, N'Pravin Sable', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'012', N'004', 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Pravin', N'Sable', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2018-01-11T11:34:55.000' AS DateTime), 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
IF NOT EXISTS(SELECT * FROM [dbo].[Users] WHERE fullName=N'PROVID-RAD1')
INSERT [dbo].[Users] ([loginID], [loginID2], [loginID3], [fullName], [providerID], [providerID2], [providerID3], [providerID4], [providerID5], [providerID6], [password], [title], [phone1], [phone2], [other], [cellPhone], [smsText], [voiceMail], [pager], [email], [fax], [workstation], [enabled], [roles], [groups], [isSuperUser], [officeLocation], [department], [active], [isImageXUser], [imageXUserName], [imageXPassword], [defaultWorkflowLocationDBColum], [defaultWorkflowLocationDBValue], [providerType], [subSpecialty], [specialty], [internalMD], [lastName], [firstName], [state], [zip1], [zip2], [RadPeerID], [npiID], [upinID], [risID], [sex], [middleName], [isPeerReviewManager], [section], [updatedDt], [isLibraryManager], [RadPeerGroupID], [RadGroup], [isEnterprisePeerReviewManager], [IsResident], [isAddressActive], [isAttending], [canOrderExam], [canBePerforming], [canBeContributing], [canBeResponsible], [autoReportDistribution], [printReportDistribution], [faxReportDistribution], [providerDegree], [street1], [street2], [city], [phoneAreaCode], [providerInternalGEID], [canImpersonate], [CanAccessToNotifier], [HasNotifierGroup], [organization], [lastLoginDt], [npID], [refMdId], [providerIdOrg], [address], [isFellow], [updatedBy], [disabledDt], [suffix], [linkedProviderIds]) VALUES ( NULL, NULL, NULL, N'PROVID-RAD1', N'PROVID-RAD1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Boston', N'Medical', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'PROVID-RAD1', N'PROVID-RAD1', N'MA', N'01757', NULL, NULL, N'NPI-RAD1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Mass Ave', NULL, N'Boston', N'617', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
IF NOT EXISTS(SELECT * FROM [dbo].[Users] WHERE fullName=N'PROVID-ORD1')
INSERT [dbo].[Users] ([loginID], [loginID2], [loginID3], [fullName], [providerID], [providerID2], [providerID3], [providerID4], [providerID5], [providerID6], [password], [title], [phone1], [phone2], [other], [cellPhone], [smsText], [voiceMail], [pager], [email], [fax], [workstation], [enabled], [roles], [groups], [isSuperUser], [officeLocation], [department], [active], [isImageXUser], [imageXUserName], [imageXPassword], [defaultWorkflowLocationDBColum], [defaultWorkflowLocationDBValue], [providerType], [subSpecialty], [specialty], [internalMD], [lastName], [firstName], [state], [zip1], [zip2], [RadPeerID], [npiID], [upinID], [risID], [sex], [middleName], [isPeerReviewManager], [section], [updatedDt], [isLibraryManager], [RadPeerGroupID], [RadGroup], [isEnterprisePeerReviewManager], [IsResident], [isAddressActive], [isAttending], [canOrderExam], [canBePerforming], [canBeContributing], [canBeResponsible], [autoReportDistribution], [printReportDistribution], [faxReportDistribution], [providerDegree], [street1], [street2], [city], [phoneAreaCode], [providerInternalGEID], [canImpersonate], [CanAccessToNotifier], [HasNotifierGroup], [organization], [lastLoginDt], [npID], [refMdId], [providerIdOrg], [address], [isFellow], [updatedBy], [disabledDt], [suffix], [linkedProviderIds]) VALUES (NULL, NULL, NULL, N'PROVID-ORD1', N'PROVID-ORD1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', NULL, 1, NULL, NULL, NULL, N'Boston', N'Medical', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', NULL, N'', N'', N'', N'', NULL, NULL, N'', NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2018-02-11T18:13:10.827' AS DateTime), 0, NULL, N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', N'', N'', N'617', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'LS - Update Provider', NULL, NULL, NULL)
GO
UPDATE [dbo].[Users]  SET password=  '4rr8DL6qmk6HurYFiZla9GFkbWlu' WHERE loginID='admin';
