FactoryBot.define do

  factory :user do
    id                    {"1"}
    nickname              {"sample"}
    email                 {"sample@gmail.com"}
    password              {"aaaaaa123"}
    password_confirmation {"aaaaaa123"}
    family_name           {"山田"}
    first_name            {"太郎"}
    family_name_kana      {"やまだ"}
    first_name_kana       {"たろう"}
    birthday              {"19990627"}
    # birthday(1i)            {"2000"}
    # birthday(2i)            {"6"}
    # birthday(3i)            {"27"}
    destination_family_name {"山田"}
    destination_first_name  {"太郎"}
    destination_family_name_kana {"やまだ"}
    destination_first_name_kana  {"たろう"}
    postal_code           {"111-1111"}
    prefecture_id         {"1"}
    city                  {"練馬区"}
    house_number          {"南大泉１−１−１"}

  end

end 