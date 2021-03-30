require 'yaml'

module DataMapper
  class Base
    extend Dry::Initializer

    option :schema_path
    option :input_hash

    attr_reader :mapped_response

    def call
      @mapped_response = map_response!
    end

    private

    def map_response!
      schema_obj = YAML.load_file(schema_path)

      build_response(schema_obj, input_hash)
    end

    def build_response(schema, part_input_hash)
      object = case schema
               when Hash   then handle_hash(schema, part_input_hash)
               when Array  then handle_array(schema[0], part_input_hash, schema[1])
               when String then extract_result(schema, part_input_hash)
               end
      object
    end

    def handle_hash(_schema, part_input_hash)
      _schema.inject({}) do |memo, (key, value)|
        memo[key] = build_response(value, part_input_hash)
        memo
      end
    end

    def handle_array(_schema, part_input_hash, properties)
      result_array = extract_result(properties['path'], part_input_hash)
      
      return result_array if properties['only_base_types'] == true

      result_array.map do |value|
       build_response(_schema, value)
      end
    end

    def extract_result(path, hash)
      array_path = path.split('.')
      hash.dig(*array_path)
    end
  end
end