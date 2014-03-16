require 'sinatra'
require 'open3'
require 'json'

def gv_type
  'text/vnd.graphviz'
end

def supported_transforms
  {
    '*/*'                    => '',
    gv_type                  => '-Tdot',
    #'image/png'             => '-Tpng',  // TODO: heroku-buildpack-graphviz doesn't support these image types
    #'image/jpg'             => '-Tpng',  // TODO: heroku-buildpack-graphviz doesn't support these image types
    #'image/gif'             => '-Tgif',  // TODO: heroku-buildpack-graphviz doesn't support these image types
    #'application/pdf'       => '-Tpdf',  // TODO: heroku-buildpack-graphviz doesn't support these image types
    'image/svg+xml'          => '-Tsvg',
    'application/xml'        => '-Tsvg',
    'application/postscript' => '-Teps'
 }
end

def dot(input, output_type=nil)
  accept = output_type ? output_type : [gv_type]
  transform = supported_transforms.detect{|t,_| accept.include?(t)}
  error(406) unless transform
  cmd = "dot #{transform[1]}"

  out, err, status = Open3.capture3(cmd, stdin_data: input)
  STDERR.puts "#{status} #{err}"

  unless status.exitstatus.zero? && err.to_s.empty?
    content_type :json
    msg = JSON.pretty_generate ({
      command: cmd,
      exitstatus: status.exitstatus,
      out: out,
      err: err
    })
    error(422, msg)
  end

  content_type transform[0]
  out
end

get '/' do
  content_type :json
  JSON.pretty_generate ({
    name: 'GVaaS: Graphviz as a Service',
    repository: 'https://github.com/ryanbrainard/gvaas',
    resources: [
      {
        url: '/',
        method: 'GET',
        accept: ['application/json'],
        errors: []
      },
      {
        url: '/dot',
        method: 'GET',
        params: ['gv', 'accept'],
        accept: supported_transforms.keys,
        errors: [406,415,422]
      },
      {
        url: '/dot',
        method: 'POST',
        content_type: [gv_type],
        accept: supported_transforms.keys,
        errors: [406,415,422]
      }
    ]
  })
end

get '/dot' do
  dot(request.params['gv'], request.params['accept'] || request.accept)
end

post '/dot' do
  error(415) unless (request.media_type.nil? || request.media_type == gv_type)
  dot(request.body.string, request.accept)
end
