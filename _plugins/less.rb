module Jekyll

  class NoFile < StaticFile
    def write
    end
  end

  class CategoryGenerator < Generator
    priority :low
    safe true
    
    def generate(site)

      
      `lessc _less/bootstrap.less _site/site.css` 
      site.static_files << NoFile.new(site, site.source, '', 'site.css')
    end
  
  end

end

