module Droppable::Art
  class Dist
    property dist : Array(Float64)
    property traits : Array(Trait)

    def initialize
        @dist = Array(Float64).new
        @traits = Array(Trait).new
    end

    def dist : Int32
      v = Random.rand
      border = 0
      @dist.each_with_index do |x, i|
        if border <= v && border + x > v
          return i
        end
        border += x
      end
      return 0
    end

    def select 
      return traits[dist]
    end

    def add(my_dist : Float64, trait : Trait)
      @dist.push(my_dist)
      @traits.push(trait)
    end
  end
end
