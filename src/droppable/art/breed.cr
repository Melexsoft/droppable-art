require "json"

module Droppable::Art
  class Breed
    include JSON::Serializable

    @[JSON::Field(key: "TOTAL")]
    property total : UInt32

    @[JSON::Field(key: "NAME")]
    property name : String

    @[JSON::Field(key: "LAYER_ORDER")]
    property order : Array(String)

    @[JSON::Field(key: "LAYERS")]
    property layers : Hash(String,Layer)

    @[JSON::Field(ignore: true)]
    property dna_list : Set(String)?

    def gen_dist(working : String)
      containers : Hash(String, Droppable::Art::Dist) = Hash(String, Droppable::Art::Dist).new
      mycon : Hash(String, Droppable::Art::Condition) = Hash(String, Droppable::Art::Condition).new
      order.each do |lay_key|
        dContainer = Droppable::Art::Dist.new
        containers[lay_key] = dContainer
        layer = layers[lay_key]
        layer.traits.each do |trait|      
          dContainer.add(trait.dist, trait)
        end

        if !layer.condition.nil?
          mycon[lay_key] = layer.condition.as(Droppable::Art::Condition)
        end
      end
      return {containers, mycon}
    end

    def select(containers : Hash(String, Droppable::Art::Dist), condition : Hash(String, Droppable::Art::Condition))
      selection = Array(Trait).new
      traits_list = Hash(String, Trait).new
      order.each do |lay_key|
        if condition.has_key? lay_key
          c = condition[lay_key].as(Droppable::Art::Condition)
          check = traits_list[c.name]
          
          next if check.name != c.value if c.requirement == "IS"
          next if check.name == c.value if c.requirement == "NOT"
        end
        t : Trait = containers[lay_key].select
        selection.push(t) if t.name != "NONE" 
        trait_name = lay_key.split('-')[0]
        traits_list[trait_name] = t
      end
      myDNA : String = dna(selection);
      
      @dna_list = Set(String).new if @dna_list.nil?
      if (@dna_list.as(Set(String))).includes?(myDNA)
        puts "DNA duplication detected"
        selection, traits_list = self.select(containers, condition);
        myDNA = dna(selection);
      end
      puts "Generate #{myDNA}"
      (@dna_list.as(Set(String))).add(myDNA);
      return {selection, traits_list}
    end

    def dna(traits : Array(Trait)) : String
      return  Digest::SHA1.hexdigest(traits.map { |x| x.name }.join(""))
    end

  end
end
