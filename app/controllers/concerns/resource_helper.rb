module ResourceHelper
  ACCEPTABLE_OBJECT_TYPES = {
    Person:            'people',
    House:             'houses',
    ConstituencyGroup: 'constituencies',
    Party:             'parties',
    ParliamentPeriod:  'parliaments'
  }.freeze

  def self.get_object_type(node_type)
    node_type.split('/').last.to_sym
  end

  def self.check_acceptable_object_type(types)
    ACCEPTABLE_OBJECT_TYPES.each do |key, value|
      return value if types.include?(key)
    end
    nil
  end

  def self.store_types(results)
    @types = []
    results.each do |result|
      result.statements.each do |statement|
        if statement.predicate.to_s.include?('#type')
          @types << get_object_type(statement.object.to_s)
        end
      end
    end
    @types
  end

  def self.produce_statements(results)
    statements = []
    results.each do |result|
      result.statements.each do |statement|
        statements << statement.to_a
      end
    end
    statements
  end
end
