# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    if is_a? Array
      i = 0
      while i < size
        yield(self[i])
        i += 1
      end
    elsif is_a? Hash
      while i < size
        yield(values[i], keys[i])
        i += 1
      end
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    arr_to_work = self
    if arr_to_work.is_a? Array
      i = 0
      while i < arr_to_work.length
        yield(arr_to_work[i], i)
        i += 1
      end
    elsif arr_to_work.is_a? Hash
      j = 0
      while j < arr_to_work.length
        yield([arr_to_work.keys[j], arr_to_work.values[j]], j)
        j += 1
      end
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    arr_to_work = self
    if is_a? Array
      myarr = []
      arr_to_work.my_each do |item|
        myarr.push(item) if yield(item)
      end
    elsif is_a? Hash
      myarr = {}
      arr_to_work.my_each do |k, v|
        myarr[k] = v if yield(k, v)
      end
    end
    myarr
  end

  def my_all?(pattern = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return true unless block_given? || !pattern.nil?

    arr_to_work = self
    if pattern
      arr_to_work.my_each do |item|
        return false unless item.is_a? pattern
      end
    elsif is_a? Array
      arr_to_work.my_each do |item|
        return false unless yield(item)
      end
    elsif is_a? Hash
      arr_to_work.my_each do |k, v|
        return false unless yield(k, v)
      end
    end
    true
  end

  def my_any?(pattern = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return false unless block_given? || !pattern.nil?

    arr_to_work = self
    if pattern
      arr_to_work.my_each do |item|
        return true if item.is_a? pattern
      end

    elsif is_a? Array
      arr_to_work.my_each do |item|
        return true if yield(item)
      end
    elsif is_a? Hash
      arr_to_work.my_each do |k, v|
        return true if yield(k, v)
      end
    end
    false
  end

  def my_none?(pattern = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return true unless block_given? || !pattern.nil?

    arr_to_work = self
    if pattern
      arr_to_work.my_each do |item|
        return true unless item.is_a? pattern
      end
    elsif is_a? Array
      arr_to_work.my_each do |item|
        return true unless yield(item)
      end
    elsif is_a? Hash
      arr_to_work.my_each do |k, v|
        return false if yield(k, v)
      end
    end
    false
  end

  def my_count(xxx = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return length unless block_given? || !xxx.nil?

    arr_to_work = self
    counter = 0
    if !xxx.nil?
      arr_to_work.my_each do |item|
        counter += 1 if item == xxx
      end
    elsif is_a? Array
      arr_to_work.my_each do |item|
        counter += 1 if yield(item)
      end
    elsif is_a? Hash
      arr_to_work.my_each do |k, v|
        counter += 1 if yield(k, v)
      end
    end
    counter
  end

  def my_map
    return to_enum unless block_given?

    arr_to_work = self
    new_array = []
    if is_a? Array
      arr_to_work.my_each do |k|
        new_array.push(yield(k))
      end
    elsif is_a? Hash
      arr_to_work.my_each do |k, v|
        new_array.push(yield(k, v))
      end
    end
    new_array
  end

  def my_inject(*args) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    my_arr = to_a
    if block_given?
      my_arr = to_a
      result = args[0].nil? ? my_arr[0] : args[0]
      my_arr.shift if args[0].nil?
      my_arr.each do |number|
        result = yield(result, number)
      end
    elsif !block_given?
      my_arr = to_a
      if args[1].nil?
        symbol = args[0]
        result = my_arr[0]
        my_arr[1..-1].my_each do |i|
          result = result.send(symbol, i)
        end
      elsif !args[1].nil?
        symbol = args[1]
        result = args[0]
        my_arr.my_each do |i|
          result = result.send(symbol, i)
        end
      end
    end
    result
  end
end

def multiply_els(arg)
  arg.my_inject(:*)
end
p multiply_els([2, 4, 5])

# double = Proc.new { |num| num * 2 }
# p [1, 2, 3].my_map(&double).my_map { |num| num * 2 }
abc = [a: 2, b: 3, c: 4]
abc.my_each { |a| puts "a #{a} and b #{a}" }
