require 'yaml'

class Dictionary
  include DataMapper::Resource

  property :id, Serial
  property :word, String, :index => true
  property :explanation, Text

  def add_explanation(exp)
    @exp_list ||= []
    @exp_list << exp
  end

  def before_save
    @exp_list ||= []
    self.explanation = @exp_list.to_yaml
  end

  def explanation_list
    @exp_list ||= YAML.load(self.explanation)
    @exp_list ||= []
    @exp_list
  end
  
  def size
    explanation_list.size
  end

end