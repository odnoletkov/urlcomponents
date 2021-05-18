# urlcomponents

Convert URL to and from JSON.

# Usage

Decode:

```
$ urlcomponents "https://example.com/path/to?parameter=value"
{
  "host" : "example.com",
  "path" : "\/path\/to",
  "query" : {
    "parameter" : "value"
  },
  "scheme" : "https"
}
```

Encode:

```
$ echo '{"scheme": "https", "host": "example.com", "path": "/file"}' | urlcomponents 
https://example.com/file
```

# Install

    brew install odnoletkov/tap/urlcomponents

# TODO

* Better errors

  * Invalid path when encoding
