# encoding: UTF-8
module Puppet::Parser::Functions
  newfunction(:multi_epp, :type => :rvalue) do |args|
    begin
      templates = args[0]
      params = args[1]

      template_path = nil
      contents    = nil
      env_name = self.compiler.environment
      
      templates.each do |template_file|
        if template_path = Puppet::Parser::Files.find_template(template_file, env_name)
          if Integer(lookupvar('puppetversion')[0,1]) > 3
            contents = call_function('epp', [template_path, params])
          else
            contents = call_function('epp', template_path, params)
          end
  
          break
        end
      end
  
      if contents.nil?
        files = templates.join(', ')
        raise ArgumentError, "#{self.class.name}(): No match found for #{files}"
      end
      
      contents
    end
  end

end
