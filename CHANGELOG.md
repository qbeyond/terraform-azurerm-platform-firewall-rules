# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this module adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.1.2] - 2024-10-24

### Fixed
- allow `cdp.geotrust.com`, `cacerts.geotrust.com`, `cacerts.digicert.com` and `status.geotrust.com` for windows activation based on [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/security/fundamentals/azure-ca-details?tabs=root-and-subordinate-cas-list#public-key-encryption-and-signature-algorithms)

## [2.1.1] - 2024-05-30

### Fixed

- `ipg_entra_connect_id` is now optional as intended
- allow `crl3.digicert.com`, `crl4.digicert.com` and `ocsp.digicert.com` for Entra connect

## [2.1.0] - 2024-05-21

### Added
- Rules for entra connect

## [2.0.1] - 2024-04-29

### Fixed
- add missing RPC randomly allocated high TCP ports for AD (`49152 – 65535`) between domain controllers.

## [2.0.0] - 2024-04-09

### Added

### Changed

### Removed
- `default_location` from variables as it is not needed

### Fixed

## [1.2.0] - 2024-04-08

### Added
- platform rules for bastion

### Changed
- made rules for private dns resolver and azure dcs optional
- changed internal ordering of rules

### Removed

### Fixed


## [1.1.0] - 2023-11-17

### Added

- application rule for windows update

### Changed

### Removed

### Fixed

- windows defender can find and download updates

# [1.0.0] - 2023-07-07

Initial release of platform firewall rules
