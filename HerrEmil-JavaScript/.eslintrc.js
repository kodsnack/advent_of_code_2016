module.exports = {
    "extends": "google",
    "env": {
    	"es6": true
    },
    "rules": {
		"require-jsdoc": ["error", {
		"require": {
			"FunctionDeclaration": false,
			"MethodDefinition": false,
			"ClassDeclaration": false,
			"ArrowFunctionExpression": false
			}
		}]
	}
};
