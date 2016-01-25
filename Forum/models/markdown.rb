require "redcarpet"

module Markdownhelper
  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true, 
      fenced_code_blocks: true,
      xhtml:            true,
      prettify:         true
    }

    extensions = {
      tables:             true,
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true,
      strikethrough:      true,
      underline:          true,
      highlight:          true,
      quote:              true,
      footnotes:          true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown ||= Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end