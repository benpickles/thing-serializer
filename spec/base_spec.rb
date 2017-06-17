RSpec.describe ThingSerializer::Base do
  describe '.config' do
    let(:klass1) {
      Class.new {
        include ThingSerializer::Base
      }
    }
    let(:klass2) {
      Class.new {
        include ThingSerializer::Base
      }
    }

    it 'is per-serializer' do
      expect(klass1.config).not_to be(klass2.config)
    end
  end

  describe '#as_json' do
    let(:thing) { thing_klass.new(1, 'foo', 'pow') }
    let(:thing_klass) { Struct.new(:id, :name, :zap) }
    let(:serializer) { serializer_klass.new(thing) }

    subject { serializer.as_json }

    context 'with no attributes' do
      let(:serializer_klass) {
        Class.new {
          include ThingSerializer::Base
        }
      }

      it { should eql({}) }
    end

    context '#attribute and #attributes' do
      let(:serializer_klass) {
        Class.new {
          include ThingSerializer::Base
          attribute :zap
          attributes :id, :name
        }
      }

      it do
        should eql({
          id: 1,
          name: 'foo',
          zap: 'pow',
        })
      end
    end

    context 'referencing a local method' do
      let(:serializer_klass) {
        Class.new {
          include ThingSerializer::Base
          attributes :foo

          def foo
            'bar'
          end
        }
      }

      it do
        should eql({
          foo: 'bar',
        })
      end
    end

    context 'accessing #object' do
      let(:serializer_klass) {
        Class.new {
          include ThingSerializer::Base
          attributes :name, :name_shouted

          def name_shouted
            object.name.upcase
          end
        }
      }

      it do
        should eql({
          name: 'foo',
          name_shouted: 'FOO',
        })
      end
    end
  end
end
