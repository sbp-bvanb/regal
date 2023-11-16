# METADATA
# description: Files containing tests should have a _test.rego suffix
package regal.rules.testing["file-missing-test-suffix"]

import rego.v1

import data.regal.ast
import data.regal.result

report contains violation if {
	count(ast.tests) > 0

	not endswith(input.regal.file.name, "_test.rego")

	violation := result.fail(rego.metadata.chain(), {"location": {"file": input.regal.file.name}})
}
