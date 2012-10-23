require 'delegate'
class Exhibit < SimpleDelegator
  def initialize(model, context)
    @context = context
    super(model)
  end

  def to_model
    __getobj__
  end

  def class
    __getobj__.class
  end

  def self.exhibits
    [TextPostExhibit, PicturePostExhibit]
  end

  def self.exhibit(object, context)
    exhibits.inject(object) do |object, exhibit|
      exhibit.exhibit_if_applicable(object, context)
    end
  end

  # Wrap the object in any exhibit objects which should apply
  def self.exhibit_if_applicable(object, context)
    if applicable_to?(object)
      new(object, context)
    else
      object
    end
  end

  def applicable_to?(obj)
    false
  end
end
