# frozen_string_literal: true

module POO
  class SortedSet
    include Enumerable

    # --- Constructors ---------------------------------------------------------

    def self.[](*items, &cmp)
      new(items, &cmp)
    end

    def initialize(enum = nil, &cmp)
      @cmp = cmp || ->(a, b) { a <=> b }
      @ary = []
      merge(enum) if enum
    end

    # --- Basic queries --------------------------------------------------------

    def size = @ary.size
    def length = @ary.length
    def empty? = @ary.empty?

    def to_a = @ary.dup

    def inspect
      "#<SortedSet: {#{@ary.map(&:inspect).join(', ')}}>"
    end
    alias to_s inspect

    # --- Iteration ------------------------------------------------------------

    def each(&blk)
      return enum_for(:each) unless blk
      @ary.each(&blk)
      self
    end

    def reverse_each(&blk)
      return enum_for(:reverse_each) unless blk
      @ary.reverse_each(&blk)
      self
    end

    # --- Membership -----------------------------------------------------------

    def include?(x)
      i = lower_bound(x)
      i < @ary.length && compare(@ary[i], x).zero?
    end
    alias member? include?

    # --- Mutation -------------------------------------------------------------

    def add(x)
      i = lower_bound(x)
      return self if i < @ary.length && compare(@ary[i], x).zero?

      @ary.insert(i, x)
      self
    end
    alias << add

    def delete(x)
      i = lower_bound(x)
      @ary.delete_at(i) if i < @ary.length && compare(@ary[i], x).zero?
      self
    end

    def clear
      @ary.clear
      self
    end

    def merge(enum)
      enum.each { |x| add(x) }
      self
    end

    # --- Set relations --------------------------------------------------------

    def subset?(other)
      other = coerce_set(other)
      return true if empty?
      return false if size > other.size

      each { |x| return false unless other.include?(x) }
      true
    end

    def superset?(other)
      other = coerce_set(other)
      other.subset?(self)
    end

    def proper_subset?(other)
      other = coerce_set(other)
      subset?(other) && size < other.size
    end

    def proper_superset?(other)
      other = coerce_set(other)
      superset?(other) && size > other.size
    end

    # --- Set operations -------------------------------------------------------

    # union
    def |(other)
      other = coerce_set(other)
      out = self.class.new(nil, &@cmp)
      out.merge(self)
      out.merge(other)
      out
    end
    alias union |

    # intersection
    def &(other)
      other = coerce_set(other)
      out = self.class.new(nil, &@cmp)
      # iteramos el más chico por eficiencia
      a, b = (size <= other.size) ? [self, other] : [other, self]
      a.each { |x| out.add(x) if b.include?(x) }
      out
    end
    alias intersection &

    # difference
    def -(other)
      other = coerce_set(other)
      out = self.class.new(nil, &@cmp)
      each { |x| out.add(x) unless other.include?(x) }
      out
    end
    alias difference -

    # --- Equality / hashing ---------------------------------------------------

    def ==(other)
      return true if equal?(other)
      return false unless other.respond_to?(:each) && other.respond_to?(:size)
      return false unless size == other.size

      # Misma semántica que Set: igualdad por elementos (no por identidad)
      # pero acá nuestro contenido está ordenado, así que podemos comparar arrays
      if other.is_a?(SortedSet)
        @ary == other.to_a
      else
        # fallback: comprobar membresía
        each { |x| return false unless other.include?(x) }
        true
      end
    end

    def eql?(other) = self == other

    def hash
      # consistente con eql?
      [self.class, @ary].hash
    end

    # --- Private helpers ------------------------------------------------------

    private

    def coerce_set(obj)
      return obj if obj.is_a?(SortedSet)
      # permitimos enumerables (Array, Set, etc.) como "set" para operaciones
      tmp = self.class.new(nil, &@cmp)
      tmp.merge(obj)
      tmp
    end

    def compare(a, b)
      r = @cmp.call(a, b)
      if r.nil?
        raise ArgumentError, "comparision of #{a.inspect} with #{b.inspect} failed"
      end
      r
    end

    # primer índice i tal que @ary[i] >= x
    def lower_bound(x)
      lo = 0
      hi = @ary.length
      while lo < hi
        mid = (lo + hi) / 2
        if compare(@ary[mid], x) < 0
          lo = mid + 1
        else
          hi = mid
        end
      end
      lo
    end
  end
end
