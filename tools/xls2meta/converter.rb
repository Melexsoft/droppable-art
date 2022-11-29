# frozen_string_literal: true

require 'rubyXL'
require 'jbuilder'
json = Jbuilder.new
json.NAME 'The Imps {ID} {BREED}'
json.DESCRIPTION 'DESCRIPTION'
json.URL 'https://www.theimps.com/{ID}'
json.START 0
json.BREED do
  json.array! 1.times do
    workbook = RubyXL::Parser.parse('./data.xlsx')
    worksheet = workbook[0]

    sheet_names = []

    12.times do |n|
      sheet_names << worksheet.sheet_data[n + 1][0].value
    end

    table = workbook[1]

    features = {}

    (table.sheet_data.size - 2).times do |x|
      type = table[x + 1][0].value.to_s.strip
      attributes_count = table[x + 1].size
      features[type] = {}
      (attributes_count - 1).times do |y|
        name = table[0][y + 1].value
        features[type][name] = table[x + 1][y + 1].value.to_i
      end
    end

    json.TOTAL 6666
    json.NAME 'TOTAL'
    json.LAYER_ORDER sheet_names

    json.LAYERS do
      sheet_names.each do |name|
        json.set! name do
          worksheet = workbook[name]
          rows = worksheet.sheet_data.size
          length = worksheet.sheet_data[0].size
          with_subtype = length >= 6
          combined = length == 7
          if worksheet[1][4].value != 'NONE'
            condition = worksheet[1][4].value
            result = condition.split(' ')
            json.CONDITION do
              json.LAYER result[0]
              json.REQUIREMENT result[1]
              json.VALUE result[2].upcase
            end
          end
          json.TRAITS do
            json.array! rows.times do |n|
              next if n.zero?

              if worksheet[n][0].value.upcase == 'NONE'
                json.NAME 'NONE'
              else
                json.NAME worksheet[n][0].value
                path = [name.split('-')[0]]
                path << worksheet[n][5].value if with_subtype
                fname = worksheet[n][0].value
                fname.strip!
                path << "#{fname}.png"
                json.FILE path.join('/')
              end
              dist = worksheet[n][2].value
              dist = worksheet[n][6].value if combined
              json.DIST dist
              json.RARITY worksheet[n][3].value
              rarity = worksheet[n][3].value
              rarity.strip!
              if features[rarity]
                json.EXTRA do
                  features[rarity].each_key do |key|
                    json.set! key, features[rarity][key]
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

File.open('meta.json', 'w') { |file| file.write(json.target!) }
