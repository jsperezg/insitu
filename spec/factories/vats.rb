FactoryGirl.define do
  factory :vat do
    sequence :label do |n|
      "#{22  + n} %"
    end

    sequence :rate do |n|
      22 + n
    end
  end

end
