package regal.rules.style_test

import future.keywords.if

import data.regal.config
import data.regal.rules.style.common_test.report

snake_case_violation := {
	"category": "style",
	"description": "Prefer snake_case for names",
	"related_resources": [{
		"description": "documentation",
		"ref": config.docs.resolve_url("$baseUrl/$category/prefer-snake-case", "style"),
	}],
	"title": "prefer-snake-case",
	"level": "error",
}

test_fail_camel_cased_rule_name if {
	report(`camelCase := 5`) == {object.union(
		snake_case_violation,
		{"location": {"col": 1, "file": "policy.rego", "row": 8, "text": `camelCase := 5`}},
	)}
}

test_success_snake_cased_rule_name if {
	report(`snake_case := 5`) == set()
}

test_fail_camel_cased_some_declaration if {
	report(`p {some fooBar; input[fooBar]}`) == {object.union(
		snake_case_violation,
		{"location": {"col": 9, "file": "policy.rego", "row": 8, "text": `p {some fooBar; input[fooBar]}`}},
	)}
}

test_success_snake_cased_some_declaration if {
	report(`p {some foo_bar; input[foo_bar]}`) == set()
}

test_fail_camel_cased_multiple_some_declaration if {
	report(`p {some x, foo_bar, fooBar; x = 1; foo_bar = 2; input[fooBar]}`) == {object.union(
		snake_case_violation,
		{"location": {
			"col": 21, "file": "policy.rego", "row": 8,
			"text": `p {some x, foo_bar, fooBar; x = 1; foo_bar = 2; input[fooBar]}`,
		}},
	)}
}

test_success_snake_cased_multiple_some_declaration if {
	report(`p {some x, foo_bar; x = 5; input[foo_bar]}`) == set()
}

test_fail_camel_cased_var_assignment if {
	report(`allow { camelCase := 5 }`) == {object.union(
		snake_case_violation,
		{"location": {"col": 9, "file": "policy.rego", "row": 8, "text": `allow { camelCase := 5 }`}},
	)}
}

test_fail_camel_cased_multiple_var_assignment if {
	report(`allow { snake_case := "foo"; camelCase := 5 }`) == {object.union(
		snake_case_violation,
		{"location": {
			"col": 30, "file": "policy.rego", "row": 8,
			"text": `allow { snake_case := "foo"; camelCase := 5 }`,
		}},
	)}
}

test_success_snake_cased_var_assignment if {
	report(`allow { snake_case := 5 }`) == set()
}

test_fail_camel_cased_some_in_value if {
	report(`allow { some cC in input }`) == {object.union(
		snake_case_violation,
		{"location": {"col": 14, "file": "policy.rego", "row": 8, "text": `allow { some cC in input }`}},
	)}
}

test_fail_camel_cased_some_in_key_value if {
	report(`allow { some cC, sc in input }`) == {object.union(
		snake_case_violation,
		{"location": {"col": 14, "file": "policy.rego", "row": 8, "text": `allow { some cC, sc in input }`}},
	)}
}

test_fail_camel_cased_some_in_key_value_2 if {
	report(`allow { some sc, cC in input }`) == {object.union(
		snake_case_violation,
		{"location": {"col": 18, "file": "policy.rego", "row": 8, "text": `allow { some sc, cC in input }`}},
	)}
}

test_success_snake_cased_some_in if {
	report(`allow { some sc in input }`) == set()
}

test_fail_camel_cased_every_value if {
	report(`allow { every cC in input { cC == 1 } }`) == {object.union(
		snake_case_violation,
		{"location": {"col": 15, "file": "policy.rego", "row": 8, "text": `allow { every cC in input { cC == 1 } }`}},
	)}
}

test_fail_camel_cased_every_key if {
	r := report(`allow { every cC, sc in input { cC == 1; sc == 2 } }`)
	r == {object.union(
		snake_case_violation,
		{"location": {
			"col": 15, "file": "policy.rego", "row": 8,
			"text": `allow { every cC, sc in input { cC == 1; sc == 2 } }`,
		}},
	)}
}

test_success_snake_cased_every if {
	report(`allow { every sc in input { sc == 1 } }`) == set()
}