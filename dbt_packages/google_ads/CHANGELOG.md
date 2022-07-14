# dbt_google_ads v0.7.0
## 🚨 Breaking Changes 🚨
- The `api_source` variable is now defaulted to `google_ads` as opposed to `adwords`. The Adwords API has since been deprecated by Google and is now no longer the standard API for the Google Ads connector. Please ensure you are using a Google Ads API version of the Fivetran connector before upgrading this package. ([#32](https://github.com/fivetran/dbt_google_ads/pull/32))
  - Please note, the `adwords` version of this package will be fully removed from the package in August of 2022. This means, models under `models/adwords_connector` will be removed in favor of `models/google_ads_connector` models.
# dbt_google_ads v0.6.1
- Updated google_ads__url_ad_adapter link in README (Thank you to @bkimjin! ([#26](https://github.com/fivetran/dbt_google_ads/issues/26)))
# dbt_google_ads v0.6.0
## 🚨 Breaking Changes 🚨
- The `account` source table has been renamed to be `account_history`. This has been reflected in the source model references within this release. ([#24](https://github.com/fivetran/dbt_google_ads_source/pull/24))
- The `ad_final_url_history` model has been removed from the connector. The url fields are now references within the `final_urls` field within the `ad_history` table. These changes are reflected in the `google_ads__url_adapter` model. ([#24](https://github.com/fivetran/dbt_google_ads_source/pull/24))
# dbt_google_ads v0.5.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_google_ads_source`. Additionally, the latest `dbt_google_ads_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_google_ads v0.1.0 -> v0.4.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
