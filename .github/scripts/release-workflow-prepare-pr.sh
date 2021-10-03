#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# shellcheck source=SCRIPTDIR/../scripts/utils.sh
source "${SCRIPT_DIR}/utils.sh"

released_buildpack_id=$(echo "${1:?}" | tr -d '[:space:]' )
released_buildpack_version="${2:?}"
released_buildpack_image_address="${3:?}"

released_buildpack_next_version=$(
	echo "${released_buildpack_version}" | awk -F. -v OFS=. '{ $NF=sprintf("%d\n", ($NF+1)); printf $0 }'
)

# This is the heading we're looking for when updating CHANGELOG.md files
unreleased_heading=$(escape_for_sed "## [Unreleased]")

while IFS="" read -r -d "" buildpack_toml_path; do
	buildpack_id="$(yj -t <"${buildpack_toml_path}" | jq -r .buildpack.id)"
	buildpack_path="$(dirname "${buildpack_toml_path}")"
	buildpack_package_toml_path="${buildpack_path}/package.toml"
	buildpack_changelog_path="${buildpack_path}/CHANGELOG.md"

	jq_filter="."

	# Update the released buildpack itself
	if [[ "${buildpack_id}" == "${released_buildpack_id}" ]]; then
		if [[ -f "${buildpack_changelog_path}" ]]; then
			new_version_heading=$(escape_for_sed "## [${released_buildpack_version}] $(date +%Y/%m/%d)")
			sed -i "s/${unreleased_heading}/${unreleased_heading}\n\n${new_version_heading}/" "${buildpack_changelog_path}"
		fi

		jq_filter=".buildpack.version = \"${released_buildpack_next_version}\""

	# Update meta-buildpacks that have the released buildpack as a dependency
	elif is_meta_buildpack_with_dependency "${buildpack_toml_path}" "${released_buildpack_id}"; then
		target_version_for_meta_buildpack="${released_buildpack_next_version}"

		released_buildpack_image_address_root="${released_buildpack_image_address%@*}"
		if package_toml_contains_image_address_root "${buildpack_package_toml_path}" "${released_buildpack_image_address_root}"; then
			target_version_for_meta_buildpack="${released_buildpack_version}"

			package_toml_filter=".dependencies[].uri |= if startswith(\"${released_buildpack_image_address_root}\") then \"${released_buildpack_image_address}\" else . end"
			updated_package_toml=$(yj -t <"${buildpack_package_toml_path}" | jq "${package_toml_filter}" | yj -jt)
			echo "${updated_package_toml}" >"${buildpack_package_toml_path}"
		fi

		if [[ -f "${buildpack_changelog_path}" ]]; then
			upgrade_entry=$(
				escape_for_sed "* Upgraded \`${released_buildpack_id}\` to \`${target_version_for_meta_buildpack}\`"
			)

			sed -i "s/${unreleased_heading}/${unreleased_heading}\n${upgrade_entry}/" "${buildpack_changelog_path}"
		fi

		jq_filter=$(
			cat <<-EOF
				.order |= map(.group |= map(
					if .id == "${released_buildpack_id}" then
						.version |= "${target_version_for_meta_buildpack}"
					else
						.
					end
				))
			EOF
		)
	fi

	# Write the filtered buildpack.toml to disk...
	updated=$(yj -t <"${buildpack_toml_path}" | jq "${jq_filter}" | yj -jt)
	echo "${updated}" >"${buildpack_toml_path}"

done < <(find . -name buildpack.toml -print0)
