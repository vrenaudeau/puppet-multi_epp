#Puppet::Functions.create_function(:multi_epp, Puppet::Functions::InternalFunction) do
module Puppet::Parser::Functions
newfunction(:multi_epp, :type => :rvalue) do | args |
  
  templates = args[0]
  datas = args[1]
  env_name = self.compiler.environment
  
  templates.each do |template_file|
    if template_path = Puppet::Parser::Files.find_template(template_file, env_name)
      contents = call_function('epp', template_path, params)

      break # exit the loop as soon as we match a file
    end
  end

  if contents.nil?
    files = templates.join(', ')
    raise ArgumentError, "#{self.class.name}(): No match found for #{files}"
  end

  contents
end
