require 'spec_helper'

describe Pronto::TerraformFormatRunner do
  let(:terraform_format) { Pronto::TerraformFormatRunner.new(patches) }
  let(:patches) { nil }

  it 'has a version number' do
    expect(Pronto::TerraformFormat::VERSION).not_to be nil
  end

  describe '#run' do
      subject { terraform_format.run }

      context 'patches are nil' do
        it { should == [] }
      end

      context 'no patches' do
        let(:patches) { [] }
        it { should == [] }
      end

      context 'patch with need format' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        its(:count) { should == 2 }

        its(:'first.msg') do
          should ==
            'Needs to run terraform fmt'
        end
      end
  end
end
