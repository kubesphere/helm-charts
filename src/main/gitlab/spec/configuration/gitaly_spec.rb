require 'spec_helper'
require 'helm_template_helper'
require 'yaml'
require 'hash_deep_merge'

describe 'Gitaly configuration' do
  let(:default_values) do
    { 'certmanager-issuer' => { 'email' => 'test@example.com' } }
  end

  context 'When disabled and provided external instances' do
    let(:values) do
      {
        'global' => {
          'gitaly' => {
            'enabled' => false,
            'external' => [
              {
                'name' => 'default',
                'hostname' => 'git.example.com',
              }
            ],
          },
        }
      }.deep_merge(default_values)
    end

    it 'populates external instances to gitlab.yml' do
      t = HelmTemplate.new(values)
      expect(t.exit_code).to eq(0)
      # check that gitlab.yml.erb contains production.repositories.storages
      gitlab_yml = t.dig('ConfigMap/test-webservice','data','gitlab.yml.erb')
      storages = YAML.load(gitlab_yml)['production']['repositories']['storages']
      expect(storages).to have_key('default')
      expect(storages['default']['gitaly_address']).to eq('tcp://git.example.com:8075')
    end

    context 'when external is configured with tlsEnabled' do
      let(:values) do
        {
          'global' => {
            'gitaly' => {
              'enabled' => false,
              'external' => [
                {
                  'name' => 'default',
                  'hostname' => 'git.example.com',
                  'tlsEnabled' => true
                }
              ],
            },
          }
        }.deep_merge(default_values)
      end

      it 'populates a tls uri' do
        t = HelmTemplate.new(values)
        expect(t.exit_code).to eq(0)
        # check that gitlab.yml.erb contains production.repositories.storages
        gitlab_yml = t.dig('ConfigMap/test-webservice','data','gitlab.yml.erb')
        storages = YAML.load(gitlab_yml)['production']['repositories']['storages']
        expect(storages).to have_key('default')
        expect(storages['default']['gitaly_address']).to eq('tls://git.example.com:8076')
      end
    end

    context 'when tls is enabled' do
      let(:values) do
        {
          'global' => {
            'gitaly' => {
              'enabled' => false,
              'external' => [
                {
                  'name' => 'default',
                  'hostname' => 'git.example.com',
                },
              ],
              'tls' => { 'enabled' => true }
            },
          }
        }.deep_merge(default_values)
      end

      it 'populates a tls uri' do
        t = HelmTemplate.new(values)
        expect(t.exit_code).to eq(0)
        # check that gitlab.yml.erb contains production.repositories.storages
        gitlab_yml = t.dig('ConfigMap/test-webservice','data','gitlab.yml.erb')
        storages = YAML.load(gitlab_yml)['production']['repositories']['storages']
        expect(storages).to have_key('default')
        expect(storages['default']['gitaly_address']).to eq('tls://git.example.com:8076')
      end
    end

    context 'when tls is enabled, and instance disables tls' do
      let(:values) do
        {
          'global' => {
            'gitaly' => {
              'enabled' => false,
              'external' => [
                {
                  'name' => 'default',
                  'hostname' => 'git.example.com',
                  'tlsEnabled' => false
                },
              ],
              'tls' => { 'enabled' => true }
            },
          }
        }.deep_merge(default_values)
      end

      it 'populates a tcp uri' do
        t = HelmTemplate.new(values)
        expect(t.exit_code).to eq(0)
        # check that gitlab.yml.erb contains production.repositories.storages
        gitlab_yml = t.dig('ConfigMap/test-webservice','data','gitlab.yml.erb')
        storages = YAML.load(gitlab_yml)['production']['repositories']['storages']
        expect(storages).to have_key('default')
        expect(storages['default']['gitaly_address']).to eq('tcp://git.example.com:8075')
      end
    end
  end
end
