require 'spec_helper'
require 'helm_template_helper'
require 'yaml'

describe 'Annotations configuration' do
  let(:default_values) do
    {
      'certmanager-issuer' => { 'email' => 'test@example.com' },
      'global' => { 'deployment' => { 'annotations' => { 'environment' => 'development' } } }
    }
  end

  let(:ignored_charts) do
    [
      'Deployment/test-cainjector',
      'Deployment/test-cert-manager',
      'Deployment/test-gitlab-runner',
      'Deployment/test-prometheus-server',
    ]
  end

  context 'When setting global deployment annotations' do
    it 'Populates annotations for all deployments' do
      t = HelmTemplate.new(default_values)
      expect(t.exit_code).to eq(0)

      resources_by_kind = t.resources_by_kind('Deployment').reject{ |key, _| ignored_charts.include? key }

      resources_by_kind.each do |key, _|
        expect(t.dig(key, 'metadata', 'annotations')).to include(default_values['global']['deployment']['annotations'])
      end
    end
  end
end
