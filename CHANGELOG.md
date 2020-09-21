# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [1.3.0](https://www.github.com/terraform-google-modules/terraform-google-event-function/compare/v1.2.0...v1.3.0) (2020-09-18)

### ⚠ BREAKING CHANGES

* Minimum Google provider version increased to [3.38.0](https://github.com/hashicorp/terraform-provider-google/blob/master/CHANGELOG.md#3380-september-08-2020)


### Features

* Add option to use an existing archive bucket ([#42](https://www.github.com/terraform-google-modules/terraform-google-event-function/issues/42)) ([7ec5539](https://www.github.com/terraform-google-modules/terraform-google-event-function/commit/7ec5539f1d22059129234e7509f7d7549a0f02dd))
* Add support for Ingress Settings (var.ingress_settings) on the function ([#43](https://www.github.com/terraform-google-modules/terraform-google-event-function/issues/43)) ([1f1c8c5](https://www.github.com/terraform-google-modules/terraform-google-event-function/commit/1f1c8c52dcdb3ff228f5580fc725114868b17aaa))


### Bug Fixes

* remove bucket_policy_only, add uniform_bucket_level_access ([#48](https://www.github.com/terraform-google-modules/terraform-google-event-function/issues/48)) ([76efb3a](https://www.github.com/terraform-google-modules/terraform-google-event-function/commit/76efb3a2d1a9fa1379bb6ce7dc16a888ea70cd06))
* Use uniform-level access policy in GCS bucket ([9fa60be](https://www.github.com/terraform-google-modules/terraform-google-event-function/commit/9fa60be12c580ca62315b8082bae3698216681c4))

## [Unreleased]

### Added

- Adding the include_children option. [#39](https://github.com/terraform-google-modules/terraform-google-event-function/pull/39)

## [1.2.0] - 2019-12-17

### Added

- The `source_dependent_files` variable. If used `archive` won't be created until Terraform created `local_file`s are finished. [#38]

### Fixed

- Updating the source for a local event-function doesn't update the function. [#32]

## [1.1.0] - 2019-09-02

### Added

- Added support for folder-level exports with [new module](./modules/event-folder-log-entry). [#28]

## [1.0.0] - 2019-07-29

### Changed

- Supported version of Terraform is 0.12. [#23]
- Support aggregated log exports by integrating log-export module. [#18]

## [0.1.0] - 2019-04-03

### Added

- Initial release

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-event-function/compare/v1.2.0...HEAD
[0.1.0]: https://github.com/terraform-google-modules/terraform-google-event-function/releases/tag/v0.1.0
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-event-function/compare/v0.1.0...v1.0.0
[1.1.0]: https://github.com/terraform-google-modules/terraform-google-event-function/compare/v1.0.0...v1.1.0
[1.2.0]: https://github.com/terraform-google-modules/terraform-google-event-function/compare/v1.1.0...v1.2.0


[#38]: https://github.com/terraform-google-modules/terraform-google-event-function/issues/38
[#32]: https://github.com/terraform-google-modules/terraform-google-event-function/issues/32
[#28]: https://github.com/terraform-google-modules/terraform-google-event-function/pull/28
[#23]: https://github.com/terraform-google-modules/terraform-google-event-function/pull/23
[#18]: https://github.com/terraform-google-modules/terraform-google-event-function/pull/18
