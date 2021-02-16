

create table NonNormalisedInspection (
	CompanyName nvarchar(max) not null, 
	Asset nvarchar(max) not null, 
	InspectionDate Date , 
	Requirement nvarchar(max) not null, 
	RequirementComment nvarchar(max) not null, 
	Observation nvarchar(max) not null, 
	Measurement nvarchar(max), 
	Acceptable nvarchar(3), 
	RequirementFollowUp nvarchar(max) 
)

go

insert into NonNormalisedInspection (CompanyName , Asset, InspectionDate , Requirement , RequirementComment 
, Observation , Measurement, Acceptable, RequirementFollowUp) values 
 ('Ocean Traveler', 'Atlantic traveler', '2015-05-01', 'Check propeller condition'    , 'It should be smooth'   , 'Looks OK'        , '(Not applicable)', 'Yes', '')
,('Ocean Traveler', 'Atlantic traveler', '2015-05-01', 'Measure clearing of propeller', 'Minimum 30 millimeters', '(Not applicable)', '55'              , 'Yes', '')
,('Ocean Traveler', 'Atlantic traveler', '2017-05-01', 'Check propeller condition'    , 'It should be smooth'   , 'Propeller has dents', '(Not applicable)', 'No', 'Replace propeller')
,('Ocean Traveler', 'Atlantic traveler', '2017-05-01', 'Measure clearing of propeller', 'Minimum 30 millimeters', '(Not applicable)', '25'                 , 'No', 'Replace bearing')
,('Ocean Traveler', 'Atlantic traveler', '2019-06-01', 'Check propeller condition'    , 'It should be smooth'   , 'Looks OK'        , '(Not applicable)', 'Yes', '')
,('Ocean Traveler', 'Atlantic traveler', '2019-06-01', 'Measure clearing of propeller', 'Minimum 30 millimeters', '(Not applicable)', '60'              , 'Yes', '')

,('Ocean Traveler', 'Pacific traveler', '2015-05-01', 'Check propeller condition'    , 'It should be smooth'   , 'Looks OK'        , '(Not applicable)', 'Yes', '')
,('Ocean Traveler', 'Pacific traveler', '2015-05-01', 'Measure clearing of propeller', 'Minimum 30 millimeters', '(Not applicable)', '53'              , 'Yes', '')
,('Ocean Traveler', 'Pacific traveler', '2017-05-01', 'Check propeller condition'    , 'It should be smooth'   , 'Looks OK'        , '(Not applicable)', 'Yes', '')
,('Ocean Traveler', 'Pacific traveler', '2017-05-01', 'Measure clearing of propeller', 'Minimum 30 millimeters', '(Not applicable)', '50'              , 'Yes','')
,('Ocean Traveler', 'Pacific traveler', '2019-06-01', 'Check propeller condition'    , 'It should be smooth'   , 'Looks OK'        , '(Not applicable)', 'Yes', '')
,('Ocean Traveler', 'Pacific traveler', '2019-06-01', 'Measure clearing of propeller', 'Minimum 30 millimeters', '(Not applicable)', '49'              , 'Yes', '')
,('Star fisheries', 'Morning star', '2015-06-15', 'Check propeller condition'    , 'It should be smooth'   , 'Looks OK'        , '(Not applicable)', 'Yes', '')
,('Star fisheries', 'Morning star', '2017-06-10', 'Check propeller condition'    , 'It should be smooth'   , 'Looks OK'        , '(Not applicable)', 'Yes', '')
,('Star fisheries', 'Morning star', '2019-06-09', 'Check propeller condition'    , 'It should be smooth'   , 'Looks OK'        , '(Not applicable)', 'Yes', '')


-- Exercise 1b) --

-- Model New Model
-- Updated 11/22/2019 6:05:00 PM
-- DDL Generated 11/22/2019 11:00:44 PM

--**********************************************************************
--	Tables
--**********************************************************************

-- Table dbo.AssetInspection
create table
	[dbo].[AssetInspection]
(
	[InspectionID] int identity(0,1) not null
	, [Date] date null
	, [Observation] nvarchar(max) not null
	, [AssetID] int not null
,
constraint [Pk_AssetInspection_InspectionID] primary key clustered
(
	[InspectionID] asc
)
);

-- Table dbo.AssetObservation
create table
	[dbo].[AssetObservation]
(
	[ObservationID] int identity(0,1) not null
	, [Measurement] nvarchar(max) null
	, [Acceptable] nvarchar(3) null
	, [FollowUp] nvarchar(max) null
	, [InspectionID] int not null
,
constraint [Pk_AssetObservation_ObservationID] primary key clustered
(
	[ObservationID] asc
)
);

-- Table dbo.AssetRequirements
create table
	[dbo].[AssetRequirements]
(
	[ReuirementID] int identity(0,1) not null
	, [Requirement] nvarchar(max) not null
	, [Comment] nvarchar(max) not null
	, [InspectionID] int not null
,
constraint [Pk_AssetRequirements_ReuirementID] primary key clustered
(
	[ReuirementID] asc
)
);

-- Table dbo.Assets
create table
	[dbo].[Assets]
(
	[AssetID] int identity(0,1) not null
	, [AssetName] nvarchar(max) not null
	, [CompanyID] int not null
,
constraint [Pk_Assets_AssetID] primary key clustered
(
	[AssetID] asc
)
);

-- Table dbo.Companies
create table
	[dbo].[Companies]
(
	[CompanyID] int identity(0,1) not null
	, [CompanyName] nvarchar(max) not null
,
constraint [Pk_Companies_CompanyID] primary key clustered
(
	[CompanyID] asc
)
);
--**********************************************************************
--	Data
--**********************************************************************
--**********************************************************************
--	Relationships
--**********************************************************************

-- Relationship Fk_Assets_AssetInspection_AssetID
alter table [dbo].[AssetInspection]
add constraint [Fk_Assets_AssetInspection_AssetID] foreign key ([AssetID]) references [dbo].[Assets] ([AssetID]);


-- Relationship Fk_AssetInspection_AssetObservation_InspectionID
alter table [dbo].[AssetObservation]
add constraint [Fk_AssetInspection_AssetObservation_InspectionID] foreign key ([InspectionID]) references [dbo].[AssetInspection] ([InspectionID]);


-- Relationship Fk_AssetInspection_AssetRequirements_InspectionID
alter table [dbo].[AssetRequirements]
add constraint [Fk_AssetInspection_AssetRequirements_InspectionID] foreign key ([InspectionID]) references [dbo].[AssetInspection] ([InspectionID]);


-- Relationship Fk_Companies_Assets_CompanyID
alter table [dbo].[Assets]
add constraint [Fk_Companies_Assets_CompanyID] foreign key ([CompanyID]) references [dbo].[Companies] ([CompanyID]);





---------------------------------

-- Exercise 2 --

insert into Companies
select distinct n.CompanyName
from NonNormalisedInspection n

insert into Assets
select distinct n.Asset, c.CompanyID
from NonNormalisedInspection n
join Companies c on c.CompanyName = n.CompanyName

insert into AssetInspection
select distinct n.InspectionDate, n.Observation, a.AssetID
from NonNormalisedInspection n
join Assets a on a.AssetName = n.Asset 
join Companies c on c.CompanyID = a.CompanyID and c.CompanyName = n.CompanyName

insert into AssetRequirements
select distinct n.Requirement, n.RequirementComment, ai.InspectionID
from NonNormalisedInspection n
join Assets a on a.AssetName = n.Asset 
join Companies c on c.CompanyID = a.CompanyID and c.CompanyName = n.CompanyName
join AssetInspection ai on ai.AssetID = a.AssetID and ai.Date = n.InspectionDate and ai.Observation = n.Observation

insert into AssetObservation
select distinct n.Measurement, n.Acceptable, n.RequirementFollowUp, ai.InspectionID
from NonNormalisedInspection n
join Assets a on a.AssetName = n.Asset 
join Companies c on c.CompanyID = a.CompanyID and c.CompanyName = n.CompanyName
join AssetInspection ai on ai.AssetID = a.AssetID and ai.Date = n.InspectionDate and ai.Observation = n.Observation


-- Exercise 3 --

create view InspectionView as (
	select top 15 c.CompanyName, a.AssetName, ai.Date, ar.Requirement, ar.Comment,	ai.Observation, ao.Measurement, ao.Acceptable, ao.FollowUp
	from Companies c
	join Assets a on a.CompanyID = c.CompanyID
	join AssetInspection ai on ai.AssetID = a.AssetID
	join AssetRequirements ar on ar.InspectionID = ai.InspectionID
	join AssetObservation ao on ao.InspectionID = ai.InspectionID
	order by c.CompanyName, a.AssetName, ai.Date
)

select * from InspectionView
