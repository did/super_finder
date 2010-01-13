module SuperFinder
  
  module Helper
    
    def super_finder_tag
      %{
        <div id="superfinder" style="display: none">
    			<p>#{text_field_tag 'q'}</p>
    			<ul></ul>
    		</div>

    		<script src="#{super_finder_resources_url}" type="text/javascript"></script>
      }
    end
    
  end
  
end