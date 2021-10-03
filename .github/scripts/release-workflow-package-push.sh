#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

# This script is an integral part of the release workflow: .github/workflows/release.yml
# It requires the following environment variables to function correctly:
#
# REQUESTED_BUILDPACK_ID - The ID of the buildpack to package and push to the container registry.
# for example `heroku/nodejs-function` or `heroku/nodejs-engine`.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# shellcheck source=SCRIPTDIR/../scripts/utils.sh
source "${SCRIPT_DIR}/utils.sh"

buildpack_id=$(echo "${REQUESTED_BUILDPACK_ID:?Must be set to a valid buildpack ID!}" | tr -d '[:space:]' )
buildpack_toml_path="$(find_buildpack_toml_path "${buildpack_id}")"
buildpack_version="$(yj -t <"${buildpack_toml_path}" | jq -r .buildpack.version)"
buildpack_docker_repository="$(yj -t <"${buildpack_toml_path}" | jq -r .metadata.release.docker.repository)"
buildpack_path=$(dirname "${buildpack_toml_path}")
buildpack_build_path="${buildpack_path}"

echo "Found buildpack ${buildpack_id} at ${buildpack_path}"

# Some buildpacks require a build step before packaging. If we detect a build.sh script, we execute it and
# modify the buildpack_build_path variable to point to the directory with the built buildpack instead.
if [[ -f "${buildpack_path}/build.sh" ]]; then
	echo "Buildpack has build script, executing..."
	"${buildpack_path}/build.sh"
	echo "Build finished!"

	buildpack_build_path="${buildpack_path}/target"
fi

image_name="${buildpack_docker_repository}:${buildpack_version}"

echo "Publishing ${buildpack_id} v${buildpack_version} to ${image_name}"
pack buildpack package --config "${buildpack_build_path}/package.toml" --publish "${image_name}"

# We might have local changes after building and/or shimming the buildpack. To ensure scripts down the pipeline
# work with a clean state, we reset all local changes here.
git reset --hard
git clean -fdx

echo "::set-output name=id::${buildpack_id}"
echo "::set-output name=version::${buildpack_version}"
echo "::set-output name=path::${buildpack_path}"
echo "::set-output name=address::${buildpack_docker_repository}@$(crane digest "${image_name}")"
