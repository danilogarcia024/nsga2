module Restrictions
  def restrictions_meet?
    return problem_restrictions?
  end

  def problem_restrictions?
    #restriccion 7 se verifica al construir el n
    #resticcion 6, 8, 9, 11 se verifican automaticamente al crear el espacio de sol.  
    (0..n-1).each do |j|
      (0..i-1).each do |ic|
        #p g
        if g[ic][j][0] + g[ic][j][1] != g[ic][j][4] + g[ic][j][5]
          return false
        end

        if g[ic][j][2] + g[ic][j][3] != g[ic][j][6] + g[ic][j][7]
          return false
        end
      end  
    end
  end    
end
