URL ?= scheme://user:pass@host.com:123/path/to?q1=p1&q2&q3=&=p4&=&=#fragment

decode:
	swift run urlcomponents "$(URL)"

encode:
	swift run urlcomponents "$(URL)" \
		| swift run urlcomponents

executable:
	Sources/urlcomponents/main.swift "$(URL)"

error-path:
	urlcomponents http://a | jq '.path = null' | urlcomponents
