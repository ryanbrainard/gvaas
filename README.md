# GVaaS: Graphviz as a Service

Running [Graphviz](http://www.graphviz.org/) in the cloud so you don't have to.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Usage

`POST` the contents of a Graphviz document to `/dot` with the
`Content-Type` set to `text/vnd.graphviz` and the `Accept` header set to the the desired output media type.
Alternatively, `GET /dot` with the document in the `gz` param and output media type in `accept` param
for clients that do not support `POST`.
[`GET /`](http://gvaas.herokuapp.com/) to see supported media types. Potential errors include:

 - [`406`](http://httpstatus.es/406): media type in `Accept` header is not supported.
 - [`415`](http://httpstatus.es/415): media type in `Content-Type` header is not supported.
 - [`422`](http://httpstatus.es/422): request could not be processed. Error details returned in a JSON object.

Note, if using `curl` to upload files, be sure to use the `--data-binary` option to preserve new line characters.

## Example

### Converting a DOT to SVG:

    $ curl http://gvaas.herokuapp.com/dot -H 'Content-Type: text/vnd.graphviz' -H 'Accept: image/svg+xml' --data-binary @hello.dot

#### Request

```
POST /dot HTTP/1.1
Host: gvaas.herokuapp.com
Content-Type: text/vnd.graphviz
Accept: image/svg+xml
Content-Length: 29

digraph g { hello -> world; }
```

#### Response

```
HTTP/1.1 200 OK
Content-Type: image/svg+xml;charset=utf-8
Date: Fri, 31 Jan 2014 23:23:04 GMT
Server: WEBrick/1.3.1 (Ruby/2.0.0/2013-11-22)
Content-Length: 1364
Connection: keep-alive

<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
 "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<!-- Generated by graphviz version 2.30.1 (20140131.2124)
 -->
<!-- Title: g Pages: 1 -->
<svg width="74pt" height="116pt"
 viewBox="0.00 0.00 74.00 116.00" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<g id="graph0" class="graph" transform="scale(1 1) rotate(0) translate(4 112)">
<title>g</title>
<polygon fill="white" stroke="white" points="-4,5 -4,-112 71,-112 71,5 -4,5"/>
<!-- hello -->
<g id="node1" class="node"><title>hello</title>
<ellipse fill="none" stroke="black" cx="33" cy="-90" rx="30.0229" ry="18"/>
<text text-anchor="middle" x="33" y="-85.8" font-family="Times,serif" font-size="14.00">hello</text>
</g>
<!-- world -->
<g id="node2" class="node"><title>world</title>
<ellipse fill="none" stroke="black" cx="33" cy="-18" rx="33.3445" ry="18"/>
<text text-anchor="middle" x="33" y="-13.8" font-family="Times,serif" font-size="14.00">world</text>
</g>
<!-- hello&#45;&gt;world -->
<g id="edge1" class="edge"><title>hello&#45;&gt;world</title>
<path fill="none" stroke="black" d="M33,-71.6966C33,-63.9827 33,-54.7125 33,-46.1124"/>
<polygon fill="black" stroke="black" points="36.5001,-46.1043 33,-36.1043 29.5001,-46.1044 36.5001,-46.1043"/>
</g>
</g>
</svg>
```

## Development

```
$ git clone https://github.com/ryanbrainard/gvaas.git
$ cd gvaas
$ bundle install
$ foreman start
```

## Deployment

```
$ heroku create gvaas -b https://github.com/ddollar/heroku-buildpack-multi.git
$ git push heroku master
```

...or just:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
