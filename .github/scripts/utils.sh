#!/usr/bin/env bash

function find_buildpack_toml_path() {
	local requested_buildpack_id="${1}"
	local buildpack_id
	local matching_buildpack_toml_paths=()

	for buildpack_toml_path in **/*/buildpack.toml; do
		buildpack_id="$(yj -t <"${buildpack_toml_path}" | jq -r .buildpack.id)"
		if [[ "${buildpack_id}" == "${requested_buildpack_id}" ]]; then
			matching_buildpack_toml_paths+=("${buildpack_toml_path}")
		fi
	done

	num_paths=${#matching_buildpack_toml_paths[@]}
	if [[ num_paths -eq 0 ]]; then
		echo "Could not find requested buildpack with ID '${requested_buildpack_id}'" >&2
		exit 1
	elif [[ num_paths -gt 1 ]]; then
		echo "Found multiple buildpacks matching ID '${requested_buildpack_id}'" >&2
		echo "${matching_buildpack_toml_paths[@]}" >&2
		exit 1
	fi
	echo "${matching_buildpack_toml_paths[0]}"
}

function package_toml_contains_image_address_root() {
	local -r package_toml_path="${1:?}"
	local -r image_address_root="${2:?}"

	yj -t <"${package_toml_path}" | jq -e "[.dependencies[].uri | select(startswith(\"${image_address_root}\"))] | length > 0" >/dev/null
}

function escape_for_sed() {
	echo "${1:?}" | sed 's/[]\/\[\.]/\\&/g'
}

function is_meta_buildpack_with_dependency() {
	local -r buildpack_toml_path="${1:?}"
	local -r buildpack_id="${2:?}"

	yj -t <"${buildpack_toml_path}" | jq -e "[.order[]?.group[]?.id | select(. == \"${buildpack_id}\")] | length > 0" >/dev/null
}
