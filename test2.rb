
# hash = Hash.new
# arr = Array.new

# Vaccination.where(age: "2m").each do |v|
#     vac = Hash.new
    
#     vac["disease"] = v.disease
#     vac["vaccine_value"] = v.vaccine_value
#     vac["vaccination_count"] = v.vaccination_count
#     vac["order"] = v.order
    
#     arr << vac    
# end

# puts("key: " + h.keys)
# puts("value: " + h.values)
# puts(arr[0]["disease"])

arr = [{"disease"=>"디프테리아, 파상풍, 백일해", "vaccine_value"=>"DTaP", "vaccination_count"=>5, "order"=>"1차"}, {"disease"=>"폴리오", "vaccine_value"=>"IPV", "vaccination_count"=>4, "order"=>"1차"}, {"disease"=>"b형헤모필루스인플루엔자(뇌수막염)", "vaccine_value"=>"PRP-T/HbOC", "vaccination_count"=>4, "order"=>"1차"}, {"disease"=>"폐렴구균", "vaccine_value"=>"PCV(단백결합)", "vaccination_count"=>4, "order"=>"1차"}, {"disease"=>"로타바이러스", "vaccine_value"=>"RV1", "vaccination_count"=>2, "order"=>"1차"}, {"disease"=>"로타바이러스", "vaccine_value"=>"RV5", "vaccination_count"=>3, "order"=>"1차"}] 

for i in 0..arr.count do
   puts(arr[i]["disease"]); 
end