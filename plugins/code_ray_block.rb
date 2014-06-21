require './plugins/pygments_code'
require './plugins/raw'

module Jekyll

    class CodeRayBlock < Liquid::Block
          include HighlightCode
              include TemplateWrapper
                  CaptionUrlTitle = /(\S[\S\s]*)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
                      Caption = /(\S[\S\s]*)/
                          def initialize(tag_name, markup, tokens)
                                  @title = nil
                                        @caption = nil
                                              @filetype = nil
                                                    @highlight = true
                                                          if markup =~ /\s*lang:(\S+)/i
                                                                    @filetype = $1
                                                                            markup = markup.sub(/\s*lang:(\S+)/i,'')
                                                                                  end
                                                                if markup =~ CaptionUrlTitle
                                                                          @file = $1
                                                                                  @caption = "<figcaption class='code-header' style='margin-bottom:-5px;'><span>#{$1}</span><a href='#{$2}'>#{$3 || 'link'}</a></figcaption>"
                                                                                        elsif markup =~ Caption
                                                                                                  @file = $1
                                                                                                          @caption = "<figcaption class='code-header' style='margin-bottom:-5px;'><span>#{$1}</span></figcaption>\n"
                                                                                                                end
                                                                      if @file =~ /\S[\S\s]*\w+\.(\w+)/ && @filetype.nil?
                                                                                @filetype = $1
                                                                                      end
                                                                            super
                                                                                end

                              def render(context)
                                      output = super
                                            code = super
                                                  source = "<figure class='code'>"
                                                        source += @caption if @caption
                                                              coderay_css = context.registers[:site].config['kramdown']['coderay']['coderay_css'].to_sym
                                                                    if @filetype
                                                                              source += " #{CodeRay.scan(code, @filetype).div(:css=>coderay_css)} </figure>"
                                                                                    else
                                                                                              source += " #{CodeRay.scan(code, :text).div(:css=>coderay_css)} </figure>"
                                                                                                    end
                                                                          source = safe_wrap(source)
                                                                                source = context['pygments_prefix'] + source if context['pygments_prefix']
                                                                                      source = source + context['pygments_suffix'] if context['pygments_suffix']
                                                                                            source
                                                                                                end
                                end
end

Liquid::Template.register_tag('coderay', Jekyll::CodeRayBlock)
