#!/usr/bin/env bash

set -e
set -o pipefail

shpec_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=SCRIPTDIR/../utils.sh
source "${shpec_dir}/../utils.sh"

describe "utils.sh"
	describe "escape_for_sed"
		it "escapes special sed characters"
			result=$(escape_for_sed "## [Unreleased]")
			assert equal "$result" "## \[Unreleased\]"
		end
	end

	describe "find_buildpack_toml_path"
		it "finds a buildpack based on ID if it exists"
			# I had to change **/buildpack.toml to **/*/buildpack.toml in the script
			# and I don't know why.
			result=$(find_buildpack_toml_path "heroku/nodejs-engine")
			assert equal $result "buildpacks/nodejs-engine/buildpack.toml"
		end

		it "errors if the buildpack does not exist"
			set +e
				result=$(find_buildpack_toml_path "heroku/nope")
				loc_var=$?
			set -e

			assert equal $loc_var 1
		end
	end

	describe "package_toml_contains_image_address_root"
		it "knows if a package toml contains a given uri as a dependency"
			set +e
				image_address_root="docker://public.ecr.aws/heroku-buildpacks/heroku-nodejs-engine-buildpack"
				package_toml_contains_image_address_root "meta-buildpacks/nodejs/package.toml" "$image_address_root"
				loc_var=$?
			set -e

			assert equal $loc_var 0

			set +e
				image_address_root="docker://nope"
				package_toml_contains_image_address_root "meta-buildpacks/nodejs/package.toml" "$image_address_root"
				loc_var=$?
			set -e

			assert equal $loc_var 1
		end
	end

	describe "is_meta_buildpack_with_dependency"
		it "knows if a given dependency is in a buildpack toml"
			set +e
				is_meta_buildpack_with_dependency "meta-buildpacks/nodejs/buildpack.toml" "heroku/nodejs-engine"
				loc_var=$?
			set -e

			assert equal $loc_var 0

			set +e
				is_meta_buildpack_with_dependency "meta-buildpacks/nodejs/buildpack.toml" "heroku/nope-nope-nope"
				loc_var=$?
			set -e

			assert equal $loc_var 1
		end
	end
end

