module Solutions
  # cpow: [1, 5]
  # gpow: [1, 5]
  def generate_solution(vector)
    #p vector    
    cpow, gpow = vector
    #cpow = cpow.to_i
    #gpow = gpow.to_i
    @g = Array.new(i){ Array.new(n){ Array.new(m) } }
    @c = Array.new(i){ Array.new(n) }
    @q = Array.new(i){ Array.new(n) { Array.new(m) { Array.new(2) } } }
    #@g = Array.new(i){ Array.new(n) { Array.new(m) } }

    (0...i).each do |ic|
      c[ic][0] = ci[ic].to_f
      c[ic][n-1] = cf[ic].to_f
      (0...m).each do |mc|
        q[ic][0][mc][0] = qi[mc][ic] * 0.98
        q[ic][0][mc][1] = qi[mc][ic] * 0.02
        g[ic][0][mc] = gi[mc][ic].to_f
        q[ic][n - 1][mc][0] = qf[mc][ic] * 0.98
        q[ic][n - 1][mc][1] = qf[mc][ic] * 0.02
        g[ic][n - 1][mc] = gf[mc][ic].to_f
      end
    end

    (0...i).each do |ic|
      (0...m).each do |mc|
        (1...n - 1).each do |j|
          q[ic][j][mc][0] = q[ic][j - 1][mc][0] +  (q[ic][n - 1][mc][0] - q[ic][0][mc][0]) / n.to_f
          q[ic][j][mc][1] = q[ic][j - 1][mc][1] +  (q[ic][n - 1][mc][1] - q[ic][0][mc][1]) / n.to_f
        end
      end
    end

    (0...i).each do |ic|
      (0...m).each do |mc|
        (1...n - 1).each do |j|
          g[ic][j][mc] = g[ic][0][mc] +  (g[ic][n - 1][mc] - g[ic][0][mc]) * ((j/n.to_f) ** gpow)
        end
      end
    end

    (0...i).each do |ic|
      (1...n - 1).each do |j|
         c[ic][j] = c[ic][0] + (c[ic][n - 1] - c[ic][0]) * ((j/n.to_f) ** cpow)
         #p "ic=#{ic}"
         #p "j=#{j}"
      end
    end

    #p q
  end

  # num:  [10, 13]
  def n
    @n
  end

  def n=(num)
    @n = num
  end

  def q
    @q
  end

  def c
    @c
  end

  def q
    @q
  end

  def g
    @g
  end
end
