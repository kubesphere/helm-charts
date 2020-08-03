require 'yaml'
require 'open3'

class HelmTemplate
  def helm_version
    `helm version -c`.match('Ver(sion)?:"v(\d)\.')[2]
  end

  def helm_template_call
    case helm_version
    when "2" then
      'helm template -n test -f - .'
    when "3" then
      'helm template test . -f -'
    else
      # If we don't know the version of Helm, use `false` command
      "false"
    end
  end

  def initialize(values)
    template(values)
  end

  def template(values)
    @values  = values
    result = Open3.capture3(helm_template_call,
                            chdir: File.join(__dir__,  '..'),
                            stdin_data: YAML.dump(values))
    @stdout, @stderr, @exit_code = result
    # load the complete output's YAML documents into an array
    yaml = YAML.load_stream(@stdout)
    # filter out any empty YAML documents (nil)
    yaml.select!{ |x| !x.nil? }
    # create an indexed Hash keyed on Kind/metdata.name
    @mapped = yaml.to_h  { |doc|
      [ "#{doc['kind']}/#{doc['metadata']['name']}" , doc ]
    }
  end

  def dig(*args)
    @mapped.dig(*args)
  end

  def volumes(item)
    @mapped.dig(item,'spec','template','spec','volumes')
  end

  def find_volume(item, volume_name)
    volumes = volumes(item)
    volumes.keep_if { |volume| volume['name'] == volume_name }
    volumes[0]
  end

  def env(item, container_name, init: false)
    containers = init ? 'initContainers' : 'containers'

    dig(item, 'spec', 'template', 'spec', containers)
      &.find { |container| container['name'] == container_name }
      &.dig('env')
  end

  def projected_volume_sources(item,volume_name)
    volume = find_volume(item,volume_name)
    volume['projected']['sources']
  end

  def resources_by_kind(kind)
    @mapped.select{ |key, hash| hash['kind'] == kind }
  end

  def exit_code()
    @exit_code.to_i
  end

  def stderr()
    @stderr
  end

  def values()
    @values
  end
end
