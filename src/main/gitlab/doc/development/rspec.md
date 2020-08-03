# Writing RSpec tests for charts

The following are notes and conventions used for creating RSpec tests for the
GitLab chart.

## Filtering RSpec tests

To aid in development it is possible to filter which tests are executed by
adding the `:focus` tag to one or more tests. With the `:focus` tag _only_
tests that have been specifically tagged will be run. This allows quick
development and testing of new code without having to wait for all the RSpec
tests to execute. The following is an example of a test that has been tagged
with`:focus`.

```ruby
describe 'some feature' do
  it 'generates output', :focus => true do
    ...
  end
end
```

The `:focus` tag can be added to `describe`, `context` or `it` blocks which
allows a test or a group of tests to be executed.

## Generating YAML from the chart

Much of the testing of the chart is that it generates the correct YAML
structure given a number of [chart inputs](#chart-inputs). This is done using
the HelmTemplate class as in the following:

```ruby
obj = HelmTemplate.new(values)
```

The resulting `obj` encodes the YAML documents returned by the `helm template`
command indexed by the [Kubernetes object `kind`](https://kubernetes.io/docs/concepts/#kubernetes-objects) and the object name (`metadata.name`). This indexed
valued is used by most of the methods to locate values within the YAML.

For example:

```ruby
obj.dig('ConfigMap/test-gitaly', 'data', 'config.toml.erb')
```

This will return the contents of the `config.toml.erb` file contained in the
`test-gitaly` ConfigMap.

NOTE: **Note**:
Using the `HelmTemplate` class will always use the release name of "test"
when executing the `helm template` command.

## Chart inputs

The input parameter to the `HelmTemplate` class constructor is a dictionary
of values that represents the `values.yaml` that is used on the Helm command
line. This dictionary mirrors the YAML structure of the `values.yaml` file.

```ruby
describe 'some feature' do
  let(:default_values) do
    { 'certmanager-issuer' => { 'email' => 'test@example.com' } }
  end

  describe 'global.feature.enabled' do
    let(:values) do
      {
        'global' => {
          'feature' => {
            'enabled' => true
          }
        }
      }.merge(default_values)
    end

    ...
  end
end
```

The above snippet demonstrates a common pattern of setting a number of default
values that are common across multiple tests that are then merged into the
final values that are used in the `HelmTemplate` constructor for a specific
set of tests.

## Testing the results

The `HelmTemplate` object has a number of methods that assist with writing
RSpec tests. The following are a summary of the available methods.

- `.exit_code()`

This returns the exit code of the `helm template` command used to create the
YAML documents that instantiates the chart in the Kubernetes cluster. A
successful completion of the `helm template` will return an exit code of 0.

- `.dig(key, ...)`

Walk down the YAML document returned by the `HelmTemplate` instance and
return the value residing at the last key. If no value is found, then `nil`
is returned.

- `.volumes(item)`

Return an array of all the volumes for the specified deployment object. The
returned array is a direct copy of the `volumes` key from the deployment
object.

- `.find_volume(item, volume_name)`

Return a dictionary of the specified volume from the specified deployment
object.

- `.projected_volume_sources(item, mount_name)`

Return an array of sources for the specified projected volume. The returned
array has the following structure:

```yaml
- secret:
    name: test-rails-secret
    items:
     - key: secrets.yml
       path: rails-secrets/secrets.yml
```

- `.stderr()`

Return the STDERR output from the execution of `helm template` command.

- `.values()`

Return a dictionary of all values that were used in the execution of the
`helm template` command.
