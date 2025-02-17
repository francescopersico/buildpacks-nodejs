# Changelog
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.7.5] 2022/01/28
- Ensure NODE_ENV is set consistently during build, no matter the cache state ([186](https://github.com/heroku/buildpacks-nodejs/pull/186)

## [0.7.4] 2021/06/15
- Change node engine version from 12 to 14 ([#40](https://github.com/heroku/buildpacks-node/pull/40))
- Clear cache when node version changes ([#40](https://github.com/heroku/buildpacks-node/pull/40))
- Check for nodejs.toml before read ([#53](https://github.com/heroku/buildpacks-nodejs/pull/53))
- Change default Node.js version to 16 ([#53](https://github.com/heroku/buildpacks-nodejs/pull/53))
- Fix bug that causes an error on Node version change ([#77](https://github.com/heroku/buildpacks-nodejs/pull/77))

## [0.7.3] 2021/03/04
- Flush cache when stack image changes ([#28](https://github.com/heroku/buildpacks-node/pull/28))
- Trim whitespace when getting stack name ([#29](https://github.com/heroku/buildpacks-node/pull/29))

## [0.7.2] 2021/02/23
- Add license to buildpack.toml ([#17](https://github.com/heroku/buildpacks-node/pull/17))
- Copy node modules directory path into the build ENV ([#15](https://github.com/heroku/buildpacks-node/pull/15))
- Remove package.json requirement ([#14](https://github.com/heroku/buildpacks-node/pull/14))

## [0.7.1] 2021/01/20
- Replace logging style to match style guides ([#63](https://github.com/heroku/nodejs-engine-buildpack/pull/63))
- Change log colors to use ANSI codes ([#65](https://github.com/heroku/nodejs-engine-buildpack/pull/65))

## [0.7.0] 2020/11/11
### Added
- Add support for heroku-20 ([#60](https://github.com/heroku/nodejs-engine-buildpack/pull/60))

### Fixed
- Remove jq installation ([#57](https://github.com/heroku/nodejs-engine-buildpack/pull/57))
- Make `NODE_ENV` variables overrides ([#61](https://github.com/heroku/nodejs-engine-buildpack/pull/61))

## [0.6.0] 2020/10/13
### Added
- Add profile.d script ([#53](https://github.com/heroku/nodejs-engine-buildpack/pull/53))
- Set NODE_ENV to production at runtime ([#54](https://github.com/heroku/nodejs-engine-buildpack/pull/54))
- Set NODE_ENV in build environment ([#55](https://github.com/heroku/nodejs-engine-buildpack/pull/55))

## [0.5.0] 2020/07/16
### Added
- Increase `MaxKeys` for listing S3 objects in `resolve-version` query ([#43](https://github.com/heroku/nodejs-engine-buildpack/pull/43))
- Add Circle CI test integration ([#49](https://github.com/heroku/nodejs-engine-buildpack/pull/49))

## [0.4.4] 2020/03/25
### Added
- Add shpec to shellcheck ([#38](https://github.com/heroku/nodejs-engine-buildpack/pull/38))
- Dockerize unit tests with shpec ([#39](https://github.com/heroku/nodejs-engine-buildpack/pull/39))

### Fixed
- Upgrade Go version to 1.14 ([#40](https://github.com/heroku/nodejs-engine-buildpack/pull/40))
- Use cached bootstrap binaries when present ([#42](https://github.com/heroku/nodejs-engine-buildpack/pull/42))

## [0.4.3] 2020/02/24
### Fixed
- Remove catching of unbound variables in `lib/build.sh` ([#36](https://github.com/heroku/nodejs-engine-buildpack/pull/36))

## [0.4.2] 2020/01/30
### Added
- Write bootstrapped binaries to a layer instead of to `bin`; Add a logging method for build output ([#34](https://github.com/heroku/nodejs-engine-buildpack/pull/34))
- Added `provides` and `requires` of `node` to buildplan. ([#31](https://github.com/heroku/nodejs-engine-buildpack/pull/31))

## [0.4.1] 2019/11/08
### Fixed
- Fix updates to `nodejs.toml` when layer contents not updated ([#27](https://github.com/heroku/nodejs-engine-buildpack/pull/27))

## [0.4.0] 2019/10/31
### Added
- Add launch.toml support to engine ([#26](https://github.com/heroku/nodejs-engine-buildpack/pull/26))
- Parse engines and add them to nodejs.toml ([#25](https://github.com/heroku/nodejs-engine-buildpack/pull/25))
- Add shellcheck to test suite ([#24](https://github.com/heroku/nodejs-engine-buildpack/pull/24))
