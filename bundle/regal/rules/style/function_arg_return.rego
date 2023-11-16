# METADATA
# description: Function argument used for return value
package regal.rules.style["function-arg-return"]

import rego.v1

import data.regal.ast
import data.regal.config
import data.regal.result

report contains violation if {
	cfg := config.for_rule("style", "function-arg-return")
	except_functions := array.concat(object.get(cfg, "except-functions", []), ["print"])

	some value in ast.all_refs

	value[0].value[0].type == "var"

	fn_name := ast.ref_to_string(value[0].value)

	not contains(fn_name, "$")
	not fn_name in except_functions
	fn_name in ast.all_function_names

	ast.function_ret_in_args(fn_name, value)

	violation := result.fail(rego.metadata.chain(), result.location(regal.last(value)))
}
