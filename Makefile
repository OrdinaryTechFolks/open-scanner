EXCLUDE_THIRD_PARTY=--exclude-path third_party/errors --exclude-path third_party/google --exclude-path third_party/openapi --exclude-path third_party/validate

modules-import:
	@yaml_file="buf.modules.yaml"; \
	modules=$$(yq eval '.modules[] | .repository + "@" + .path' "$$yaml_file"); \
	for module in $$modules; do \
		IFS="@"; read -r repository path <<< "$$module"; \
		buf export $$repository --output=api --path $$path; \
	done

modules-gen:
	buf generate --template buf.modules.gen.yaml ${EXCLUDE_THIRD_PARTY}