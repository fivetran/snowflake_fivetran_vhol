/*************************
DBA MODE 
**************************/


-----
--A--
-----
--Let's set our worksheet role and db/schema
use role ACCOUNTADMIN;
use schema PC_FIVETRAN_DB.GOOGLE_ADS_DBT;


-----
--B--
-----
--Make a new DEV db and schema and then clone the 3 key tables for isolated analysis and experimentation
create database GOOGLE_ADS_DEV clone PC_FIVETRAN_DB;
use schema GOOGLE_ADS_DEV.GOOGLE_ADS_DBT;

-----
--C--
-----
--Create a virtual warehouse (compute) for the Marketing Analyst team to do their work
create or replace warehouse MKT_ANALYSIS 
with 
warehouse_size = 'XSMALL' 
auto_suspend = 120 --seconds
auto_resume = TRUE;


-----
--D--
-----
--Create a resource monitor to track credit usage of the marketing virtual warehouse
create or replace RESOURCE MONITOR "MARKETING_ANALYSIS" 
with 
CREDIT_QUOTA = 20, 
frequency = 'DAILY', 
start_timestamp = 'IMMEDIATELY', 
end_timestamp = null 
 triggers 
 ON 100 PERCENT DO SUSPEND
 on 5 PERCENT do NOTIFY 
 on 10 PERCENT do NOTIFY 
 on 50 PERCENT do NOTIFY 
 on 90 PERCENT do NOTIFY;
 
alter WAREHOUSE "MKT_ANALYSIS" set RESOURCE_MONITOR = "MARKETING_ANALYSIS";


/*************************
NOW WE ARE IN ANALYST MODE 
**************************/


-----
--E--
-----
--What was the best performing cranberry sauce campaign?
select 
ad_group_name, 
campaign_name, 
sum(spend) as TOT_SPEND, 
sum(clicks) as TOT_CLICKS, 
sum(impressions) as TOT_IMPRESSIONS,
sum(impressions)/sum(spend) as IMPRESSIONS_PER_DOLLAR,
sum(spend)/sum(clicks) as cost_per_click
from 
GOOGLE_ADS__URL_AD_ADAPTER
where ad_group_name = 'cranberry sauce'
group by ad_group_name, campaign_name
order by 6 desc;


-----
--F--
-----
--I wonder,does snowy weather increase clicks?  
--Lets get some weather data from the Snowflake Data Marketplace and combine it with our ad data
--DM steps


-----
--G--
----- 
--With production-sized data sets we might want to join and query tables with billions of rows
--In these cases it's easy and productive to scale up our virtual warehouse so these queries run faster
alter warehouse mkt_analysis set warehouse_size = 'XLARGE';


-----
--H--
-----
--Is there any correlation between clicks and snowfall for any ad group?
select 
ad_group_name,
abs(corr(clicks,w.tot_snowfall_in)) as clicks_snow_corr
from 
GOOGLE_ADS__URL_AD_ADAPTER ga, 
"WEATHERSOURCE"."PUBLIC"."HISTORY_DAY" w
where ga.date_day = w.date_valid_std
group by 1
order by 2 desc;

-----
--I--
-----
--Let's create new view with the correlations built in to the URL_AD_ADAPTER data
create or replace view GOOGLE_ADS__URL_AD_ADAPTER_CORR
as (
with 
corr as (
select 
ad_group_name,
abs(corr(clicks,w.tot_snowfall_in)) as clicks_snow_corr
from GOOGLE_ADS__URL_AD_ADAPTER ga, "WEATHERSOURCE"."PUBLIC"."HISTORY_DAY" w
where ga.date_day = w.date_valid_std
group by 1
),
base as (
select * from GOOGLE_ADS__URL_AD_ADAPTER
)
select b.*,c.clicks_snow_corr 
from base b, corr c
where b.ad_group_name = c.ad_group_name
);
 
select * from GOOGLE_ADS__URL_AD_ADAPTER_CORR; 
 

-----
--J--
-----
--Once we're done with our complex queries we scale the warehouse back down
alter warehouse mkt_analysis set warehouse_size = 'XSMALL';


-----
--K--
-----
--Let's look at one last great feature of Snowflake.  Have you ever accidentally dropped a table?  Or a database?  
--Let's 'accidentally' drop a table.
drop table GOOGLE_ADS__URL_AD_ADAPTER; 

--Fortunately, in Snowflake, this is an easy fix.
undrop table GOOGLE_ADS__URL_AD_ADAPTER;