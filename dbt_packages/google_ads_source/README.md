# Google Ads (Source)

This package models Google Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/google-ads).

## Models

This package contains staging models, designed to work simultaneously with our [Google Ads modeling package](https://github.com/fivetran/dbt_google_ads). The staging models name columns consistently across all packages:
 * Boolean fields are prefixed with `is_` or `has_`
 * Timestamps are appended with `_timestamp`
 * ID primary keys are prefixed with the name of the table. For example, the campaign table's ID column is renamed `campaign_id`.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
To use this package, you will need to pull the following custom reports through Fivetran:

* Destination Table Name: final_url_performance
* Report Type: Final URL Report
* Fields:
  * account_descriptive_name
  * ad_group_id
  * ad_group_name
  * ad_group_status
  * campaign_id
  * campaign_name
  * campaign_status
  * clicks
  * cost
  * date
  * effective_final_url
  * external_customer_id
  * impressions

* Destination Table Name: criteria_performance
* Report Type: Criteria Performance Report
* Fields:
  * account_descriptive_name
  * ad_group_id
  * ad_group_name
  * ad_group_status
  * campaign_id
  * campaign_name
  * campaign_status
  * clicks
  * cost
  * criteria
  * criteria_destination_url
  * criteria_type
  * date
  * external_customer_id
  * id
  * impressions

* Destination Table Name: click_performance
* Report Type: Click Performance Report
* Fields:
  * account_descriptive_name
  * ad_group_id
  * ad_group_name
  * ad_group_status
  * campaign_id
  * campaign_name
  * campaign_status
  * clicks
  * criteria_id
  * date
  * external_customer_id
  * gcl_id

The package assumes that the corresponding destination tables are named `final_url_performance`, `criteria_performance`, and `click_performance` respectively. If these tables have different names in your destination, enter the correct table names in the `google_ads__final_url_performance`, `google_ads__click_performance`, and `google_ads__criteria_performance` variables so that the package can find them:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    google_ads__final_url_performance: "{{ ref('a_model_you_wrote') }}"
    google_ads__click_performance: adwords.click_performance_report
```

By default, this package will look for your Google Ads data in the `adwords` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Google Ads data is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    google_ads_schema: your_schema_name
    google_ads_database: your_database_name
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn more about Fivetran [in the Fivetran docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
