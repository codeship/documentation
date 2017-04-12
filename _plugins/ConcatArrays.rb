module Jekyll
  module ConcatFilter
    def concat(one, two)
      one.concat(two)
    end
  end
end
Liquid::Template.register_filter(Jekyll::ConcatFilter)
