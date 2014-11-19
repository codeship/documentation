require 'open-uri'

module Jekyll
  class RubyVersions < Liquid::Tag
    def render(context)
      ['jruby', 'manual', 'mri'].map do |type|
        URI.parse("http://codeship.io.s3.amazonaws.com/checkbot/wharf/rubies/#{type}/versions").read.split("\n").map do |version|
          "* #{version}"
        end.join("\n")
      end.join("\n")
    end
  end
end

Liquid::Template.register_tag('ruby_versions', Jekyll::RubyVersions)
