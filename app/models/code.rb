class Code < ActiveRecord::Base
	belongs_to :mem

  def created_at
    super.strftime('%Y-%m-%d')  if super
  end
  def updated_at
    super.strftime('%Y-%m-%d')  if super
  end

  def keywords
    super.nil? ? '' : super
  end

  def snippet
    _scss = scss.gsub(/(\r\n)/) {|m|$1+"      "}
    _css = _scss!='' ? "    <style>\r\n      #{_scss}\r\n    </style>" : ''

    _sjs = sjs.gsub(/(\r\n)/) {|m|$1+"      "}
    _js = _sjs != '' ? "  <script style='text/javascript'>\r\n      #{_sjs}\r\n    </script>" : ''

    _result = shtml.gsub(/(<head>[\s\S]+?)(<\/head>)/){|h|
      $1 + "\r\n#{_css}\r\n  " + $2
    }

    _result.gsub(/([\s\S]+)(<\/html>)/){|h|
      $1 + "\r\n#{_js}\r\n" + $2
    }
  end

  def short
    _js = ''
    if sjs
      _sjs = sjs.gsub(/(\r\n)/) {|m|$1+"    "} 
      _js = "<script tyle='text/javascript'>\r\n    #{_sjs}\r\n</script>\r\n"
    end 

    _html = /<body>[\s\S]+?<\/body>/.match(shtml)
    _html = _html[0] if _html
    _html = '' if _html.nil?
    _js + _html
  end

  def self.list_field
    self.select('id,title')
  end 
end
