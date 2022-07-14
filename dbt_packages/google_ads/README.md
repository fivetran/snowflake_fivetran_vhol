[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# Google Ads 

This package models Google Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/google-ads).

The main focus of the package is to transform the core ad object tables into analytics-ready models, including an 'ad adapter' model that can be easily unioned in to other ad platform packages to get a single view.  This is especially easy using our [Ad Reporting package](https://github.com/fivetran/dbt_ad_reporting).

## Models

This package contains transformation models, designed to work simultaneously with our [Google Ads source package](https://github.com/fivetran/dbt_google_ads_source) and our [multi-platform Ad Reporting package](https://github.com/fivetran/dbt_ad_reporting). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below.

> Please note this package allows for either `Adwords API` or `Google Ads API` connector configuration. For specific API configuration instructions refer to the [Google Ads source package](https://github.com/fivetran/dbt_google_ads_source). Additionally, not all final models will be generated based off the API being used. Refer to the table below for an understanding of which models will be created per API.

| **model**                       | **description** |**compatible API**                                                                                                                   |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |------------------------------- | 
| [google_ads__url_ad_adapter](https://github.com/fivetran/dbt_google_ads/blob/main/models/url_google_ads/google_ads__url_ad_adapter.sql)      | Each record represents the daily ad performance of each URL in each ad group, including information about the used UTM parameters. | Adwords API and Google Ads API |
| [google_ads__criteria_ad_adapter](https://github.com/fivetran/dbt_google_ads/blob/main/models/criteria/google_ads__criteria_ad_adapter.sql) | Each record represents the daily ad performance of each criteria in each ad group.                                                 | Adwords API Only|
| [google_ads__click_performance](https://github.com/fivetran/dbt_google_ads/blob/main/models/google_ads__click_performance.sql)   | Each record represents a click, with a corresponding Google click ID (gclid).                                                      | Adwords API Only |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/google_ads
    version: [">=0.7.0", "<0.8.0"]
```

## Configuration

This package allows users to leverage either the Adwords API or the Google Ads API. You will be able to determine which API your connector is using by navigating within your Fivetran UI to the `setup` tab -> `edit connection details` link -> and reference the `API configuration` used. You will want to refer to the respective configuration steps below based off the API used by your connector. 

> **Note**: As of April, 2022 all Fivetran Google Ads connectors leverage the Google Ads API rather than Adwords. Additionally, please be aware that the Adwords API version of the package will be sunset in August of 2022.
### Google Ads API Configuration
If your connector is setup using the Google Ads API then you will need to configure your `dbt_project.yml` with the below variable:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  api_source: google_ads  ## google_ads by default, but may be changed to 'adwords' if using a previous version of the connector.
```

### Adwords API Configuration
If your connector is setup using the Adwords API then you will need to pull the following custom reports through Fivetran:

* Destination Table Name: `final_url_performance`
* Report Type: `FINAL_URL_REPORT`
* Fields:
  * AccountDescriptiveName
  * AdGroupId
  * AdGroupName
  * AdGroupStatus
  * CampaignId
  * CampaignName
  * CampaignStatus
  * Clicks
  * Cost
  * Date
  * EffectiveFinalUrl
  * ExternalCustomerId
  * Impressions

* Destination Table Name: `criteria_performance`
* Report Type: `CRITERIA_PERFORMANCE_REPORT`
* Fields:
  * AccountDescriptiveName
  * AdGroupId
  * AdGroupName
  * AdGroupStatus
  * CampaignId
  * CampaignName
  * CampaignStatus
  * Clicks
  * Cost
  * Criteria
  * CriteriaDestinationUrl
  * CriteriaType
  * Date
  * ExternalCustomerId
  * Id
  * Impressions

* Destination Table Name: `click_performance`
* Report Type: `CLICK_PERFORMANCE_REPORT`
* Fields:
  * AccountDescriptiveName
  * AdGroupId
  * AdGroupName
  * AdGroupStatus
  * CampaignId
  * CampaignName
  * CampaignStatus
  * Clicks
  * CriteriaId
  * Date
  * ExternalCustomerId
  * GclId

The package assumes that the corresponding destination tables are named `final_url_performance`, `criteria_performance`, and `click_performance` respectively. If these tables have different names in your destination, enter the correct table names in the `google_ads__final_url_performance`, `google_ads__click_performance`, and `google_ads__criteria_performance` variables so that the package can find them:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    google_ads__final_url_performance: "{{ ref('a_model_you_wrote') }}"
    google_ads__click_performance: adwords.click_performance_report
```
### Source Schema is Named Differently
By default, this package will look for your Google Ads data in the `adwords` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Google Ads data is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    google_ads_source:
      google_ads_schema: your_schema_name
      google_ads_database: your_database_name 
```

For additional configurations for the source models, visit the [Google Ads source package](https://github.com/fivetran/dbt_google_ads_source).

## Optional Configurations
### Passing Through Additional Metrics
By default, this package will select `clicks`, `impressions`, and `cost` from the source reporting tables to store into the ad adapter models. If you would like to pass through additional metrics to the ad adapter models, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
vars:    
    # If you're using the Adwords API source
    google_ads__url_passthrough_metrics: ['the', 'list', 'of', 'metric', 'columns', 'to', 'include'] # from adwords.final_url_performance
    google_ads__criteria_passthrough_metrics: ['the', 'list', 'of', 'metric', 'columns', 'to', 'include'] # from adwords.criteria_performance
    # If you're using the Google Ads API source
    google_ads__ad_stats_passthrough_metrics: ['the', 'list', 'of', 'metric', 'columns', 'to', 'include'] # from google_ads.ad_stats
```

### Changing the Build Schema
By default this package will build the Google Ads staging models within a schema titled (<target_schema> + `_stg_google_ads`) and the Google Ads final models with a schema titled (<target_schema> + `_google_ads`) in your target database. If this is not where you would like your modeled Google Ads data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  google_ads:
    +schema: my_new_schema_name # leave blank for just the target_schema
  google_ads_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
```

## Database Support

This package has been tested on BigQuery, Snowflake, Redshift, Postgres, and Databricks.

### Databricks Dispatch Configuration
dbt `v0.20.0` introduced a new project-level dispatch configuration that enables an "override" setting for all dispatched macros. If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
# dbt_project.yml

dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `main`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate your models with [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
