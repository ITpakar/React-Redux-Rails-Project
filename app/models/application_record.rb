class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def traverse_up_to klass
    byebug
    return self if self.class == klass
    return self.send(self.association_map[klass.to_s]) if self.association_map.keys.include? klass.to_s

    case self.class
    when Comment
      return self.commentable.traverse_up_to klass
    when Document
      return self.parent.traverse_up_to klass
    when Folder
      return self.parent.traverse_up_to klass
    when Task
      return self.section.traverse_up_to klass
    end
  end

  def belongs_to? klass
    sym = klass.to_s.downcase.to_sym
    self.class.reflect_on_all_associations(:belongs_to).map(&:name).include? sym
  end

  # This will create a hash of all associations with key = klass and value = association name
  def association_map
    Hash[*self.class.reflect_on_all_associations(:belongs_to).map{|assoc| [assoc.class_name, assoc.name]}.flatten]
  end
end