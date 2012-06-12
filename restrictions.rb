module Restrictions
  def restrictions_meet?
    return g_restriction?
  end

  def g_restriction?
    (0..n - 1).each do |j|
      (0..i - 1).each do |ic|
        return false if (g[ic][j][0] + g[ic][j][1] != g[ic][j][4] + g[ic][j][5]) ||
          (g[ic][j][2] + g[ic][j][3] != g[ic][j][6] + g[ic][j][7])
      end
    end
    return true
  end

  # Notes:
  # Restriction #7 is verified when n is set
  # Restrictions #6 #8 #9 #11 are verified automatically when solution space is created
end
