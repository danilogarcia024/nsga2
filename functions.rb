# q, c, g must be generated
module Functions
  def objectives
    [:objective_x, :objective_y, :objective_z]
  end

  def objective_x
    s0 = 0
    (0...n).each do |jc|
      s1 = 0
      (0...i).each do |ic|
        s2 = 0
        (0...m).each do |mc|
          sv1 = orijmv[0] * d(ic, jc, mc, 0)
          sv2 = orijmv[1] * d(ic, jc, mc, 1)
          s3 = sv1 + sv2
          s2 = s2 + s3
        end
        s1 = s1 + s2 * svt
      end
      s0 = s0 + s1
    end
    #p "objective_x = #{s0}"    
    s0
  end

  def objective_y
    s0 = 0
    (0...n).each do |jc|
      s1 = 0
      (0...i).each do |ic|
        s2 = 0
        (0...m).each do |mc|
          sv1 = sfcv[0] * fc(ic, jc, mc, 0)
          sv2 = sfcv[1] * fc(ic, jc, mc, 1)
          s3 = sv1 + sv2
          s2 = s2 + s3
        end
        s1 = s1 + s2
      end
      s0 = s0 + s1
    end
    #p "objective_y=#{s0}"    
    s0
  end

  def objective_z
    s0 = 0
    (0...n).each do |jc|
      s1 = 0
      (0...i).each do |ic|
        s2 = 0
        (0...e).each do |ec|
          s3 = 0
          (0...m).each do |mc|
            sv1 = sfcv[0] * ge(ic, jc, mc, 0, ec)
            sv2 = sfcv[1] * ge(ic, jc, mc, 1, ec)
            s4 = sv1 + sv2
          end
          s2 = s2 + scge[ec]*s3
        end
        s1 = s1 + s2
      end
      s0 = s0 + s1
    end
    #p "objective_z=#{s0}"    
    s0
  end

  def d(ic, jc, mc, v)
    q[ic][jc][mc][v] * (d1(ic, jc, mc) * fpf(ic, jc, mc)) + d2(ic, jc, mc)
  end

  def d1(ic, jc, mc)
     #p "ic=#{ic}"
     #p "jc=#{jc}"
     #p "mc=#{mc}"
     #p "c #{c[ic][jc]}"
     ((0.5 * c[ic][jc] * (1 - g[ic][jc][mc] / c[ic][jc]) * (1 - g[ic][jc][mc] / c[ic][jc])) /
     ( 1 - ([1, x(ic, jc, mc)].min * g[ic][jc][mc] / c[ic][jc])))
  end

  def x(ic, jc, mc)
    #puts "q #{q[ic][jc][mc][0]}\n q #{q[ic][jc][mc][1]} \n c #{c[ic][jc]} \n g #{g[ic][jc][mc]} \n s #{s[ic][jc][mc]}"    
    #p "q[ic][jc][mc][0] #{q[ic][jc][mc][0]}"
    #p "q[ic][jc][mc][1] #{q[ic][jc][mc][1]}"
    #p "c[ic][jc] #{c[ic][jc]}"
    #p "g[ic][jc][mc] #{g[ic][jc][mc]}"
    #puts "ic=#{ic} jc=#{jc} mc=#{mc} s #{s}"
    #puts s[ic].size   
    (q[ic][jc][mc][0] + q[ic][jc][mc][1])  * c[ic][jc] / (g[ic][jc][mc] * s[ic][mc])
  end

  def d2(ic, jc, mc)
    900 * tf * ((x(ic, jc, mc) - 1) + Math.sqrt((x(ic, jc, mc) - 1) * (x(ic, jc, mc) - 1) + (8 * k * fl(ic, jc, mc) * x(ic, jc, mc)) / (bQ(ic, jc, mc) * tf)))
  end

  # "big Q"
  def bQ(ic, jc, mc)
    #p "s[ic][jc][mc] #{s[ic][jc][mc]}"
    #p "g[ic][jc][mc] #{g[ic][jc][mc]}"
    #p "c[ic][jc] #{c[ic][jc]}"    
    (s[ic][mc].to_f * g[ic][jc][mc].to_f) / c[ic][jc].to_f
  end

  def fc(ic, jc, mc, v)
    q[ic][jc][mc][v] * (f1v[v] * xm + fp3v[v] * h(ic, jc, mc, v)) + (f2v[v] * d(ic, jc, mc, v))
  end

  def h(ic, jc, mc, v)   
    #p "ic=#{ic}"
    #p "jc=#{jc}"
    #p "mc=#{mc}"
    #p "v=#{v}"    
    #p "u(ic, jc, mc) #{u(ic, jc, mc)}"
    #p "y(ic, jc, mc) #{y(ic, jc, mc)}"
    #p "no(ic, jc, mc) #{no(ic, jc, mc)}"
    #p "q[ic][jc][mc][v] #{q[ic][jc][mc][v]}"
    #p "c[ic][jc] #{c[ic][jc]}"    
    #p "0.9 * ((1.0 - u(ic, jc, mc)) / (1.0 - y(ic, jc, mc)) + (no(ic, jc, mc)) / (q[ic][jc][mc][v] * c[ic][jc])) #{0.9 * ((1.0 - u(ic, jc, mc)) / (1.0 - y(ic, jc, mc)) + (no(ic, jc, mc)) / (q[ic][jc][mc][v] * c[ic][jc]))}"    
    0.9 * ((1.0 - u(ic, jc, mc)) / (1.0 - y(ic, jc, mc)) + (no(ic, jc, mc)) / (q[ic][jc][mc][v] * c[ic][jc]).to_f)
  end

  def u(ic, jc, mc)
    g[ic][jc][mc] / c[ic][jc];
  end

  def y(ic, jc, mc)
    (q[ic][jc][mc][0] + q[ic][jc][mc][1]) / s[ic][mc]
  end

  def no(ic, jc, mc)
    xijmv = x(ic, jc, mc)
    xoijm = xo(ic, jc, mc)
    if (xijmv > xoijm)
      #p "bQ #{bQ(ic, jc, mc)}"
      #p "tf #{tf}"
      #p "z #{z(ic, jc, mc)}"
      #p "Math.sqrtcclea(z(ic, jc, mc) #{Math.sqrt(z(ic, jc, mc))}"
      #p "z(ic, jc, mc) #{z(ic, jc, mc)}"
      #p "(bQ(ic, jc, mc) * tf / 4.0) #{(bQ(ic, jc, mc) * tf / 4.0)}"      
      (bQ(ic, jc, mc) * tf / 4.0) * (z(ic, jc, mc) + Math.sqrt(z(ic, jc, mc) * z(ic, jc, mc) + (12.0 * (xijmv - xoijm)) / (bQ(ic, jc, mc) * tf)))
      #p nno
      #nno
    else
      0
    end
  end

  def xo(ic, jc, mc)
    0.67 + s[ic][mc] * g[ic][jc][mc] / 600.0
  end

  def z(ic, jc, mc)
    x(ic, jc, mc) - 1
  end

  def ge(ic, jc, mc, v, ec)
    #p "h #{h(ic, jc, mc, v)}"
    #p "q #{q[ic][jc][mc][v]}"
    #p "ge1[v][ec] #{ge1[v][ec]}"
    #p "ge2[v][ec] #{ge2[v][ec]}"
    #p "ds[m] #{ds[m]}"
    #p "ge3[v][ec] #{ge3[v][ec]}"
    #p "h(ic, jc, mc, v) #{h(ic, jc, mc, v)}"
    q[ic][jc][mc][v] * (ge1[v][ec] * xm + ge2[v][ec] * ds[mc] + ge3[v][ec] * h(ic, jc, mc, v))
  end
  
  def fpf(ic, jc, mc)
    index = "0.#{((10 * g[ic][jc][mc] / c[ic][jc]).to_i)}"
    pf[index] || 0
  end

  def fl(ic, jc, mc)
    xijm = x(ic, jc, mc)
    return 0.09 if xijm >= 1
    index = "0.#{((10 * xijm).to_i)}0"
    l[index] || l["1.00"]
  end
end
