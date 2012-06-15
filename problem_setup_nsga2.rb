require "./nsga2"
require "./eval_context"
require "./functions"
require "./restrictions"
require "./solutions"
require "csv"

def print_solutions(vectors, context, n)
  csv = CSV.open("solutions/solutions#{n}.csv", "wb", { col_sep: ";", force_quotes: true })
  vectors.each do |vector|
    context.generate_solution(vector)
    csv << ["SOLUCION [#{vector.join(", ")}]"]
    (0...context.n - 1).each do |jc|
      csv << ["k = fase", "1", "2", "3", "4", "5", "6", "7", "8", "Cio", "PHIio"]
      csv << ["m = movimiento", "WBL", "EBT", "NBL", "SBT", "EBL", "WBT", "SBL", "NBT"]
      (0...context.i).each do |ic|
        rows = ["g#{ic+1}#{jc+1}m int##{ic+1}"]
        (0...context.m).each do |mc|
          rows << [context.g[ic][jc][mc]]
        end
        rows << [context.c[ic][jc]]
        rows << [context.p[ic][jc]]
        csv << rows
      end

      (0...context.i).each do |ic|
        rows = ["X#{ic+1}#{jc+1}m int##{ic+1}"]
        (0...context.m).each do |mc|
          rows << [context.x(ic, jc, mc)]
        end
        csv << rows
      end

      (0...context.i).each do |ic|
        rows = ["S#{ic+1}#{jc+1}m int##{ic+1}"]
        (0...context.m).each do |mc|
          rows << [context.s[ic][mc]]
        end
        csv << rows
      end
      (0...context.i).each do |ic|
        rows = ["q#{ic+1}#{jc+1}m int##{ic+1}"]
        (0...context.m).each do |mc|
          rows << [(context.q[ic][jc][mc][0] + context.q[ic][jc][mc][1])]
        end
        csv << rows
      end
      csv << [""]
      csv << [""]
    end
    csv << [""]
    csv << [""]
    csv << [""]
  end
  csv.close
end

context = EvalContext.new(Functions, Solutions, Restrictions)
context.load_variables("info.json")
options = {
  :problem_size => 2,
  :search_space => Array.new(2) {|i| [0, 10]},
  :max_gens => 50,
  :pop_size => 40,
  :p_cross => 0.98
}

(10..13).each do |n|
  context.n = n
  puts "n: #{n}"
  csv = CSV.open("solutions/pareto#{n}.csv", "wb")
  nsga2_instance = Nsga2.new(context, options)
  archive = nsga2_instance.search
  objectives = archive.map{ |x| x[:objectives] }
  objectives.each{ |o| csv << o }
  vectors = archive.map{ |v| v[:vector] }
  print_solutions(vectors, context, n)
  csv.close
end
