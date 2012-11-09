require 'delegate'
class Exhibit < SimpleDelegator
  def to_model
    __getobj__
  end

  def class
    __getobj__.class
  end

  def initialize(model, context)
    @context = context
    super(model)
  end

  # Register all the known exhibit subclasses here - in the order you
  # want them applied to your model objects. Classes defined later 
  # override those defined earlier in the list.
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

  # the default, set in this superclass, is always "doesn't apply to me"
  # So each subclass must define which model objects it is a delegate for.
  def applicable_to?(obj)
    false
  end
end
