package regal.rules.testing["dubious-print-sprintf_test"]

import rego.v1

import data.regal.ast
import data.regal.capabilities
import data.regal.config

import data.regal.rules.testing["dubious-print-sprintf"] as rule

test_fail_print_sprintf if {
	module := ast.policy(`y {
		print(sprintf("name is: %s domain is: %s", [input.name, input.domain]))
	}`)

	r := rule.report with input as module
		with data.internal.combined_config as {"capabilities": capabilities.provided}
	r == {{
		"category": "testing",
		"description": "Dubious use of print and sprintf",
		"level": "error",
		"location": {
			"col": 9, "file": "policy.rego", "row": 4,
			"text": "\t\tprint(sprintf(\"name is: %s domain is: %s\", [input.name, input.domain]))",
		},
		"related_resources": [{
			"description": "documentation",
			"ref": config.docs.resolve_url("$baseUrl/$category/dubious-print-sprintf", "testing"),
		}],
		"title": "dubious-print-sprintf",
	}}
}

test_fail_bodies_print_sprintf if {
	module := ast.policy(`y {
		comprehension := [x |
			x := input[_]
			print(sprintf("x is: %s", [x]))
		]
	}`)

	r := rule.report with input as module
		with data.internal.combined_config as {"capabilities": capabilities.provided}
	r == {{
		"category": "testing",
		"description": "Dubious use of print and sprintf",
		"level": "error",
		"location": {"col": 10, "file": "policy.rego", "row": 6, "text": "\t\t\tprint(sprintf(\"x is: %s\", [x]))"},
		"related_resources": [{
			"description": "documentation",
			"ref": config.docs.resolve_url("$baseUrl/$category/dubious-print-sprintf", "testing"),
		}],
		"title": "dubious-print-sprintf",
	}}
}
