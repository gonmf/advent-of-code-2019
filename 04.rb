# problem 1

total = 0

(1..9).each do |v1|
  (v1..9).each do |v2|
    (v2..9).each do |v3|
      (v3..9).each do |v4|
        (v4..9).each do |v5|
          (v5..9).each do |v6|
            if v1 == v2 || v2 == v3 || v3 == v4 || v4 == v5 || v5 == v6
              v = [v1, v2, v3, v4, v5, v6].map(&:to_s).join.to_i
              if v >= 172930 && v <= 683082
                total += 1
              end
            end
          end
        end
      end
    end
  end
end

p total

# problem 2

total = 0

(1..9).each do |v1|
  (v1..9).each do |v2|
    (v2..9).each do |v3|
      (v3..9).each do |v4|
        (v4..9).each do |v5|
          (v5..9).each do |v6|
            if [v1, v2, v3, v4, v5, v6].group_by { |v| v }.values.any? { |v| v.size == 2}
              v = [v1, v2, v3, v4, v5, v6].map(&:to_s).join.to_i
              if v >= 172930 && v <= 683082
                total += 1
              end
            end
          end
        end
      end
    end
  end
end

p total
